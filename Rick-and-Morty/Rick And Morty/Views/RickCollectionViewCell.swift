import UIKit

class RickCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setForRick(rick: Rick) {
        imageView.image = UIImage(named: rick.image)
        nameLabel.text = rick.name
        descriptionLabel.text = rick.description
    }
    
}
