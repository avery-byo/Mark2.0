//
//  TestView.swift
//  Mark2.0
//
//  Created by Rizal Hilman on 29/10/25.
//

import SwiftUI


struct ContentView: View {
    
    @State private var didSubmit: Bool = false
    @State private var showResult: Bool = false
    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    headerFlavor
                    Text("🧠 Big Idea")
                    StyledTextField(placeholder: "Big Idea", text: $viewModel.bigIdea)
                    Text("❓ Essential Question")
                    StyledTextField(placeholder: "Essential Question", text: $viewModel.essentialQuestion)
                    Text("🧩 Challenge")
                    StyledTextField(placeholder: "Challenge", text: $viewModel.challengeStatement)
                }

                HStack {
                    Button {
                        submit()
                    } label: {
                        Text("Evaluate Synthesis")
                    }
                    .buttonStyle(GradientPillButtonStyle())

                    Button {
                        viewModel.reset()
                    } label: {
                        Text("Reset")
                    }
                    .buttonStyle(RedGradientPillButtonStyle())
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

                // Hidden navigation link that triggers when showResult becomes true
                NavigationLink(
                    destination: ResultPage(viewModel: viewModel),
                    isActive: $showResult
                ) {
                    EmptyView()
                }
                .hidden()
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
    }
    
    var headerFlavor: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome, Visionary.")
                .font(.largeTitle.weight(.bold))
            Text("Let's turn that spark into something… marginally impressive. No pressure.")
                .foregroundStyle(.secondary)
        }
    }
    
    func submit() {
        Task {
            viewModel.reset()
            let engage = Engage(bigIdea: viewModel.bigIdea, essentialQuestion: viewModel.essentialQuestion, challengeStatement: viewModel.challengeStatement)
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

