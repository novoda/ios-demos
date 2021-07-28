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
        character is Rick ? .right : .left
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView(characters: ricks, title: "Ricks")
    }
}
