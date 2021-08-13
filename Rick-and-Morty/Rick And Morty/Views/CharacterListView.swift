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
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
            .navigationTitle("Characters")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
