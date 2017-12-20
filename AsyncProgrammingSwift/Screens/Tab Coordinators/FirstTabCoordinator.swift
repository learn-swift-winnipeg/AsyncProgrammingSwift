import UIKit

// MARK: - FirstTabCoordinator

class FirstTabCoordinator: TabCoordinator {
    
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
}

// MARK: - ImageProvider

extension FirstTabCoordinator: ImageProvider {
    
    // Whenever an imageView in our view hierarchy needs image data it calls this method synchronously on the main queue.
    func image(for url: URL) -> UIImage? {
        do {
            if let cachedImage = providers.imageCacheProvider.cachedImage(for: url) {
                return cachedImage
            }
            
            try providers.imageCacheProvider.updateCacheSynchronously(for: url)
            return providers.imageCacheProvider.cachedImage(for: url)
        } catch {
            // TODO: Handle error
            print(error)
            return nil
        }
    }
}
