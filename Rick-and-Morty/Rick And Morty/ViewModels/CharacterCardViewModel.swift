import Foundation
import SwiftUI

final class CharacterCardViewModel: ObservableObject {
    @Published var cardState: CharacterCardState
    
    struct CharacterCardState {
        var id: Int
        var name: String
        var imageURL: String
        var statusColor: Color
        var species: String
        var lastLocation: String
        var firstEpisodeName: String
        var status: String
    }
    
    private let character: Character
    private let episodeRepository: EpisodeRepositoryProtocol = EpisodeRepository()
    
    init(character: Character) {
        let cardStateFactory = CharacterCardStateFactory()
        
        self.character = character
        self.cardState = cardStateFactory.createCharacterCardState(from: character)
        
        loadFirstEpisodeName()
    }
    
    func loadFirstEpisodeName() {
        if let firstURL = character.episodeURLs.first {
            episodeRepository.getEpisode(from: firstURL) { episode in
                self.cardState.firstEpisodeName = episode.name
            }
        }
    }
}
