//
//  CharacterRowView.swift
//  RickAndMorty
//
//  Created by David Alarcon on 2/5/24.
//

import SwiftUI

struct CharacterRowView: View {
  var character: Character
  
  var body: some View {
    HStack(spacing: 10) {
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
  
#Preview {
  if let character = try? DummyCharactersLoader.loadCharacters().results.first {
    return CharacterRowView(character: character)
  } else {
    return Text("Something went wrong.")
  }
}
