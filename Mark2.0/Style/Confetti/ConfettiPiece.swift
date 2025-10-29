//
//  ConfettiPiece.swift
//  Mark2.0
//
//  Created by Allicia Viona Sagi on 29/10/25.
//

import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var size: CGFloat
    var color: Color
    var rotation: Angle
    var shape: ShapeType
    
    enum ShapeType: CaseIterable { case circle, roundedRect, capsule }
}
