//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import SwiftUI

struct CharacterListView: View {
  @Environment(RickAndMortyNetworkClient.self) private var api
  
  enum ViewState {
    case loading
    case error(_ errorMessage: String)
    case characters(_ data: Characters)
  }
  
  @State private var viewState: ViewState = .loading
  @State private var searchText = ""
  
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
        NavigationStack {
          List {
            ForEach(characters.results, id: \.id) { character in
              CharacterRowView(character: character)
                .background {
                  NavigationLink(value: character) {}
                    .opacity(.zero)
                }
            }
          }
          .navigationTitle("R&M Characters")
          .navigationDestination(for: Character.self) { character in
            EpisodeListView(character: character)
          }
          .searchable(text: $searchText, prompt: "Character name")
        }
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

extension CharacterListView {
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
    CharacterListView()
      .environment(RickAndMortyNetworkClient(networkService: NetworkService()))
  }
}
