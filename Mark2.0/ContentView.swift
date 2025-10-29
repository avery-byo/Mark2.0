//
//  ContentView.swift
//  Mark2.0
//
//  Created by Allicia Viona Sagi on 29/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var input: String = ""

    var body: some View {
        VStack {
            Spacer()

            // Styled text field matching the screenshot (only the input, not the bottom row)
            HStack(spacing: 8) {
                TextField("Summarize the latest", text: $input)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18))
                    .padding(.vertical, 14)
                    .padding(.leading, 14)

                Button(action: {}) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(
                            Circle().fill(Color.accentColor)
                        )
                }
                .buttonStyle(.plain)
                .padding(.trailing, 10)
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [
                            Color.purple.opacity(0.35),
                            Color.blue.opacity(0.35)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 6)
            .padding(.horizontal)

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
