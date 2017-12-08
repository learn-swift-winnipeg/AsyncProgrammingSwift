import UIKit

// MARK: - ThirdTabCoordinator

class ThirdTabCoordinator {
    
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
        eventsViewController.view.backgroundColor = .yellow
    }
}
