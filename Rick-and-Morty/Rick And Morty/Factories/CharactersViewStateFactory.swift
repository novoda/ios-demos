import Foundation

final class CharactersViewStateFactory {
    func createCharactersViewState(characterType: CharacterType, characterViewStates: [CharacterViewState]) -> CharactersViewState {
        let title = getTitle(for: characterType)
        let iconName = getIconName(for: characterType)
        
        return CharactersViewState(title: title, iconName: iconName, characterViewStates: characterViewStates)
    }
    
    private func getTitle(for characterType: CharacterType) -> String {
        return characterType == .rick ? "Ricks" : "Morties"
    }
    
    private func getIconName(for characterType: CharacterType) -> String {
        return characterType == .rick ? "rick-icon" : "morty-icon"
    }
}
