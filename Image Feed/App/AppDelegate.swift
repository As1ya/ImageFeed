import UIKit
import WebKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = WKWebView()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
       _ application: UIApplication,
       configurationForConnecting connectingSceneSession: UISceneSession,
       options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return sceneConfiguration(for: connectingSceneSession)
    }
    
    // MARK: - Private Methods
    
    private func sceneConfiguration(for session: UISceneSession) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: session.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self   
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

