import Foundation

final class CharactersManager {
    func fetchCharacters(characterType: CharacterType) -> [Character] {
        return characterType == .rick ? ricks : morties
    }
}
