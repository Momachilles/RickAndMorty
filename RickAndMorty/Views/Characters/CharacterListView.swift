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
  @State private var currentPage = Int.zero
  
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
          VStack {
            List {
              ForEach(filteredCharacterList, id: \.id) { character in
                CharacterRowView(character: character)
                  .background {
                    NavigationLink(value: character) {}
                      .opacity(.zero)
                  }
                  .onAppear {
                    if let lastId = characterList.last?.id,
                       character.id ==  lastId,
                       let next = allCharacters.info.next {
                      Task { await fetchNextCharacters(from: next) }
                    }
                  }
              }
            }
            .navigationTitle("R&M Characters")
            .navigationDestination(for: Character.self) { character in
              EpisodeListView(character: character)
            }
            .searchable(text: $searchText, prompt: "Character name")
          }
          HStack {
            Text("Loaded Pages \(currentPage)/\(allCharacters.info.pages)")
              .font(.subheadline)
            Spacer()
            Text("Characters \(String(format: "%.2f", Double(characterList.count * 100)/Double(allCharacters.info.count)))%")
              .font(.subheadline)
              .statusBar(hidden: false)
          }
          .padding([.leading, .trailing], 10)
        }
      }
      .task {
        if characterList.isEmpty {
          await fetchNextCharacters()
        }
      }
    }
  }
}

extension CharacterListView {
  private func fetchNextCharacters(from urlString: String? = .none) async {
    do {
      let allCharacters = try await api.characters(by: searchText, next: urlString)
      characterList.append(contentsOf: allCharacters.results)
      currentPage += 1
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
