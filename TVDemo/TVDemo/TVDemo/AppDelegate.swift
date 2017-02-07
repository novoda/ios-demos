
import UIKit
import TVMLKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appController: TVApplicationController?
    
    static let TVBaseURL = "http://localhost:9001/"
    static let TVBootURL = "\(AppDelegate.TVBaseURL)js/application.js"

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let appControllerContext = TVApplicationControllerContext()

        if let javaScriptURL = URL(string: AppDelegate.TVBootURL) {
            appControllerContext.javaScriptApplicationURL = javaScriptURL
        }
        
        appControllerContext.launchOptions["baseURL"] = AppDelegate.TVBaseURL
        
        if let launchOptions = launchOptions {
            for (kind, value) in launchOptions {
                appControllerContext.launchOptions[kind.rawValue] = value as AnyObject
            }
        }


        appController = TVApplicationController(context: appControllerContext, window: window, delegate: self)
        return true
    }

}


extension AppDelegate: TVApplicationControllerDelegate {

	func appController(_ appController: TVApplicationController, didFail error: Error) {
		print("\(#function) invoked with error: \(error)")

		let title = "Error Launching Application"
		let message = error.localizedDescription
		let alertController = UIAlertController(title: title, message: message, preferredStyle:.alert)

		self.appController?.navigationController.present(alertController, animated: true, completion: nil)
	}

}
