//
//  RadialEffectView.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 1.07.2024.
//

import SwiftUI
import DesignSystem

struct RadialEffectView: View {
    @State private var animate = false
    @Environment(Theme.self) private var theme
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(theme.tintColor.opacity(Double(3 - i) / 3), lineWidth: 2)
                    .scaleEffect(animate ? 1.5 : 0.5)
                    .animation(
                        Animation.easeOut(duration: 1.0)
                            .repeatForever(autoreverses: false)
                            .delay(Double(i) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    RadialEffectView()
}
