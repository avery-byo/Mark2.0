//
//  ConfettiView.swift
//  Mark2.0
//
//  Created by Allicia Viona Sagi on 29/10/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    @State private var fall: CGFloat = -200 // start above
    @State private var opacity: Double = 1
    var colors: [Color] = [.pink, .purple, .blue, .mint, .orange, .yellow, .red]
    var count: Int = 80
    var duration: Double = 14.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { p in
                    pieceView(p)
                        .frame(width: p.size, height: p.size)
                        .rotationEffect(p.rotation)
                        .position(x: p.x, y: fallPosition(in: geo.size))
                        .opacity(opacity)
                        .offset(x: sin((fall + p.x) / 40) * 18)
                        .rotationEffect(.degrees(sin((fall + p.x)/60.0) * 20))
                        .animation(.interpolatingSpring(stiffness: 45, damping: 14).speed(Double.random(in: 0.2...0.5)), value: fall)
                }
            }
            .onAppear {
                generate(width: geo.size.width)
                withAnimation(.easeIn(duration: duration)) {
                    fall = geo.size.height + 200 // fall past bottom
                }
                withAnimation(.easeOut(duration: 0.8).delay(max(0, duration - 0.7))) {
                    opacity = 0
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    private func pieceView(_ p: ConfettiPiece) -> some View {
        Group {
            switch p.shape {
            case .circle:
                Circle().fill(p.color)
            case .roundedRect:
                RoundedRectangle(cornerRadius: p.size * 0.3, style: .continuous).fill(p.color)
            case .capsule:
                Capsule().fill(p.color)
            }
        }
        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
    }
    
    private func fallPosition(in size: CGSize) -> CGFloat {
        // Each piece gets a slightly different baseline using its x value as seed
        return (fall + CGFloat.random(in: -20...20))
    }
    
    private func generate(width: CGFloat) {
        pieces = (0..<count).map { _ in
            let x = CGFloat.random(in: 0...max(60, width))
            let size = CGFloat.random(in: 6...14)
            let color = colors.randomElement() ?? .pink
            let rotation = Angle.degrees(Double.random(in: 0...360))
            let shape = ConfettiPiece.ShapeType.allCases.randomElement() ?? .circle
            return ConfettiPiece(x: x, size: size, color: color, rotation: rotation, shape: shape)
        }
    }
}

#Preview {
    ConfettiView()
}
