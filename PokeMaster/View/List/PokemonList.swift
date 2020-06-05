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

        var pokemonList: AppState.PokemonList { store.appState.pokemonList }

        var body: some View {
            ScrollView {
                TextField("搜索", text: $store.appState.pokemonList.searchText.animation(nil))
                    .frame(height: 40)
                    .padding(.horizontal, 25)
                ForEach(pokemonList.displayPokemons(with: store.appState.settings)) { pokemon in
                    PokemonInfoRow(
                        model: pokemon,
                        expanded: self.pokemonList.selectionState.isExpanding(pokemon.id)
                    )
                    .onTapGesture {
                        self.store.dispatch(.toggleListSelection(index: pokemon.id))
                        self.store.dispatch(.loadAbilities(pokemon: pokemon.pokemon))
                    }
                }
                Spacer()
                    .frame(height: 8)
            }
        }
    }

    struct PokemonList_Previews: PreviewProvider {
        static var previews: some View {
            PokemonList()
        }
    }
