//
//  PokemonInfoPanelAbilityList.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/26.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

extension PokemonInfoPanel {
    
    struct AbilityList: View {
        
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 12) {
                
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if abilityModels != nil {
                    
                    ForEach(abilityModels!) { ability in
                        
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(self.model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

