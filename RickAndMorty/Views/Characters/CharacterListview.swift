//
//  CharacterListview.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import SwiftUI

struct CharacterListview: View {
  @Environment(RickAndMortyNetworkClient.self) private var api
  
  enum ViewState {
    case loading
    case error(_ errorMessage: String)
    case characters(_ data: Characters)
  }
  
  @State private var viewState: ViewState = .loading
  
  var body: some View {
    VStack {
      switch viewState {
      case .loading:
        Text("Loading characters ...")
        ProgressView()
      case .error(let errorMessage):
        Text("Error: \(errorMessage)")
          .foregroundColor(.red)
      case .characters(let characters):
        List {
          ForEach(characters.results, id: \.id) { character in
            HStack(spacing: 10) {
              AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .empty: ProgressView()
                case .success(let image):
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                case .failure(let error):
                  Image(systemName: "person.crop.circle.badge.exclamationmark")
                @unknown default:
                  Image(systemName: "person.crop.circle.badge.exclamationmark")
                }
              }
              .frame(width: 50, height: 50)
              .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10, bottomTrailing: 10, topTrailing: 10)))
              VStack(alignment: .leading) {
                Text(character.name)
                  .font(.title3)
                Text(character.location.name)
                  .font(.caption)
              }
              Spacer()
              Text("\(character.episode.count) ep.")
            }
          }
        }
        .navigationTitle("R&M Characters")
      }
    }
    .task {
      await fetchCharacters()
    }
  }
  
  private func showError(message: String) {
    viewState = .error(message)
  }
}

extension CharacterListview {
  private func fetchCharacters() async {
    do {
      viewState = try await .characters(api.characters())
    } catch {
      viewState = .error(error.localizedDescription)
    }
  }
}

#Preview {
  NavigationStack {
    CharacterListview()
      .environment(RickAndMortyNetworkClient(networkService: NetworkService()))
  }
}
