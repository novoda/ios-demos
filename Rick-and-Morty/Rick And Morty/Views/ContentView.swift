//
//  ContentView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-28.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            CharactersView(characters: ricks, title: "Ricks")
                .tabItem {
                    Label("Ricks", image: "rick-icon")
                }
            CharactersView(characters: morties, title: "Morties")
                .tabItem {
                    Label("Morties", image: "morty-icon")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
