import UIKit

class CharacterCollectionViewController: UICollectionViewController {
    public var charactersTitle: String?
    public var characters: [Character] = []
    
    override func viewDidLoad() {
        self.navigationItem.title = charactersTitle
                
        // not to sure what this does, but makes things work
        collectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "character-cell-identifier")
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 320, height: 120)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "character-cell-identifier", for:indexPath)
        guard let characterCell = cell as? CharacterCollectionViewCell else {
            return cell
        }

        let character = characters[indexPath.row]
        characterCell.setForCharacter(character: character)

        return characterCell
    }
}
