//
//  ResultPage.swift
//  YourProjectName
//
//  Created by Your Name on 2025-10-30.
//

import SwiftUI

struct ResultPage: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ConfettiView()
            
            if let result = viewModel.challengeEvaluationResult {
                VStack(alignment: .leading, spacing: 8) {
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
                    .padding(.top)
                }
                
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
                }
                .buttonStyle(RedGradientPillButtonStyle())
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
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    ResultPage(viewModel: ViewModel())
}
