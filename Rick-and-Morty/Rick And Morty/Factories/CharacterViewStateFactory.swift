import Foundation

final class CharacterViewStateFactory {
    func createCharacterViewState(from character: Character) -> CharacterViewState {
        let shortDescription = getShortDescription(for: character)
        let imagePosition = getImagePosition(for: character)
        
        return CharacterViewState(name: character.name, description: character.description, shortDescription: shortDescription, imageName: character.image, imagePosition: imagePosition)
    }
    
    private func getShortDescription(for character: Character) -> String? {
        if let character = character as? Morty {
            return character.shortDescription
        }
        
        return nil
    }
    
    private func getImagePosition(for character: Character) -> CharacterImagePosition {
        if character is Morty {
            return .left
        } else {
            return .right
        }
    }
}
