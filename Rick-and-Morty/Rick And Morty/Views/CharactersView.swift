import SwiftUI

struct CharactersView: View {
    let characters: [Character]
    let title: String
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ForEach(characters, id: \.id) { character in
                    CharacterCell(character: character, imagePosition: getImagePosition(character: character))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                }
            }
        }
        .navigationBarTitle(title)
    }
    
    func getImagePosition(character: Character) -> CharacterImagePosition {
        if character is Rick {
            return .right
        }
        else {
            return .left
        }
    }
}

class CharactersViewModel: ObservableObject {
    @Published var characters: [Character] = []
    
    init<Character>(character: Character, title: String) {
        fetchCharacters(character: character)
    }
    
    func fetchCharacters<Character>(character: Character) {
        if character is Rick.Type {
            characters = ricks
        }
        else if character is Morty.Type {
            characters = morties
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView(characters: morties, title: "Morties")
    }
}
