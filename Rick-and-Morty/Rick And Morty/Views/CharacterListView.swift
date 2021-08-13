//
//  ContentView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-28.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct CharacterListViewState {
    let title: String = "Characters"
    var characterCardStates: [CharacterCardState]
}

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel = CharacterListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.characterListViewState.characterCardStates, id: \.id) { cardState in
                CharacterCard(characterCardState: cardState)
                    .onAppear(perform: {
                        if viewModel.isLastCard(characterCardState: cardState) {
                            viewModel.loadCardStates()
                        }
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
