//
//  EpisodeDetailView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-17.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct EpisodeDetailView: View {
    @ObservedObject var viewModel: EpisodeDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.viewState.name).bold() + Text(" was first aired on ") + Text(viewModel.viewState.airDate).bold()
                Spacer()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("\(viewModel.viewState.name)")
    }
}

/*
struct EpisodeDetailView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationView {
            let episodeDetailViewState = EpisodeDetailViewState(name: "Epiosode the best", airDate: "September 2014", episodeString: "S01E04", characters: [])
            EpisodeDetailView(viewState: episodeDetailViewState)
        }
        
    }
}
*/
