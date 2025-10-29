//
//  Challenge.swift
//  Mark2.0
//
//  Created by Afina R. Vinci on 10/29/25.
//

import Foundation

struct Challenge: Hashable, Identifiable {
    let id = UUID()
    let bigIdea: String
    let essentialQuestion: String
    let challenge: String
}
