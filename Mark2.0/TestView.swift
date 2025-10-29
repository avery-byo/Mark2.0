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
            
            StyledTextField(placeholder: "Big Idea", text: $engage.bigIdea)
            StyledTextField(placeholder: "Essential Question", text: $engage.essentialQuestion)
            StyledTextField(placeholder: "Challenge", text: $engage.challengeStatement)
            
            if viewModel.isResponding {
                Text("Analyzing...")
                    .italic(true)
                    .padding()
            }
            
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
            }.buttonStyle(GradientPillButtonStyle())
                .disabled(true)
        }
        .padding()
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

            // Trailing send icon (visual only)
            Image(systemName: "paperplane.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .padding(10)
                .background(
                    Circle().fill(Color.accentColor)
                )
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

#Preview {
    TestView()
}
