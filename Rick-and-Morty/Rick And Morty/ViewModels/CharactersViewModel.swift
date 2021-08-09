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
        
        self.characters = fetchCharacters()
    }
    
    private func fetchCharacters() -> [Character] {
        return characterType == .rick ? ricks : morties
    }
    
    private func getTitle() -> String {
        return characterType == .rick ? "Ricks" : "Morties"
    }
    
    private func getImagePosition() -> CharacterImagePosition {
        return characterType == .rick ? .right : .left
    }
}

extension CharactersViewModel {
    enum CharacterType {
        case rick
        case morty
    }
}
