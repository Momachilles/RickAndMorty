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
    NavigationStack {
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
              CharacterRowView(character: character)
                .background {
                  NavigationLink(value: character) {}
                    .opacity(.zero)
                }
                .onAppear {
                  if character.id == characters.results.last?.id ?? .zero,
                     let next = characters.info.next {
                    Task { await nextCharacters(from: next) }
                  }
                }
              if character.id == characters.results.last?.id ?? .zero {
                Text("Fetch next page.")
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
      .task {
        await fetchCharacters()
      }
      .onChange(of: searchText) { oldValue, newValue in
        Task {
          await fetchCharacters()
        }
    }
    }
  }
  
  private func showError(message: String) {
    viewState = .error(message)
  }
}

extension CharacterListView {
  private func fetchCharacters() async {
    do {
      viewState = try await .characters(api.characters(by: searchText))
    } catch {
      viewState = .error(error.localizedDescription)
    }
  }
  
  private func nextCharacters(from urlString: String) async {
    do {
      viewState = try await .characters(api.characters(by: searchText, next: urlString))
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
