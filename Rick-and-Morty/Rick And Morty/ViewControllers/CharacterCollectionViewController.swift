import UIKit

class CharacterCollectionViewController: UICollectionViewController {
    public var charactersTitle: String?
    public var characters: [Character] = []
    
    override func viewDidLoad() {
        self.navigationItem.title = charactersTitle
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 320, height: 120)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let character = characters[indexPath.row]
        
        if let morty = character as? Morty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "morty-cell-identifier", for:indexPath)
            guard let mortyCell = cell as? MortyCollectionViewCell else {
                return cell
            }
            
            mortyCell.setForMorty(morty: morty)
            
            return mortyCell
        }
        
        if let rick = character as? Rick {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rick-cell-identifier", for:indexPath)
            guard let rickCell = cell as? RickCollectionViewCell else {
                return cell
            }
            
            rickCell.setForRick(rick: rick)
            
            return rickCell
        }
        
        return UICollectionViewCell()
    }
}
