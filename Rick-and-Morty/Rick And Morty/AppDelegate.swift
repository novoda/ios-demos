import UIKit
import SwiftUI

// comment out to run swiftUI
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

// comment out to run UIKit and storyboard
@main
struct RickAndMorty: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
