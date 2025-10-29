//
//  ResultView.swift
//  Mark2.0
//
//  Created by Afina R. Vinci on 10/29/25.
//

import SwiftUI

struct ResultView: View {
    let data: Challenge

    var body: some View {
        List {
            
            Section("Evaluation") {
                Text("􀊀")
            }
            Section("Reason") {
                Text("This challenge is too ez la")
            }
            Section("Improvement Suggestion") {
                Text("You need to blablabla")
            }
        }
        .navigationTitle("Summary")
    }
}
