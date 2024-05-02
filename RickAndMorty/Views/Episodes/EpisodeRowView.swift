//
//  EpisodeRowView.swift
//  RickAndMorty
//
//  Created by David Alarcon on 2/5/24.
//

import SwiftUI

struct EpisodeRowView: View {
  @Environment(RickAndMortyNetworkClient.self) private var api
  
  enum ViewState {
    case loading
    case error(_ errorMessage: String)
    case episode(_ data: Episode)
  }
  
  @State private var viewState: ViewState = .loading
  
  var urlString: String
  
  var body: some View {
    VStack {
      switch viewState {
      case .loading:
        Text("Loading episode ...")
        ProgressView()
      case .error(let errorMessage):
        Text("Error: \(errorMessage)")
          .foregroundColor(.red)
      case .episode(let episode):
        VStack(alignment: .leading, spacing: 10) {
          Text(episode.name)
            .font(.headline)
          HStack {
            Text(episode.episode)
              .font(.subheadline)
            Spacer()
            Text(episode.airDate)
              .font(.subheadline)
          }
        }
      }
    }
    .task {
      await fetchEpisode(from: urlString)
    }
  }
  
  private func fetchEpisode(from urlString: String) async {
    do {
      viewState = try await .episode(api.episode(from: urlString))
    } catch {
      viewState = .error(error.localizedDescription)
    }
  }
}

#Preview {
  EpisodeRowView(urlString: "https://rickandmortyapi.com/api/episode/28")
    .environment(RickAndMortyNetworkClient(networkService: NetworkService()))
}
