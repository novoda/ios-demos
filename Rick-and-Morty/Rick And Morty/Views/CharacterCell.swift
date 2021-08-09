//
//  CharacterCell.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-21.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

enum CharacterImagePosition {
    case left
    case right
}

struct CharacterCell: View {
    let characterViewState: CharacterViewState
    
    var body: some View {
        HStack(spacing: 8) {
            if characterViewState.imagePosition == .left {
                CharacterCellImage(imageName: characterViewState.character.image)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(characterViewState.character.name)
                Text(characterViewState.character.description)
            }
            
            if characterViewState.imagePosition == .right {
                CharacterCellImage(imageName: characterViewState.character.image)
            }
        }
        .padding()
    }
}

struct CharacterCellImage: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
    }
}
/*
struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(character: ricks[0], imagePosition: .left)
    }
}
*/
