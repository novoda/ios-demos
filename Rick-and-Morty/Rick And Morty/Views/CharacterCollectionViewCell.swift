import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setForCharacter(character: Character) {
        imageView.image = UIImage(named: character.image)
        nameLabel.text = character.name
        descriptionLabel.text = character.description
    }
    
}
