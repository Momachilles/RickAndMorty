//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import SwiftUI

struct CharacterListView: View {
  @Environment(RickAndMortyNetworkClient.self) private var api
  
  @State private var characterList: [Character] = []
  @State private var viewState: ViewState = .loading
  @State private var searchText = ""
  
  private var filteredCharacterList: [Character] {
    searchText.isEmpty ? characterList : characterList.filter { $0.name.contains(searchText) }
  }
  
  enum ViewState {
    case loading
    case error(_ errorMessage: String)
    case characters(_ data: Characters)
  }
  
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
        case .characters(let allCharacters):
          List {
            ForEach(filteredCharacterList, id: \.id) { character in
              CharacterRowView(character: character)
                .background {
                  NavigationLink(value: character) {}
                    .opacity(.zero)
                }
                .onAppear {
                  if character.id == characterList.last?.id ?? .zero,
                     let next = allCharacters.info.next {
                    Task { await nextCharacters(from: next) }
                  }
                }
              if character.id == characterList.last?.id ?? .zero {
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
    }
  }
  
  private func showError(message: String) {
    viewState = .error(message)
  }
}

extension CharacterListView {
  private func fetchCharacters() async {
    do {
      let allCharacters = try await api.characters(by: searchText)
      characterList.append(contentsOf: allCharacters.results)
      viewState = .characters(allCharacters)
    } catch {
      viewState = .error(error.localizedDescription)
    }
  }
  
  private func nextCharacters(from urlString: String) async {
    do {
      let allCharacters = try await api.characters(by: searchText, next: urlString)
      characterList.append(contentsOf: allCharacters.results)
      viewState = .characters(allCharacters)
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
