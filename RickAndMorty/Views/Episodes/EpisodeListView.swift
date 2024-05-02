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
    Text("Hello, \(character.name)")
  }
}

#Preview {
  if let character = try? DummyCharactersLoader.loadCharacters().results.first {
    return EpisodeListView(character: character)
  } else {
    return Text("Something went wrong.")
  }
}
