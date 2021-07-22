import UIKit
import SwiftUI

class CharacterCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier = "character-cell"
    
    private(set) var host: UIHostingController<CharacterCell>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func embed(in parent: UIViewController, withCharacter character: Character, imagePosition: CharacterImagePosition) {
            if let host = self.host {
                host.rootView = CharacterCell(character: character, imagePosition: imagePosition)
                host.view.layoutIfNeeded()
            } else {
                let host = createHostView(parent: parent, character: character, imagePosition: imagePosition)
                self.contentView.addSubview(host.view)
                
                self.host = host
            }
    }
    
    func createHostView(parent: UIViewController, character: Character, imagePosition: CharacterImagePosition) -> UIHostingController<CharacterCell> {
        let host = UIHostingController(rootView: CharacterCell(character: character, imagePosition: imagePosition))
        parent.addChild(host)
        host.didMove(toParent: parent)
        
        host.view.frame = self.contentView.bounds
        
        return host
    }
        
    deinit {
        host?.willMove(toParent: nil)
        host?.view.removeFromSuperview()
        host?.removeFromParent()
        host = nil
    }
}
