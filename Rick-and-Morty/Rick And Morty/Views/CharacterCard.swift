//
//  CharacterTileView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-10.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI
import Foundation

//enums
private struct Constants {
    let cornerRadius: CGFloat = 10
    let noSpacing: CGFloat = 0
    let VSpacing: CGFloat = 10
    let borderWidth: CGFloat = 0.25
    let cardHeight: CGFloat = 175
    let lastLocationCaption = "Last known location:"
    let firstEpisodeCaption = "First seen in:"
}

struct CharacterCard: View {
    @ObservedObject var cardViewModel: CharacterCardViewModel
    private let constants: Constants = Constants()
    
    var body: some View {
        HStack(alignment: .top) {
            RemoteImage(url: cardViewModel.cardState.imageURL)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: constants.VSpacing) {
                NameAndStatusView(name: cardViewModel.cardState.name, statusColor: cardViewModel.cardState.statusColor, statusText: cardViewModel.cardState.statusText)
                
                DescriptionDetailView(title: constants.lastLocationCaption, text: cardViewModel.cardState.lastLocation)
                
                DescriptionDetailView(title: constants.firstEpisodeCaption, text: cardViewModel.cardState.firstEpisodeName)
            }
            Spacer()
        }
        .cornerRadius(constants.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: constants.cornerRadius)
                .stroke(Color(.lightGray), lineWidth: constants.borderWidth)
        )
        .frame(height: constants.cardHeight)
    }
}

extension CharacterCard {
    private struct DescriptionDetailView: View {
        let title: String
        let text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(text)
            }
        }
    }
    
    private struct NameAndStatusView: View {
        let name: String
        let statusColor: Color
        let statusText: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.title)
                    .fontWeight(.black)
                HStack {
                    Circle()
                        .foregroundColor(statusColor)
                        .frame(width: 10, height: 10)
                    Text(statusText)
                }
            }
        }
    }
}






struct CharacterTileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                CharacterCard(cardViewModel: CharacterCardViewModel(character: Character(id: 1, name: "Morty", species: "Human", lastLocation: LastLocation(name: "Earth", url: ""), status: .alive, imageURL: "", episodeURLs: [])))
            }
            .preferredColorScheme(.light)
            VStack {
                //CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", imageURL: " ", isAlive: true, species: "Human", lastLocation: "Earth", firstEpisodeURL: "Episode 1"))
            }
            .preferredColorScheme(.dark)
            
        }
    }
}

