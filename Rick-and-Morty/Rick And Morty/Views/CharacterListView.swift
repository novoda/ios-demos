import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.characterListViewState.characters, id: \.id) { character in
                    CharacterCard(viewModel: CharacterCardViewModel(character: character))
                        .onAppear(perform: {
                            viewModel.loadIfNeeded(characterID: character.id)
                        })
                }
                
                if viewModel.characterListViewState.state == .error {
                    ErrorView(errorMessage: viewModel.characterListViewState.errorMessage, refreshAction: viewModel.loadCharacters)
                } else if viewModel.characterListViewState.state == .loading {
                    ProgressView()
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(viewModel.characterListViewState.title)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
