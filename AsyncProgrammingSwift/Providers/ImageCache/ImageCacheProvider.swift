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
    
    private(set) var imageCache: [URL: UIImage] = [:]
    private var urlsCurrentlyBeingFetched: Set<URL> = []
    
    private var minFetchDelay: TimeInterval = 1.0
    private var maxFetchDelay: TimeInterval = 2.0
    
    private let images: [UIImage] = [
        #imageLiteral(resourceName: "FirstUI Tab Icon"), #imageLiteral(resourceName: "SecondUI Tab Icon"), #imageLiteral(resourceName: "ThirdUI Tab Icon")
    ]
    
    // MARK: - Cached Image
    
    func cachedImage(for url: URL) -> UIImage? {
        return imageCache[url]
    }
    
    func updateCacheSynchronously(for url: URL) throws {
        let fetchDelay = TimeInterval.random(lower: minFetchDelay, upper: maxFetchDelay)
        usleep(UInt32(fetchDelay * 1_000_000))
        self.imageCache[url] = self.images.random!
    }
}

// MARK: - ProductionImageCacheProvider

class ProductionImageCacheProvider: ImageCacheProvider {
    
    // MARK: - Stored Properties
    
    private(set) var imageCache: [URL: UIImage] = [:]
    private var urlsCurrentlyBeingFetched: Set<URL> = []
    
    // MARK: - Cached Image
    
    func cachedImage(for url: URL) -> UIImage? {
        return imageCache[url]
    }
    
    func updateCacheSynchronously(for url: URL) throws {
        let fetchedImage = try fetchRemoteImageSynchronously(for: url)
        self.imageCache[url] = fetchedImage
    }
    
    // MARK: - Fetching
    
    func fetchImageAsynchronously(
        for url: URL,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<UIImage>) -> Void)
    {
        DispatchQueue.global().async {
            // Return cached image if available.
            if let cachedImage = self.imageCache[url] {
                resultQueue.async { resultHandler( .success(cachedImage) ) }
                return
            }
            
            // Make sure image isn't already being fetched or we'll be duplicating network requests and loading work.
            guard self.urlsCurrentlyBeingFetched.contains(url) == false else {
                let error = ImageCacheError.fetchAlreadyInProgress(for: url)
                resultQueue.async { resultHandler( .failure(error) ) }
                return
            }
            
            do {
                self.urlsCurrentlyBeingFetched.insert(url)
                let fetchedImage = try self.fetchRemoteImageSynchronously(for: url)
                
                DispatchQueue.main.async {
                    self.imageCache[url] = fetchedImage
                    self.urlsCurrentlyBeingFetched.remove(url)
                    resultQueue.async { resultHandler( .success(fetchedImage) ) }
                }
            } catch {
                resultQueue.async { resultHandler( .failure(error) ) }
            }
        }
    }
    
    private func fetchRemoteImageSynchronously(for url: URL) throws -> UIImage {
        let imageData = try Data(contentsOf: url, options: [])
        guard let image = UIImage(data: imageData) else {
            throw ImageCacheError.failedToCreateImageFromData(for: url)
        }
        return image
    }
}
