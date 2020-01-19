//
//  MainTab.swift
//  PokeMaster
//
//  Created by 王炜 on 2020/1/17.
//  Copyright © 2020 Willie. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    var body: some View {
        
        TabView {
            
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("asd")
            }
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
