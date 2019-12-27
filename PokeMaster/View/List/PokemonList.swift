//
//  PokemonList.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/25.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    
    @State private var expandingIndex: Int?
    @State private var searchKey: String = ""
    
    var body: some View {
        
        ScrollView {
            
            TextField("筛选", text: $searchKey)
                .padding(.horizontal)
            
            ForEach(PokemonViewModel.all) { pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: self.expandingIndex == pokemon.id
                )
                    .onTapGesture {
                        if self.expandingIndex == pokemon.id {
                            self.expandingIndex = nil
                        } else {
                            self.expandingIndex = pokemon.id
                        }
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                PokemonInfoPanel(model: .sample(id: 1))
            }
        )
            .edgesIgnoringSafeArea(.bottom)
    }
}
