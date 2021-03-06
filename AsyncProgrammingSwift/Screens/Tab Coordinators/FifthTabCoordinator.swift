import UIKit

// MARK: - FifthTabCoordinator

class FifthTabCoordinator: TabCoordinator {
    
    // MARK: - Stored Properties
    
    let providers: Providers
    let eventsViewController: EventsViewController
    var meetupSchedule: MeetupSchedule?
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        eventsViewController: EventsViewController)
    {
        self.providers = providers
        self.eventsViewController = eventsViewController
        self.eventsViewController.delegate = self
    }
    
    func start() {
        fetchMeetupScheduleAndUpdateUI()
    }
    
    // MARK: - Operation Queue Related
    
    private let imageCacheUpdatingOperationQueue = OperationQueue()
    private var imageCacheUpdateOperations: [URL: ImageCacheUpdateOperation] = [:]
}

// MARK: - ImageProvider

extension FifthTabCoordinator: ImageProvider {
    
    // Whenever an imageView in our view hierarchy needs image data it calls this method synchronously on the main queue.
    func image(for url: URL) -> UIImage? {
        // Return cached image if available.
        return providers.imageCacheProvider.cachedImage(for: url)
    }
    
    func willDisplayImages(for urls: [URL]) {
        // Fetch all images for this cell before updating view.
        
        // Make sure image isn't already being fetched or we'll be duplicating network requests and UI refreshing work. The interested views will be notified by the original fetch request when the image data is available.
        let urlsRequiringFetch = urls.filter({ self.imageCacheUpdateOperations.keys.contains($0) == false })
        
        // Create completionOperation which will only execute after all the ImageCacheUpdateOperations have completed.
        let completionOperation = BlockOperation(block: {
            DispatchQueue.main.async {
                for url in urlsRequiringFetch {
                    // Remove so the cache can be updated again at a later date if required.
                    self.imageCacheUpdateOperations.removeValue(forKey: url)
                    
                    // Notify interested views that the cache has been updated for this url.
                    self.eventsViewController.notifyInterestedViewsOfUpdatedData(for: url)
                }
            }
        })
        
        // Create an ImageCacheUpdateOperation for each url which will fetch and update cache asynchronously, and in parallel (concurrently), on background queues using the Operations API.
        let imageCacheUpdateOperations = urlsRequiringFetch.map { url -> ImageCacheUpdateOperation in
            let imageCacheUpdateOperation = ImageCacheUpdateOperation(
                imageCacheProvider: providers.imageCacheProvider,
                url: url,
                priority: .high,
                resultQueue: .main,
                resultHandler: { _ in }
            )
            
            // Make the completionOperation dependent on every imageCacheUpdateOperation completing first.
            completionOperation.addDependency(imageCacheUpdateOperation)
            
            // Store this operation so we can prevent duplicate fetches and reprioritize it later.
            self.imageCacheUpdateOperations[url] = imageCacheUpdateOperation
            
            return imageCacheUpdateOperation
        }
        
        // Add operations to queue which starts executing them immediately.
        imageCacheUpdatingOperationQueue.addOperation(completionOperation)
        imageCacheUpdatingOperationQueue.addOperations(
            imageCacheUpdateOperations,
            waitUntilFinished: false
        )
    }
}
