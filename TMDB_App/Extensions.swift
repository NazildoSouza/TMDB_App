//
//  BlurView.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 13/08/20.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        let blur = UIVisualEffectView(effect: effect)
        return blur
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }

}
