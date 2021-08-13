//
//  CharacterTileView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-10.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI
import Foundation

struct CharacterCardState {
    var id: Int
    var name: String
    var imageURL: String
    var isAlive: Bool
    var species: String
    var lastLocation: String
    var firstEpisodeURL: String
}

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
    var characterCardState: CharacterCardState
    private let constants: Constants = Constants()
    
    var body: some View {
        HStack(alignment: .top) {
            RemoteImage(url: characterCardState.imageURL)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: constants.VSpacing) {
                VStack(alignment: .leading, spacing: constants.noSpacing) {
                    Text(characterCardState.name)
                        .font(.title)
                        .fontWeight(.black)
                    HStack {
                        Circle()
                            .foregroundColor(characterCardState.isAlive ? .green : .red)
                            .frame(width: 10, height: 10)
                        Text(characterCardState.isAlive ? "Alive - \(characterCardState.species)" : "Dead - \(characterCardState.species)")
                    }
                }
                
                characterDetailsVStack(caption: constants.lastLocationCaption, text: characterCardState.lastLocation)
                
                VStack(alignment: .leading, spacing: constants.noSpacing) {
                    Text(constants.firstEpisodeCaption)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                    FirstEpisodeText(characterCardState: characterCardState)
                }
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
    
    func characterDetailsVStack(caption: String, text: String) -> some View {
        return VStack(alignment: .leading, spacing: constants.noSpacing) {
                        Text(caption)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(text)
        }
    }
}

struct FirstEpisodeText: View {
    let characterCardState: CharacterCardState
    @State var firstEpisode: Episode = Episode(name: "")
    private let episodeRepository: EpisodeRepositoryProtocol = EpisodeRepository()
    
    var body: some View {
        Text(firstEpisode.name)
            .onAppear(perform: {
                episodeRepository.getEpisode(from: characterCardState.firstEpisodeURL) { episode in
                    self.firstEpisode = episode
                }
            })
    }
}


struct CharacterTileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", imageURL: " ", isAlive: true, species: "Human", lastLocation: "Earth", firstEpisodeURL: "Episode 1"))
            }
            .preferredColorScheme(.light)
            VStack {
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", imageURL: " ", isAlive: true, species: "Human", lastLocation: "Earth", firstEpisodeURL: "Episode 1"))
            }
            .preferredColorScheme(.dark)
            
        }
    }
}

