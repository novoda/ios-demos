//
//  CharacterCell.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-21.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct CharacterCell: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 8) {
            // left handside images for morties
            if character is Morty {
                CharacterCellImage(character: character)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                Text(character.description)
            }
            // right handside images for ricks
            if character is Rick {
                CharacterCellImage(character: character)
            }
        }
        .padding()
    }
}

struct CharacterCellImage: View {
    let character: Character
    
    var body: some View {
        Image(character.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(character: ricks[0])
    }
}