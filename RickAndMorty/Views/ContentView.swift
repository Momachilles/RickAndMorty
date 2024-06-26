//
//  ContentView.swift
//  RickAndMorty
//
//  Created by David Alarcon on 25/4/24.
//

import SwiftUI

struct ContentView: View {
  
  var body: some View {
    NavigationStack {
      CharacterListView()
        .environment(RickAndMortyNetworkClient(networkService: NetworkService()))
    }
  }
}

#Preview {
  ContentView()
}
