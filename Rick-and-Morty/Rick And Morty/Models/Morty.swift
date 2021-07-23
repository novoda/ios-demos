import Foundation

struct Morty: Character {
    let id = UUID()
    let name: String
    let image: String
    let shortDescription: String
    let description: String
}
