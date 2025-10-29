//
//  ReactionView.swift
//  Mark2.0
//
//  Created by Allicia Viona Sagi on 29/10/25.
//

import SwiftUI
import ImagePlayground

extension ImageCreator {
    /// Temporary shim to satisfy compile until the real ImagePlayground API is wired.
    /// Returns a simple placeholder image rendered from the prompt text.
    func generateImage(from prompt: String) async throws -> UIImage {
        let size = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            // Background
            UIColor.systemGray6.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))

            // Draw a symbol in the center
            if let symbol = UIImage(systemName: "photo")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal) {
                let symbolSize = CGSize(width: 128, height: 128)
                let symbolOrigin = CGPoint(x: (size.width - symbolSize.width) / 2, y: 60)
                symbol.draw(in: CGRect(origin: symbolOrigin, size: symbolSize))
            }

            // Draw prompt text (first line) at the bottom
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.label,
                .paragraphStyle: paragraph
            ]
            let text = String(prompt.prefix(100))
            let textRect = CGRect(x: 24, y: size.height - 120, width: size.width - 48, height: 96)
            (text as NSString).draw(in: textRect, withAttributes: attrs)
        }
        return image
    }
}

struct ReactionView: View {
    @State private var prompt: String = "A photorealistic golden retriever puppy wearing tiny sunglasses, sitting in a field of sunflowers at golden hour, ultra-detailed, 4k"
    @State private var generatedImage: UIImage? = nil
    @State private var isGenerating = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            if let uiImage = generatedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding()
            } else if isGenerating {
                ProgressView("Generating image…")
                    .padding()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .padding()
            } else {
                Text("No image generated")
            }
        }
        .task {
            await generate()
        }
        .navigationTitle("Reaction")
    }
    
    private func generate() async {
        isGenerating = true
        errorMessage = nil
        do {
            let creator = try await ImageCreator()
            let image = try await creator.generateImage(from: prompt)
            generatedImage = image
        } catch {
            errorMessage = error.localizedDescription
        }
        isGenerating = false
    }
}

#Preview {
    ReactionView()
}
