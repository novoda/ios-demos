//
//  ContentView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-28.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        TabView {
            ForEach(contentViewModel.charatersViewStates) { charactersViewState in
                CharactersView(charactersViewState: charactersViewState)
                    .tabItem {
                        Label(charactersViewState.title, image: charactersViewState.iconName)
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
