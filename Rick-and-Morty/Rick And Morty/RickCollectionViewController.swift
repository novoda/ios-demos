import UIKit

let ricks = [
    Rick(name: "Rick Prime", image: "Rick-2", description: "Rick Prime's appearance is almost identical to the other members of the Council of Ricks. The only difference is that his hair style consists of a large puff of hair on top, with the sides and back of his head shaved."),
    Rick(name: "Quantum Rick", image: "Rick-3", description: "Quantum Rick shares the general appearance of the titular Rick Sanchez, but sports a puffier hairstyle."),
    Rick(name: "Maximums Rickimus", image: "Rick-4", description: "Maximums Rickimus shares the general appearance of Rick Sanchez, though with a different hairstyle."),
    Rick(name: "Riq IV", image: "Rick-5", description: "Riq IV shares the general appearance of Rick Sanchez, though with a much different hairstyle, consisting of 3 spikes, and a long soul patch."),
    Rick(name: "Zeta Alpha Rick", image: "Rick-6", description: "Zeta Alpha Rick shares the general appearance of Rick Sanchez, though with a different hairstyle."),
    Rick(name: "Ricktiminus Sancheziminius", image: "Rick-7", description: "Ricktiminus Sancheziminius shares the general appearance of Rick Sanchez, though with a different hairstyle, and facial hair."),
]

class RickCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        self.title = "Rick"

        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 320, height: 120)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ricks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rick-cell-identifier", for:indexPath)
        guard let rickCell = cell as? RickCollectionViewCell else {
            return cell
        }

        let rick = ricks[indexPath.row]
        rickCell.imageView.image = UIImage(named: rick.image)
        rickCell.nameLabel.text = rick.name
        rickCell.descriptionLabel.text = rick.description

        return rickCell
    }
}
