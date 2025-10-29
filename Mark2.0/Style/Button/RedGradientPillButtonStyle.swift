//
//  RedGradientPillButtonStyle.swift
//  Mark2.0
//
//  Created by Allicia Viona Sagi on 29/10/25.
//

import SwiftUI

// MARK: - Red Gradient Pill Button Style
struct RedGradientPillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(
                        LinearGradient(colors: [
                            Color.red, Color.red.opacity(0.7)
                        ], startPoint: .leading, endPoint: .trailing)
                    )
            )
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}
