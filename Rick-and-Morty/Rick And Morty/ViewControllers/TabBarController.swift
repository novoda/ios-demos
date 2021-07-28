import UIKit
import SwiftUI

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        
        let rickViewController = UIHostingController(rootView: CharactersView(characters: ricks, title: "Ricks"))
        rickViewController.tabBarItem = UITabBarItem(title: "Ricks", image: UIImage(named: "rick-icon"), tag: 1)
        
        let mortyViewController = UIHostingController(rootView: CharactersView(characters: morties, title: "Morties"))
        mortyViewController.tabBarItem = UITabBarItem(title: "Morties", image: UIImage(named: "morty-icon"), tag: 2)
        
        self.setViewControllers([rickViewController, mortyViewController], animated: false)
    }
}
