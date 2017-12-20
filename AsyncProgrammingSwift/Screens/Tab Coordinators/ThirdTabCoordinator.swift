import UIKit

// MARK: - ThirdTabCoordinator

class ThirdTabCoordinator: TabCoordinator {
    
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
    
    // MARK: - Dispatch Queue Related
    
    private var urlsOfImagesCurrentlyBeingUpdated: Set<URL> = []
}

// MARK: - ImageProvider

extension ThirdTabCoordinator: ImageProvider {
    
    // Whenever an imageView in our view hierarchy needs image data it calls this method synchronously on the main queue.
    func image(for url: URL) -> UIImage? {
        
        // Return cached image if available.
        if let cachedImage = providers.imageCacheProvider.cachedImage(for: url) {
            return cachedImage
        }
        
        // Make sure image isn't already being fetched or we'll be duplicating network requests and UI refreshing work. The interested views will be notified by the original fetch request when the image data is available.
        guard urlsOfImagesCurrentlyBeingUpdated.contains(url) == false else {
            return nil
        }
        
        // Mark that we're starting the fetch for this url.
        self.urlsOfImagesCurrentlyBeingUpdated.insert(url)
        
        // Dispatch to random background queue provided by GCD to perform image cache update.
        DispatchQueue.global().async {
            do {
                // Note this call is blocking (synchronous) but it doesn't freeze the UI because we're not on the main queue right now, we're on a background queue.
                try self.providers.imageCacheProvider.updateCacheSynchronously(for: url)
                
                // Dispatch back to the (execute closure on the) main queue because it will trigger UIKit api calls and we only touch the UI from the main queue.
                DispatchQueue.main.async {
                    
                    // Remove so the cache can be updated again at a later date if required.
                    self.urlsOfImagesCurrentlyBeingUpdated.remove(url)
                    
                    // Notify interested views that the cache has been updated for this url.
                    self.eventsViewController.notifyInterestedViewsOfUpdatedData(for: url)
                }
            } catch {
                // TODO: Handle error.
                print(error)
            }
        }
        
        // Return nil here because we have to return something, we don't yet have the image data, and the interested view will be notified later when the image data is available.
        return nil
    }
}
