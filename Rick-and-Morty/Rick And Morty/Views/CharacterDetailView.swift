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
                VStack(alignment: .leading, spacing: 12) {
                    if let c = character as? ShortCharacterDescription {
                        Text(c.shortDescription)
                    }
                    Text(character.description)
                }
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
        NavigationView {
            CharacterDetailView(character: ricks[0])
        }
        NavigationView {
            CharacterDetailView(character: morties[2])

        }
    }
}
