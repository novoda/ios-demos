import Foundation

final class EpisodeDetailViewModel: ObservableObject {
    @Published var viewState: EpisodeDetailViewState
    
    struct EpisodeDetailViewState {
        let name: String
        let airDate: String
        let episodeString: String
    }
    
    init(episode: Episode) {
        self.viewState = EpisodeDetailViewState(name: episode.name, airDate: episode.airDate, episodeString: episode.episodeString)
    }
}
