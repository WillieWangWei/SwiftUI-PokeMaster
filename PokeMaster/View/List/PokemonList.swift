//
//  PokemonList.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/25.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        
        ScrollView {
            
            TextField("筛选", text: $store.appState.pokemonList.searchText)
                .padding(.horizontal)
            
            ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.store.appState.pokemonList.expandingIndex == pokemon.id
                )
                    .onTapGesture {
                        if self.store.appState.pokemonList.expandingIndex == pokemon.id {
                            self.store.dispatch(
                                .toggleListSelection(index: nil)
                            )
                        } else {
                            self.store.dispatch(
                                .toggleListSelection(index: pokemon.id)
                            )
                            if self.store.appState.pokemonList.abilityViewModels(for: pokemon.pokemon) == nil {
                                self.store.dispatch(
                                    .loadAbilities(pokemon: pokemon.pokemon)
                                )
                            }
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
