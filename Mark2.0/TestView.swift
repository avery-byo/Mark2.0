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
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    headerFlavor
                    Text("🧠 Big Idea")
                    StyledTextField(placeholder: "Big Idea", text: $engage.bigIdea, onTypingBegan: {
                        Task { await viewModel.prewarmIfNeeded() }
                    })
                    Text("❓ Essential Question")
                    StyledTextField(placeholder: "Essential Question", text: $engage.essentialQuestion, onTypingBegan: {
                        Task { await viewModel.prewarmIfNeeded() }
                    })
                    Text("🧩 Challenge")
                    StyledTextField(placeholder: "Challenge", text: $engage.challengeStatement, onTypingBegan: {
                        Task { await viewModel.prewarmIfNeeded() }
                    })
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
                    destination: ResultPage(viewModel: viewModel, imageURL: nil),
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
