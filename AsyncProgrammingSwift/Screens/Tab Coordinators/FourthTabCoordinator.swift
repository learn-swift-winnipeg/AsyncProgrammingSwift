import UIKit

// MARK: - FourthTabCoordinator

class FourthTabCoordinator: TabCoordinator {
    
    // MARK: - Stored Properties
    
    let providers: Providers
    let eventsViewController: EventsViewController
    var meetupSchedule: MeetupSchedule?
    
    private let imageCacheUpdatingOperationQueue = OperationQueue()
    private var imageCacheUpdateOperations: [URL: ImageCacheUpdateOperation] = [:]
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        eventsViewController: EventsViewController)
    {
        self.providers = providers
        self.eventsViewController = eventsViewController
        self.eventsViewController.delegate = self
        
        // Limit max concurrent operation count to approximate number of images that can show on screen at a given time. This ensures quick re-prioritization of request when the user scrolls through the table quickly.
        imageCacheUpdatingOperationQueue.maxConcurrentOperationCount = 20
    }
    
    func start() {
        fetchMeetupScheduleAndUpdateUI()
    }
}

// MARK: - ImageProvider

extension FourthTabCoordinator: ImageProvider {
    
    // Whenever an imageView in our view hierarchy needs image data it calls this method synchronously on the main queue.
    func image(for url: URL) -> UIImage? {
        
        // Return cached image if available.
        if let cachedImage = providers.imageCacheProvider.cachedImage(for: url) {
            return cachedImage
        }
        
        // Make sure image isn't already being fetched or we'll be duplicating network requests and loading work. The views will be notified by the original fetch request when the image data is available.
        guard imageCacheUpdateOperations.keys.contains(url) == false else {
            return nil
        }
        
        // Fetch image and update cache asynchronously, and in parallel (concurrently), on background queues using the Operations API. This enables us to prioritize, and later re-prioritize, fetch requests when the user scrolls quickly through the table.
        let imageCacheUpdateOperation = ImageCacheUpdateOperation(
            imageCacheProvider: providers.imageCacheProvider,
            url: url,
            priority: .high,
            resultQueue: .main,
            resultHandler: { result in
                switch result {
                case .failure(let error):
                    // TODO: Handle error.
                    print(error)
                    
                case .success:
                    // Remove so the cache can be updated again at a later date if required.
                    self.imageCacheUpdateOperations.removeValue(forKey: url)
                    
                    // Notify interested views that the cache has been updated for this url.
                    self.eventsViewController.imageDataUpdated(for: url)
                }
            }
        )
        
        // Store this operation so we can prevent duplicate fetches and reprioritize it later.
        imageCacheUpdateOperations[url] = imageCacheUpdateOperation
        imageCacheUpdatingOperationQueue.addOperation(imageCacheUpdateOperation)
        
        // Return nil here because we have to return something, we don't yet have the image data, and the interested view will be notified later when the image data is available.
        return nil
    }
    
    func didUpdateURLsForVisibleImages(urls: [URL]) {
        
        // Here is where the re-prioritization magic happes.
        
        // Lower priority of queued high priority operations (i.e. operations not yet executing).
        
        let queuedHighPriorityOperations = imageCacheUpdateOperations.values
            .filter({ $0.isExecuting == false })
            .filter({ $0.priority == .high })
        
        for highPriorityOperation in queuedHighPriorityOperations {
            // Cancel existing operation.
            highPriorityOperation.cancel()
            
            // Create duplicate operation with a lower priority.
            let lowPriorityOperation = highPriorityOperation.with(priority: .low)
            
            // Store this operation so we can prevent duplicate fetches and reprioritize it later.
            imageCacheUpdateOperations[lowPriorityOperation.url] = lowPriorityOperation
            
            // Add new lower priority operation to queue.
            imageCacheUpdatingOperationQueue.addOperation(lowPriorityOperation)
        }
        
        
        // Raise priority of queued low priority operations for visible urls.
        let queuedLowPriorityOperationsForVisibleURLs = imageCacheUpdateOperations.values
            .filter({ urls.contains($0.url) })
            .filter({ $0.isExecuting == false })
            .filter({ $0.priority == .low })
        
        for lowPriorityOperation in queuedLowPriorityOperationsForVisibleURLs {
            // Cancel existing operation.
            lowPriorityOperation.cancel()
            
            // Create duplicate operation with a higher priority.
            let highPriorityOperation = lowPriorityOperation.with(priority: .high)
            
            // Store this operation so we can prevent duplicate fetches and reprioritize it later.
            imageCacheUpdateOperations[highPriorityOperation.url] = highPriorityOperation
            
            // Add new high priority operation to queue.
            imageCacheUpdatingOperationQueue.addOperation(highPriorityOperation)
        }
    }
}

// MARK: - ImageCacheUpdateOperation

class ImageCacheUpdateOperation: Operation {
    
    // MARK: - Stored Properties
    
    private let imageCacheProvider: ImageCacheProvider
    let url: URL
    
    enum Priority {
        case low, high
    }
    let priority: Priority
    
    private let resultQueue: OperationQueue
    private let resultHandler: (AsyncResult<UIImage>) -> Void
    
    // MARK: - Lifecycle
    
    init(
        imageCacheProvider: ImageCacheProvider,
        url: URL,
        priority: Priority,
        resultQueue: OperationQueue,
        resultHandler: @escaping (AsyncResult<UIImage>) -> Void)
    {
        self.imageCacheProvider = imageCacheProvider
        self.url = url
        self.priority = priority
        self.resultQueue = resultQueue
        self.resultHandler = resultHandler
        
        super.init()
        
        switch priority {
        case .low:
            self.qualityOfService = .background
            self.queuePriority = .low
        case .high:
            self.qualityOfService = .userInitiated
            self.queuePriority = .high
        }
    }
    
    override func main() {
        do {
            try imageCacheProvider.updateCacheSynchronously(for: url)
            let cachedImage = imageCacheProvider.cachedImage(for: url)!
            resultQueue.addOperation { self.resultHandler(.success(cachedImage)) }
        } catch {
            resultQueue.addOperation { self.resultHandler( .failure(error) ) }
        }
    }
    
    // MARK: - Priority Changes
    
    func with(priority: Priority) -> ImageCacheUpdateOperation {
        return ImageCacheUpdateOperation(
            imageCacheProvider: self.imageCacheProvider,
            url: self.url,
            priority: priority,
            resultQueue: self.resultQueue,
            resultHandler: self.resultHandler
        )
    }
}
