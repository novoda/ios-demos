import Foundation

final class CharactersViewModel: ObservableObject {
    let characterType: CharacterType
    
    @Published var characters: [Character] = []
    var title: String = ""
    var imagePosition: CharacterImagePosition = .right
    
    init(characterType: CharacterType) {
        self.characterType = characterType
        self.title = getTitle()
        self.imagePosition = getImagePosition()
        
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        if characterType == .rick {
            characters = ricks
        } else {
            characters = morties
        }
    }
    
    private func getTitle() -> String {
        if characterType == .rick {
            return "Ricks"
        } else {
            return "Morties"
        }
    }
    
    private func getImagePosition() -> CharacterImagePosition {
        if characterType == .rick {
            return .right
        } else {
            return .left
        }
    }
}

extension CharactersViewModel {
    enum CharacterType {
        case rick
        case morty
    }
}
