import UIKit

class RickCollectionViewController: UICollectionViewController {
    private let service = Service()
    private var ricks: [Rick] = []

    override func viewDidLoad() {
        self.title = "Rick"

        service.getRicks()
            .subscribe { ricks in
                self.ricks = ricks
            }

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
