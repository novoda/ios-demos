import SwiftUI

struct CharactersView: View {
    let charactersViewState: CharactersViewState
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    ForEach(charactersViewState.characterViewStates) { characterViewState in
                        CharacterCell(characterViewState: characterViewState)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                    }
                }
            }
            .navigationBarTitle(charactersViewState.title)
        }
    }
}

/*
struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        //CharactersView(viewModel: CharactersViewModel(characterType: .rick))
        //CharactersView(viewModel: CharactersViewModel(characterType: .morty))
    }
}
*/
