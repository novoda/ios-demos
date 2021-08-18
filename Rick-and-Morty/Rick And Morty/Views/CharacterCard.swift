import SwiftUI
import Foundation

struct CharacterCard: View {
    @ObservedObject var viewModel: CharacterCardViewModel
    
    private enum Constants: CGFloat {
        case cornerRadius = 10
        case noSpacing = 0
        case VSpacing = 8
        case borderWidth = 0.25
        case cardHeight = 175
    }
        
    var body: some View {
        HStack(alignment: .top) {
            RemoteImage(url: viewModel.cardState.imageURL)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading, spacing: Constants.VSpacing.rawValue) {
                NameAndStatusView(name: viewModel.cardState.name, statusColor: viewModel.cardState.statusColor, statusText: viewModel.cardState.statusText)
                
                DescriptionDetailView(title: "Last known location:", text: viewModel.cardState.lastLocation)
                DescriptionDetailView(title: "First seen in:", text: viewModel.cardState.firstEpisodeName)
            }
            Spacer()
        }
        .cornerRadius(Constants.cornerRadius.rawValue)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius.rawValue)
                .stroke(Color(.lightGray), lineWidth: Constants.borderWidth.rawValue)
        )
        .frame(height: Constants.cardHeight.rawValue)
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
                CharacterCard(viewModel: CharacterCardViewModel(character: Character(id: 1, name: "Morty", species: "Human", lastLocation: LastLocation(name: "Earth", url: ""), status: .alive, imageURL: "", episodeURLs: [])))
            }
            .preferredColorScheme(.light)
            VStack {
                //CharacterCard(characterCardState: CharacterCardState(id: 2, name: "Morty", imageURL: " ", isAlive: true, species: "Human", lastLocation: "Earth", firstEpisodeURL: "Episode 1"))
            }
            .preferredColorScheme(.dark)
            
        }
    }
}

