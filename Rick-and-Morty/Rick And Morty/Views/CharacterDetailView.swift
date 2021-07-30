//
//  CharacterDetailView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-30.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        VStack {
            Image(character.image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
            HStack {
                Text(character.description)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle(character.name)
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterDetailView(character: ricks[0])
        CharacterDetailView(character: morties[0])
    }
}
