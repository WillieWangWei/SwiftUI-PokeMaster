//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/26.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {
    @EnvironmentObject var store: Store
    
    let model: PokemonViewModel
    @State var darkBlur = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("切换模糊效果") {
                self.darkBlur.toggle()
            }
            topIndicator
            Group {
                Header(model: model)
                pokemonDescription
            }.animation(nil)
            Divider()
            AbilityList(model: model, abilityModels: store.appState.pokemonList.abilityViewModels(for: model.pokemon))
        }
        .padding(
            EdgeInsets(
                top: 12,
                leading: 30,
                bottom: 30,
                trailing: 30
            )
        )
            .blurBackground(style: darkBlur ? .systemMaterialDark : .systemMaterial)
            .cornerRadius(20)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
    }
}
