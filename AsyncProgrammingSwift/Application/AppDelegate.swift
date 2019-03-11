import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appCoordinator = AppCoordinator(mainApplicationWindow: window!)
        appCoordinator?.start()
        
        return true
    }
}

