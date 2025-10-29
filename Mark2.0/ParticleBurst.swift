//
//  ParticleBurst.swift
//  Mark2.0
//
//  Created by Afina R. Vinci on 10/29/25.
//

import Foundation
import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var angle: Angle
    var distance: CGFloat
    var size: CGFloat
    var color: Color
}

struct ParticleBurst: View {
    @State private var particles: [Particle] = []
    var colors: [Color] = [.pink, .purple, .blue, .mint, .orange]
    var count: Int = 60
    var body: some View {
        ZStack {
            ForEach(particles) { p in
                Circle()
                    .fill(p.color)
                    .frame(width: p.size, height: p.size)
                    .offset(x: CGFloat(cos(p.angle.radians)) * p.distance,
                            y: CGFloat(sin(p.angle.radians)) * p.distance)
                    .opacity(0.0)
                    .blur(radius: 0)
                    .modifier(AnimOnAppear(angle: p.angle, distance: p.distance))
            }
        }
        .onAppear { generate() }
    }

    private func generate() {
        particles = (0..<count).map { i in
            let angle = Angle(degrees: Double(i) / Double(count) * 360.0)
            let distance = CGFloat.random(in: 40...220)
            let size = CGFloat.random(in: 4...10)
            let color = colors.randomElement() ?? .pink
            return Particle(angle: angle, distance: distance, size: size, color: color)
        }
    }

    private struct AnimOnAppear: ViewModifier {
        var angle: Angle
        var distance: CGFloat
        @State private var travel: CGFloat = 0
        @State private var opacity: Double = 1
        @State private var blur: CGFloat = 0
        func body(content: Content) -> some View {
            content
                .opacity(opacity)
                .blur(radius: blur)
                .offset(x: CGFloat(cos(angle.radians)) * travel,
                        y: CGFloat(sin(angle.radians)) * travel)
                .onAppear {
                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 18).speed(1.2)) {
                        travel = distance
                        blur = 2
                    }
                    withAnimation(.easeOut(duration: 0.6).delay(0.15)) {
                        opacity = 0
                        blur = 6
                    }
                }
        }
    }
}
