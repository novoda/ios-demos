import SwiftUI

struct CharactersView: View {
    @ObservedObject var viewModel: CharactersViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(viewModel.characters, id: \.id) { character in
                        CharacterCell(character: character, imagePosition: viewModel.imagePosition)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                    }
                }
            }
            .navigationBarTitle(viewModel.title)
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView(viewModel: CharactersViewModel(characterType: .rick))
        CharactersView(viewModel: CharactersViewModel(characterType: .morty))
    }
}
