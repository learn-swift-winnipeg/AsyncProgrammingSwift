import UIKit

enum ImageCacheError: Error {
    case fetchAlreadyPerformed
}

protocol ImageCacheProvider {
    var imageCache: [URL: UIImage] { get }
    
    func fetchAndCacheImageSynchronously(from url: URL) throws
    
    func fetchAndCacheImageAsynchronously(
        from url: URL,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Void>) -> Void
    )
}

class TestingImageCacheProvider: ImageCacheProvider {
    
    // MARK: - Stored Properties
    
    private var imageUrlsAlreadyFetched: Set<URL> = []
    private(set) var imageCache: [URL: UIImage] = [:]
    
    // MARK: - Fetching
    
    func fetchAndCacheImageSynchronously(from url: URL) throws {
        guard imageUrlsAlreadyFetched.contains(url) == false else {
            throw ImageCacheError.fetchAlreadyPerformed
        }
        
        imageUrlsAlreadyFetched.insert(url)
        
        do {
            let imageData = try Data(contentsOf: url, options: [])
            let image = UIImage(data: imageData)
            self.imageCache[url] = image
        } catch {
            imageUrlsAlreadyFetched.remove(url)
            throw error
        }
    }
    
    func fetchAndCacheImageAsynchronously(
        from url: URL,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Void>) -> Void)
    {
        guard imageUrlsAlreadyFetched.contains(url) == false else {
            resultQueue.async {
                let error = ImageCacheError.fetchAlreadyPerformed
                resultHandler( .failure(error) )
            }
            
            return
        }
        
        imageUrlsAlreadyFetched.insert(url)
        
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url, options: [])
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.imageCache[url] = image
                    
                    resultQueue.async { resultHandler( .success(()) ) }
                }
            } catch {
                DispatchQueue.main.async {
                    self.imageUrlsAlreadyFetched.remove(url)
                    resultQueue.async { resultHandler( .failure(error) ) }
                }
            }
        }
    }
}

class ProductionImageCacheProvider: ImageCacheProvider {
    
    // MARK: - Stored Properties
    
    private(set) var imageCache: [URL: UIImage] = [:]
    
    // MARK: - Fetching
    
    func fetchAndCacheImageSynchronously(from url: URL) throws {
        // TODO: Implement.
    }
    
    func fetchAndCacheImageAsynchronously(
        from url: URL,
        resultQueue: DispatchQueue,
        resultHandler: @escaping (AsyncResult<Void>) -> Void)
    {
        // TODO: Implement.
    }
}

