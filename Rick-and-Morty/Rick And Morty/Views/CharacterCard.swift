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
    var image: UIImage
    var isAlive: Bool
    var species: String
    var lastLocation: String
    var firstEpisode: String
}

struct CharacterCard: View {
    var characterCardState: CharacterCardState
    
    private let cornerRadius: CGFloat = 10
    private let noSpacing: CGFloat = 0
    private let VSpacing: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: characterCardState.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: VSpacing) {
                VStack(alignment: .leading, spacing: noSpacing) {
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
                
                VStack(alignment: .leading, spacing: noSpacing) {
                    Text("Last known location:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(characterCardState.lastLocation)
                }
                
                VStack(alignment: .leading, spacing: noSpacing) {
                    Text("First seen in:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(characterCardState.firstEpisode)
                }
            }
            Spacer()
        }
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.lightGray), lineWidth: 0.25)
        )
        .padding()
        .frame(height: 200)
    }
}

struct CharacterTileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", image: UIImage(named: "morty-image")!, isAlive: true, species: "Human", lastLocation: "Earth", firstEpisode: "Episode 1"))
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", image: UIImage(named: "morty-image")!, isAlive: false, species: "Human", lastLocation: "Earth", firstEpisode: "Episode 1"))
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", image: UIImage(named: "morty-image")!, isAlive: true, species: "Human", lastLocation: "Earth", firstEpisode: "Episode 1"))
            }
            .preferredColorScheme(.light)
            VStack {
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", image: UIImage(named: "morty-image")!, isAlive: true, species: "Human", lastLocation: "Earth", firstEpisode: "Episode 1"))
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", image: UIImage(named: "morty-image")!, isAlive: false, species: "Human", lastLocation: "Earth", firstEpisode: "Episode 1"))
                CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", image: UIImage(named: "morty-image")!, isAlive: true, species: "Human", lastLocation: "Earth", firstEpisode: "Episode 1"))
            }
            .preferredColorScheme(.dark)
            
        }
    }
}
