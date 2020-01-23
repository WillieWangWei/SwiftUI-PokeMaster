//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/26.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                Text("Loading...")
                    .onAppear { self.store.dispatch(.loadPokemons) }
            } else if store.appState.pokemonList.error != nil {
                Button(action: {
                    self.store.dispatch(.loadPokemons)
                }) {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .foregroundColor(.gray)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            } else {
                PokemonList().navigationBarTitle("宝可梦列表")
            }
        }
    }
}
