//
//  MainTab.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/17.
//  Copyright © 2020 Willie. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var store: Store
    
    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }
    
    private var selectedPanelIndex: Int? {
        pokemonList.selectionState.panelIndex
    }
    
    var body: some View {
        
        TabView {
            
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("首页")
            }
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .edgesIgnoringSafeArea(.top)
        .overlaySheet(isPresented: pokemonListBinding.selectionState.panelPresented) {
            if self.selectedPanelIndex != nil && self.pokemonList.pokemons != nil {
                PokemonInfoPanel(model: self.pokemonList.pokemons![self.selectedPanelIndex!]!)
            }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
