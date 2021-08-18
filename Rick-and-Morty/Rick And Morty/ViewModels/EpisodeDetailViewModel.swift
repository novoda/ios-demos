import Foundation

final class EpisodeDetailViewModel: ObservableObject {
    @Published var viewState: EpisodeDetailViewState
    
    struct EpisodeDetailViewState {
        let name: String
        let airDate: String
        let episodeString: String
        //let characters: [CharacterCardState]
    }
    
    init(episode: Episode?) {
        if let epi = episode {
            self.viewState = EpisodeDetailViewState(name: epi.name, airDate: epi.airDate, episodeString: epi.episodeString)
        } else {
            viewState = EpisodeDetailViewState(name: "Unknown", airDate: "", episodeString: "")
        }
    }
}
