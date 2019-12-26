//
//  PokemonList.swift.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/25.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    
    var body: some View {
        ScrollView {
            ForEach(PokemonViewModel.all) { pokemon in
                PokemonInfoRow(model: pokemon)
            }
        }
    }
}
