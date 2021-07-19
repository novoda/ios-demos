import UIKit

let morties = [
    Morty(name: "Morty", image: "PM-1", shortDescription: "This is your Morty, don't lose him!", description: "Morty is the Morty you start out with in Pocket Mortys. Along with Cronenberg Morty and Morticia, he is different from all the other Mortys because he has no type (Rock, paper or scissors) and has no great advantage/disadvantage over any type. He is also the only Morty that cannot be released."),
    Morty(name: "Scruffy Morty", image: "PM-2", shortDescription: "This Morty has never much cared for his appearance.", description: "Scruffy Morty is a Rock-type Morty found early in the game. It evolves into Unkempt Morty and later into Hobo Morty."),
    Morty(name: "Ancient Morty", image: "PM-7", shortDescription: "This Morty chose poorly. Dried up and dead to the world, only hatred, cruel fate and years of modern food preservatives keep his wicked heart beating", description: "Ancient Morty appears in the game Pocket Mortys. He is the final evolution of Old Morty."),
    Morty(name: "No Eye Morty", image: "PM-10", shortDescription: "This Morty refuses to talk about his impairment, but some say he lost his eyes when his Rick tried to swap them out for his own.", description: "No Eye Morty appears in the game Pocket Mortys. He evolves into One Eye Morty. His final evolution is Three Eye Morty."),
    Morty(name: "Karate Morty", image: "PM-17", shortDescription: "This Morty is a dedicated practitioner of karate spending 12 hours a day working on his forms, sparring, and strength training. This Morty loves karate more than life.", description: "Karate Morty appears in the game Pocket Mortys."),
    Morty(name: "Ad Space Morty", image: "PM-22", shortDescription: "This Morty is working for free for Jerry. He hopes to never see another apple in his life.", description: "Ad Space Morty appears in the game Pocket Mortys. He evolves into Jerry's Game Morty, which in turn evolves into Pocket Mortys Morty."),
    Morty(name: "Blue Shirt Morty", image: "PM-25", shortDescription: "This Morty does not want to be defined by wearing the same yellow shirt every day, as other Mortys do. He opted for blue, the color of the summer sky and the distant seas.", description: "Blue Shirt Morty appears in the game Pocket Mortys.")
]

class MortyCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        self.title = "Morty"

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
