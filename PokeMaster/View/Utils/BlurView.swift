//
//  BlurView.swift
//  PokeMaster
//
//  Created by 王炜 on 2019/12/26.
//  Copyright © 2019 Willie. All rights reserved.
//

import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .clear
        
        let blurView = UIVisualEffectView()
        blurView.tag = 1
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BlurView>) {
        
        if let blurView = uiView.viewWithTag(1) as? UIVisualEffectView {
            blurView.effect = UIBlurEffect(style: style)
        }
    }
}

extension View {
    
    func blurBackground(style: UIBlurEffect.Style) -> some View {
        ZStack {
            BlurView(style: style)
            self
        }
    }
}
