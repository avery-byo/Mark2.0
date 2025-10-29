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
            
            TextField(text: $engage.bigIdea) {
                Text("Big Idea")
            }
            TextField(text: $engage.essentialQuestion) {
                Text("Essential Question")
            }
            
            TextField(text: $engage.challengeStatement) {
                Text("Challenge")
            }
            
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
            }
        }
        .padding()
    }
}

#Preview {
    TestView()
}
