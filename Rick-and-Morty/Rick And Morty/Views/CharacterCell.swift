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
    let character: Character
    let imagePosition: CharacterImagePosition
    
    var body: some View {
        NavigationLink(destination: CharacterDetailView(character: character)) {
            HStack(spacing: 8) {
                if imagePosition == .left {
                    CharacterCellImage(character: character)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(character.name)
                    description(for: character)
                }
                
                if imagePosition == .right {
                    CharacterCellImage(character: character)
                }
                Spacer()
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func description(for character: Character) -> Text {
        if let c = character as? ShortCharacterDescription {
            return Text(c.shortDescription)
        }
        
        return Text(character.description)
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
        CharacterCell(character: ricks[0], imagePosition: .left)
    }
}
