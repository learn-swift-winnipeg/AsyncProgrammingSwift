import UIKit

// MARK: - FourthTabCoordinator

class FourthTabCoordinator {
    
    // MARK: - Stored Properties
    
    private let providers: Providers
    private let eventsViewController: EventsViewController
    
    // MARK: - Lifecycle
    
    init(
        providers: Providers,
        eventsViewController: EventsViewController)
    {
        self.providers = providers
        self.eventsViewController = eventsViewController
    }
    
    func start() {
        // TODO: Implement.
        eventsViewController.loadViewIfNeeded()
        eventsViewController.view.backgroundColor = .purple
    }
}
