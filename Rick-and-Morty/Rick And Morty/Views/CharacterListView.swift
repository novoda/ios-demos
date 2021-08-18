import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.characterListViewState.characters, id: \.id) { character in
                CharacterCard(viewModel: CharacterCardViewModel(character: character))
                    .onAppear(perform: {
                        viewModel.loadIfNeeded(characterID: character.id)
                    })
            }
            .buttonStyle(BorderlessButtonStyle())
            .navigationTitle(viewModel.characterListViewState.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
