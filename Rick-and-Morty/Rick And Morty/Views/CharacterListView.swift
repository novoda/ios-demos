//
//  ContentView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-28.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.characterListViewState.characters, id: \.id) { character in
                CharacterCard(cardViewModel: CharacterCardViewModel(character: character))
                    .onAppear(perform: {
                        viewModel.loadIfNeeded(characterID: character.id)
                    })
            }
            .navigationTitle(viewModel.characterListViewState.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
