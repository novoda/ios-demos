import UIKit

class CharacterCollectionViewController: UICollectionViewController {
    public var charactersTitle: String?
    public var characters: [Character] = []
    
    override func viewDidLoad() {
        self.navigationItem.title = charactersTitle
                
        // not to sure what this does, but makes things work
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: 120)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for:indexPath)
        guard let characterCell = cell as? CharacterCollectionViewCell else {
            return cell
        }
        
        let character = characters[indexPath.row]
        
        characterCell.embed(in: self, withCharacter: character)

        return characterCell
    }
}
