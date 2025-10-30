//
//  ResultPage.swift
//  YourProjectName
//
//  Created by Allicia Viona Sagi on 2025-10-30.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
import ImagePlayground

struct ResultPage: View {
    @ObservedObject var viewModel: ViewModel
    let imageURL: URL?
    @State var mascotImage: Image?
    
    var body: some View {
        ZStack {
            ParticleBurst()
                .transition(.scale(scale: 0.4).combined(with: .opacity))
            ConfettiView()
                .transition(.opacity)
            
            #if canImport(UIKit)
                if let imageURL, let uiImage = UIImage(contentsOfFile: imageURL.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 600)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(radius: 8)
                        .padding(.bottom, 12)
                }
            #elseif canImport(AppKit)
                if let imageURL, let nsImage = NSImage(contentsOf: imageURL) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 600)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(radius: 8)
                        .padding(.bottom, 12)
                        .background(.red)
                }
            #endif
            
            if let result = viewModel.challengeEvaluationResult {
                
                HStack {
                    if let mascotImage = mascotImage {
                        mascotImage
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("\(result.evaluation)")
                            .bold()
                            .font(.system(.largeTitle, design: .monospaced))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("\(result.reason)")
                            .font(.system(.body, design: .monospaced))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack  {
                            Text("Improvement Suggestions:")
                                .bold()
                                .font(.system(.title2, design: .monospaced))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            ForEach(result.improvementSuggestions, id: \.self) { suggestion in
                                Text("\(suggestion)")
                                    .font(.system(.body, design: .monospaced))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top)
                    }
                }
                
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                
                
            }
                
        }
        .task {
            do {
                if let cgImage = try await generateImage(from: "An old Cat with \(viewModel.challengeEvaluationResult?.evaluation ?? "")") {
                    await MainActor.run {
                        self.mascotImage = Image(decorative: cgImage, scale: 1, orientation: .up)
                    }
                }
            } catch {
                print("Failed to generate image \(error)")
            }
        }
        .padding()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(
                LinearGradient(colors: [
                    Color.purple.opacity(0.45),
                    Color.blue.opacity(0.45)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private func generateImage(from prompt: String) async throws -> CGImage? {
        let imageCreator = try await ImageCreator()
        let playgroundConcept = ImagePlaygroundConcept.text(prompt)
        let sequence = imageCreator.images(for: [playgroundConcept], style: .animation, limit: 1)
        if let cgimg = try await sequence.first(where: { _ in true })?.cgImage {
            return cgimg
        }

        return nil
    }
    
}

#Preview {
    ResultPage(viewModel: ViewModel(), imageURL: nil)
}

