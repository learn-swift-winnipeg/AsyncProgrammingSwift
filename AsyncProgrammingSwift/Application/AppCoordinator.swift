import UIKit

// MARK: - AppCoordinator

class AppCoordinator {
    
    // MARK: - Stored Properties
    
    private let mainApplicationWindow: UIWindow
//    private let providers = Providers.forCurrentConfiguration()
    
    // MARK: - Child Coordinators
    
    private var firstTabCoordinator: FirstTabCoordinator?
    private var secondTabCoordinator: SecondTabCoordinator?
    private var thirdTabCoordinator: ThirdTabCoordinator?
    private var fourthTabCoordinator: FourthTabCoordinator?
    
    // MARK: - Lifecycle
    
    init(mainApplicationWindow: UIWindow) {
        self.mainApplicationWindow = mainApplicationWindow
    }
    
    func start() {
        
        // Initialize each tab coordinator with an appropriate view controller.
        
        let firstEventsViewController = EventsViewController.loadFromStoryboard()
        firstEventsViewController.tabBarItem = UITabBarItem(
            title: "Sync Serial",
            image: #imageLiteral(resourceName: "FirstUI Tab Icon"),
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
            image: #imageLiteral(resourceName: "SecondUI Tab Icon"),
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
            image: #imageLiteral(resourceName: "ThirdUI Tab Icon"),
            tag: 3
        )
        thirdTabCoordinator = ThirdTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: thirdEventsViewController
        )
        thirdTabCoordinator?.start()
        
        let fourthEventsViewController = EventsViewController.loadFromStoryboard()
        fourthEventsViewController.tabBarItem = UITabBarItem(
            title: "Async Operations",
            image: #imageLiteral(resourceName: "FourthUI Tab Icon"),
            tag: 4
        )
        fourthTabCoordinator = FourthTabCoordinator(
            providers: Providers.forCurrentConfiguration(),
            eventsViewController: fourthEventsViewController
        )
        fourthTabCoordinator?.start()
        
        
        // Add each tab coordinator's view controller to the tab bar controller.
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([
            firstEventsViewController,
            secondEventsViewController,
            thirdEventsViewController,
            fourthEventsViewController
        ], animated: false)
        
        tabBarController.selectedIndex = 3
        
        
        // Set the tab bar controller as the rootViewController of the main application window.
        
        mainApplicationWindow.rootViewController = tabBarController
        mainApplicationWindow.makeKeyAndVisible()
    }
}
