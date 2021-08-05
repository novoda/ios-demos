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
            let characterViewState = characterViewStateFactory.createCharacterViewState(from: character)
            characterViewStates.append(characterViewState)
        }
        
        return characterViewStates
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
