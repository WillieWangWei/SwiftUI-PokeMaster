//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/13.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct PokemonInfoRow: View {
    
    let model = PokemonViewModel.sample(id: 1)
    
    var body: some View {
        
        VStack {
            
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 5)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 12)
            
            HStack(spacing: 20) {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "star")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                }
                Button(action: {}) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                    
                }
                Button(action: {}) {
                    Image(systemName: "info.circle") .font(.system(size: 25)) .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                }
            }
            
        }
        .background(Color.green)
    }
}
