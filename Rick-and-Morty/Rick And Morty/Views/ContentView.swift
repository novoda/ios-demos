//
//  ContentView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-23.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab(title: "Ricks", image: "rick-icon", characters: ricks)
            Tab(title: "Morties", image: "morty-icon", characters: morties)
        }
    }
}

struct Tab: View {
    let title: String
    let image: String
    let characters: [Character]
    
    var body: some View {
        NavigationView {
            CharactersView(characters: characters, title: title)
        }
        .tabItem {
            Label(title, image: image)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
