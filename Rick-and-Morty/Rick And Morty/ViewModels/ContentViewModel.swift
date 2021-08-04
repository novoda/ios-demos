import Foundation

final class ContentViewModel: ObservableObject {
    @Published var charatersViewStates: [CharactersViewState] = []
    
    private let charactersManager = CharactersManager()
    private let characterViewStateFactory = CharacterViewStateFactory()
    private let charactersViewStateFactory = CharactersViewStateFactory()
    
    init() {
        self.charatersViewStates = getCharactersViewStates()
    }
    
    private func getCharactersViewStates() -> [CharactersViewState] {
        var charactersViewStates: [CharactersViewState] = []
        
        for characterType in CharacterType.allCases {
            let characters = charactersManager.fetchCharacters(characterType: characterType)
            let characterViewStates = getCharacterViewStates(from: characters)
            
            let charactersViewState = charactersViewStateFactory.createCharactersViewState(characterType: characterType, characterViewStates: characterViewStates)
            
            charactersViewStates.append(charactersViewState)
        }
        
        return charactersViewStates
    }
    
    private func getCharacterViewStates(from characters: [Character]) -> [CharacterViewState] {
        var characterViewStates: [CharacterViewState] = []
        
        for character in characters {
            let characterViewState = characterViewStateFactory.createViewState(from: character)
            characterViewStates.append(characterViewState)
        }
        
        return characterViewStates
    }
}


final class CharactersManager {
    func fetchCharacters(characterType: CharacterType) -> [Character] {
        return characterType == .rick ? ricks : morties
    }
}

final class CharacterViewStateFactory {
    func createViewState(from character: Character) -> CharacterViewState {
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


struct CharactersViewState: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let characterViewStates: [CharacterViewState]
}

struct CharacterViewState: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let shortDescription: String?
    let imageName: String
    let imagePosition: CharacterImagePosition
}

enum CharacterType: CaseIterable {
    case rick
    case morty
}
