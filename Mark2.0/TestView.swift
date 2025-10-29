//
//  TestView.swift
//  Mark2.0
//
//  Created by Rizal Hilman on 29/10/25.
//

import SwiftUI


struct TestView: View {
    
    @State private var didSubmit: Bool = false
    @State private var showResult: Bool = false
    @StateObject var viewModel: ViewModel = .init()
    @State var engage: Engage = Engage(bigIdea: "",
                                       essentialQuestion: "",
                                       challengeStatement: "")
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                headerFlavor
                Text("🧠 Big Idea")
                StyledTextField(placeholder: "Big Idea", text: $engage.bigIdea)
                Text("❓ Essential Question")
                StyledTextField(placeholder: "Essential Question", text: $engage.essentialQuestion)
                Text("🧩 Challenge")
                StyledTextField(placeholder: "Challenge", text: $engage.challengeStatement)
                
            }
            
            HStack {
                
                Button {
                    submit()
                } label: {
                    Text("Evaluate Synthesis")
                }.buttonStyle(GradientPillButtonStyle())
                
                
                Button {
                    viewModel.reset()
                } label: {
                    Text("Reset")
                }.buttonStyle(RedGradientPillButtonStyle())
                
                
            }
            
            if let _ = viewModel.challengeEvaluationResult  {
                ZStack {
                    ParticleBurst()
                        .transition(.scale(scale: 0.4).combined(with: .opacity))
                    ConfettiView()
                        .transition(.opacity)
                }
                .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(24)
        .background(
            LinearGradient(
                colors: [.purple.opacity(0.45), .blue.opacity(0.45)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
    
    var headerFlavor: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome, Visionary.")
                .font(.largeTitle.weight(.bold))
            Text("Let's turn that spark into something… marginally impressive. No pressure.")
                .foregroundStyle(.secondary)
        }
    }
    
    var resultSection: some View {
        Section("Result") {
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func submit() {
        Task {
            viewModel.reset()
            await viewModel.generateResponse(for: engage)
        }
        withAnimation(.spring(duration: 0.4)) {
            didSubmit = true
        }
        // Small anticipation delay then explode into result view
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.interpolatingSpring(stiffness: 160, damping: 18)) {
                showResult = true
            }
        }
    }
    
}

