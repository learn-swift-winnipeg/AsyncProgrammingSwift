import UIKit

// MARK: - ImageCacheError

enum ImageCacheError: Error {
    case failedToCreateImageFromData(for: URL)
    case fetchAlreadyInProgress(for: URL)
}

// MARK: - ImageCacheProvider

protocol ImageCacheProvider {
    func cachedImage(for url: URL) -> UIImage?
    func updateCacheSynchronously(for url: URL) throws
}

// MARK: - TestingImageCacheProvider

class TestingImageCacheProvider: ImageCacheProvider {
    
    // MARK: - Stored Properties
    
    private var imageCache = NSCache<NSURL, UIImage>()
    private var urlsOfImagesCurrentlyBeingUpdated: Set<URL> = []
    
    private var minFetchDelay: TimeInterval = 1.0
    private var maxFetchDelay: TimeInterval = 3.0
    
    private let images: [UIImage] = [
        #imageLiteral(resourceName: "Number 1"), #imageLiteral(resourceName: "Number 2"), #imageLiteral(resourceName: "Number 3"), #imageLiteral(resourceName: "Number 4"), #imageLiteral(resourceName: "Number 5"), #imageLiteral(resourceName: "Number 6")
    ]
    
    // MARK: - Cached Image
    
    func cachedImage(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url as NSURL)
    }
    
    func updateCacheSynchronously(for url: URL) throws {
        let fetchDelay = TimeInterval.random(lower: minFetchDelay, upper: maxFetchDelay)
        usleep(UInt32(fetchDelay * 1_000_000))
        imageCache.setObject(self.images.random!, forKey: url as NSURL)
    }
}

// MARK: - ProductionImageCacheProvider

class ProductionImageCacheProvider: ImageCacheProvider {
    
    // MARK: - Stored Properties
    
    private var imageCache = NSCache<NSURL, UIImage>()
    private var urlsOfImagesCurrentlyBeingUpdated: Set<URL> = []
    
    // MARK: - Cached Image
    
    func cachedImage(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url as NSURL)
    }
    
    func updateCacheSynchronously(for url: URL) throws {
        let fetchedImage = try fetchRemoteImageSynchronously(for: url)
        self.imageCache.setObject(fetchedImage, forKey: url as NSURL)
    }
    
    // MARK: - Fetching
    
    private func fetchRemoteImageSynchronously(for url: URL) throws -> UIImage {
        let imageData = try Data(contentsOf: url, options: [])
        guard let image = UIImage(data: imageData) else {
            throw ImageCacheError.failedToCreateImageFromData(for: url)
        }
        return image
    }
}
