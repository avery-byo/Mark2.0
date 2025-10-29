//
//  TestView.swift
//  Mark2.0
//
//  Created by Rizal Hilman on 29/10/25.
//

import SwiftUI

struct TestView: View {
    
    @StateObject var viewModel: ViewModel = .init()
    @State var engage: Engage = Engage(bigIdea: "",
                                       essentialQuestion: "",
                                       challengeStatement: "")
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("🧠 Big Idea")
                StyledTextField(placeholder: "Big Idea", text: $engage.bigIdea)
                
                
                Text("❓ Essential Question")
                StyledTextField(placeholder: "Essential Question", text: $engage.essentialQuestion)
                Text("🧩 Challenge")
                StyledTextField(placeholder: "Challenge", text: $engage.challengeStatement)
            }
            
            
            
            if viewModel.isResponding {
                Text("Analyzing...")
                    .italic(true)
                    .padding()
            }
            
            
            HStack {
                Button {
                Task {
                    viewModel.reset()
                    await viewModel.generateResponse(for: engage)
                }
            } label: {
                Text("Analyze")
            }
            .buttonStyle(GradientPillButtonStyle())
                
                // Display analysis result when available
                if let result = viewModel.challengeEvaluationResult {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Result:")
                            .font(.headline)
                        Text("\(result.evaluation)")
                            .font(.system(.body, design: .monospaced))
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
                        
                        HStack  {
                            ForEach(result.improvementSuggestions, id: \.self) { sugestion in
                                Text("\(sugestion)")
                                    .font(.system(.body, design: .monospaced))
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.top)
                    
                    
                }
                
                // Display error if something went wrong
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                
                Button {
                    viewModel.reset()
                } label: {
                    Text("Reset")
                }.buttonStyle(RedGradientPillButtonStyle())
                    .disabled(true)
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
    }
}

private struct StyledTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        HStack(spacing: 8) {
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: 18))
                .padding(.vertical, 14)
                .padding(.leading, 14)
            
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
    }
}

// MARK: - Gradient Pill Button Style
private struct GradientPillButtonStyle: ButtonStyle {
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
                            Color.blue, Color.purple
                        ], startPoint: .leading, endPoint: .trailing)
                    )
            )
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

// MARK: - Red Gradient Pill Button Style
private struct RedGradientPillButtonStyle: ButtonStyle {
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

#Preview {
    TestView()
}
