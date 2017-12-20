import UIKit

// MARK: - AppCoordinator

class AppCoordinator: NSObject {
    
    // MARK: - Stored Properties
    
    private let mainApplicationWindow: UIWindow
    
    // MARK: - Child Coordinators
    
    private var firstTabCoordinator: FirstTabCoordinator?
    private var secondTabCoordinator: SecondTabCoordinator?
    private var thirdTabCoordinator: ThirdTabCoordinator?
    private var fourthTabCoordinator: FourthTabCoordinator?
    private var fifthTabCoordinator: FifthTabCoordinator?
    
    // MARK: - Lifecycle
    
    init(mainApplicationWindow: UIWindow) {
        self.mainApplicationWindow = mainApplicationWindow
    }
    
    func start() {
        
        // Initialize each tab coordinator with an appropriate view controller.
        
        let firstEventsViewController = EventsViewController.loadFromStoryboard()
        firstEventsViewController.tabBarItem = UITabBarItem(
            title: "Sync Serial",
            image: #imageLiteral(resourceName: "Number 1"),
            tag: 1
        )
        firstTabCoordinator = FirstTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: firstEventsViewController
        )
        firstTabCoordinator?.start()
        
        let secondEventsViewController = EventsViewController.loadFromStoryboard()
        secondEventsViewController.tabBarItem = UITabBarItem(
            title: "Async Serial",
            image: #imageLiteral(resourceName: "Number 2"),
            tag: 2
        )
        secondTabCoordinator = SecondTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: secondEventsViewController
        )
        secondTabCoordinator?.start()
        
        let thirdEventsViewController = EventsViewController.loadFromStoryboard()
        thirdEventsViewController.tabBarItem = UITabBarItem(
            title: "Async Parallel",
            image: #imageLiteral(resourceName: "Number 3"),
            tag: 3
        )
        thirdTabCoordinator = ThirdTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: thirdEventsViewController
        )
        thirdTabCoordinator?.start()
        
        let fourthEventsViewController = EventsViewController.loadFromStoryboard()
        fourthEventsViewController.tabBarItem = UITabBarItem(
            title: "Operations",
            image: #imageLiteral(resourceName: "Number 4"),
            tag: 4
        )
        fourthTabCoordinator = FourthTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: fourthEventsViewController
        )
        fourthTabCoordinator?.start()
        
        let fifthEventsViewController = EventsViewController.loadFromStoryboard()
        fifthEventsViewController.tabBarItem = UITabBarItem(
            title: "Dependencies",
            image: #imageLiteral(resourceName: "Number 5"),
            tag: 5
        )
        fifthTabCoordinator = FifthTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: fifthEventsViewController
        )
        fifthTabCoordinator?.start()
        
        
        // Add each tab coordinator's view controller to the tab bar controller.
        
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        
        tabBarController.setViewControllers([
            firstEventsViewController,
            secondEventsViewController,
            thirdEventsViewController,
            fourthEventsViewController,
            fifthEventsViewController,
        ], animated: false)
        
        tabBarController.selectedIndex = mostRecentTabBarSelectionIndex
        
        
        // Set the tab bar controller as the rootViewController of the main application window.
        
        mainApplicationWindow.rootViewController = tabBarController
        mainApplicationWindow.makeKeyAndVisible()
    }
    
    // MARK: - Selected Tab Index
    
    private var mostRecentTabBarSelectionIndex: Int {
        get { return UserDefaults.standard.integer(forKey: UserDefaultsKey.selectedTabIndex) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.selectedTabIndex) }
    }
}

// MARK: - UITabBarControllerDelegate

extension AppCoordinator: UITabBarControllerDelegate {
    
    struct UserDefaultsKey {
        static let selectedTabIndex = "AppCoordinator.UserDefaultsKey.selectedTabIndex"
    }
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController)
    {
        if let selectedIndex = tabBarController.viewControllers?.index(of: viewController) {
            mostRecentTabBarSelectionIndex = selectedIndex
        }
    }
}
