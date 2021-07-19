import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        // Rick tab index: 0
        let rickNavController = self.viewControllers![0] as! UINavigationController
        let rickViewController = rickNavController.topViewController as! CharacterCollectionViewController
        rickViewController.charactersTitle = "Rick"
        rickViewController.characters = ricks
        
        // Morty tab index: 1
        let mortyNavController = self.viewControllers![1] as! UINavigationController
        let mortyViewController = mortyNavController.topViewController as! CharacterCollectionViewController
        mortyViewController.charactersTitle = "Morty"
        mortyViewController.characters = morties
    }
}
