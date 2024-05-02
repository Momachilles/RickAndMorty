//
//  EpisodeListView.swift
//  RickAndMorty
//
//  Created by David Alarcon on 2/5/24.
//

import SwiftUI

struct EpisodeListView: View {
  var character: Character
  
  var body: some View {
    List {
      Section {
        HStack {
          AsyncImage(url: URL(string: character.image)) { phase in
            switch phase {
            case .empty: ProgressView()
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
            case .failure(_):
              Image(systemName: "person.crop.circle.badge.exclamationmark")
            @unknown default:
              Image(systemName: "person.crop.circle.badge.exclamationmark")
            }
          }
          .frame(width: 100, height: 100)
          .clipShape(.rect(cornerRadii: .init(topLeading: 10, bottomLeading: 10, bottomTrailing: 10, topTrailing: 10)))
          Spacer()
          VStack(alignment: .trailing) {
            Text(character.name)
              .font(.title)
            Text(character.location.name)
              .font(.headline)
          }
        }
      }

      Section("Episodes") {

      }
    }
  }
}

#Preview {
  if let character = try? DummyCharactersLoader.loadCharacters().results.first {
    return EpisodeListView(character: character)
  } else {
    return Text("Something went wrong.")
  }
}
