import UIKit

class MortyCollectionViewController: UICollectionViewController {
    private let service = Service()
    private var morties: [Morty] = []

    override func viewDidLoad() {
        self.title = "Morty"

        service.getMorties()
            .subscribe { morties in
                self.morties = morties
            }

        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 320, height: 120)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return morties.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "morty-cell-identifier", for:indexPath)
        guard let mortyCell = cell as? MortyCollectionViewCell else {
            return cell
        }

        let morty = morties[indexPath.row]
        mortyCell.imageView.image = UIImage(named: morty.image)
        mortyCell.nameLabel.text = morty.name
        mortyCell.descriptionLabel.text = morty.description

        return mortyCell
    }
}
