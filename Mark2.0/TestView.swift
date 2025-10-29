//
//  TestView.swift
//  Mark2.0
//
//  Created by Rizal Hilman on 29/10/25.
//

import SwiftUI

struct TestView: View {
    
    @State private var bigIdea: String = ""
    @State private var essentialQuestion: String = ""
    @State private var challenge: String = ""
    @State private var didSubmit: Bool = false
    @State private var showResult: Bool = false
    @FocusState private var focusedField: Field?
    @StateObject var viewModel: ViewModel = .init()
    @State var engage: Engage = Engage(bigIdea: "",
                                       essentialQuestion: "",
                                       challengeStatement: "")
    
    
    enum Field: Hashable { case bigIdea, essentialQuestion, challenge }
    
    struct Particle: Identifiable {
        let id = UUID()
        var angle: Angle
        var distance: CGFloat
        var size: CGFloat
        var color: Color
    }
    
    struct ParticleBurst: View {
        @State private var particles: [Particle] = []
        var colors: [Color] = [.pink, .purple, .blue, .mint, .orange]
        var count: Int = 60
        var body: some View {
            ZStack {
                ForEach(particles) { p in
                    Circle()
                        .fill(p.color)
                        .frame(width: p.size, height: p.size)
                        .offset(x: CGFloat(cos(p.angle.radians)) * p.distance,
                                y: CGFloat(sin(p.angle.radians)) * p.distance)
                        .opacity(0.0)
                        .blur(radius: 0)
                        .modifier(AnimOnAppear(angle: p.angle, distance: p.distance))
                }
            }
            .onAppear { generate() }
        }
        
        private func generate() {
            particles = (0..<count).map { i in
                let angle = Angle(degrees: Double(i) / Double(count) * 360.0)
                let distance = CGFloat.random(in: 40...220)
                let size = CGFloat.random(in: 4...10)
                let color = colors.randomElement() ?? .pink
                return Particle(angle: angle, distance: distance, size: size, color: color)
            }
        }
        
        private struct AnimOnAppear: ViewModifier {
            var angle: Angle
            var distance: CGFloat
            @State private var travel: CGFloat = 0
            @State private var opacity: Double = 1
            @State private var blur: CGFloat = 0
            func body(content: Content) -> some View {
                content
                    .opacity(opacity)
                    .blur(radius: blur)
                    .offset(x: CGFloat(cos(angle.radians)) * travel,
                            y: CGFloat(sin(angle.radians)) * travel)
                    .onAppear {
                        withAnimation(.interpolatingSpring(stiffness: 120, damping: 18).speed(1.2)) {
                            travel = distance
                            blur = 2
                        }
                        withAnimation(.easeOut(duration: 0.6).delay(0.15)) {
                            opacity = 0
                            blur = 6
                        }
                    }
            }
        }
    }
    
    struct ConfettiPiece: Identifiable {
        let id = UUID()
        var x: CGFloat
        var size: CGFloat
        var color: Color
        var rotation: Angle
        var shape: ShapeType
        
        enum ShapeType: CaseIterable { case circle, roundedRect, capsule }
    }
    
    
    struct ConfettiView: View {
        @State private var pieces: [ConfettiPiece] = []
        @State private var fall: CGFloat = -200 // start above
        @State private var opacity: Double = 1
        var colors: [Color] = [.pink, .purple, .blue, .mint, .orange, .yellow, .red]
        var count: Int = 80
        var duration: Double = 14.0
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    ForEach(pieces) { p in
                        pieceView(p)
                            .frame(width: p.size, height: p.size)
                            .rotationEffect(p.rotation)
                            .position(x: p.x, y: fallPosition(in: geo.size))
                            .opacity(opacity)
                            .offset(x: sin((fall + p.x) / 40) * 18)
                            .rotationEffect(.degrees(sin((fall + p.x)/60.0) * 20))
                            .animation(.interpolatingSpring(stiffness: 45, damping: 14).speed(Double.random(in: 0.2...0.5)), value: fall)
                    }
                }
                .onAppear {
                    generate(width: geo.size.width)
                    withAnimation(.easeIn(duration: duration)) {
                        fall = geo.size.height + 200 // fall past bottom
                    }
                    withAnimation(.easeOut(duration: 0.8).delay(max(0, duration - 0.7))) {
                        opacity = 0
                    }
                }
            }
            .allowsHitTesting(false)
        }
        
        private func pieceView(_ p: ConfettiPiece) -> some View {
            Group {
                switch p.shape {
                case .circle:
                    Circle().fill(p.color)
                case .roundedRect:
                    RoundedRectangle(cornerRadius: p.size * 0.3, style: .continuous).fill(p.color)
                case .capsule:
                    Capsule().fill(p.color)
                }
            }
            .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
        }
        
        private func fallPosition(in size: CGSize) -> CGFloat {
            // Each piece gets a slightly different baseline using its x value as seed
            return (fall + CGFloat.random(in: -20...20))
        }
        
        private func generate(width: CGFloat) {
            pieces = (0..<count).map { _ in
                let x = CGFloat.random(in: 0...max(60, width))
                let size = CGFloat.random(in: 6...14)
                let color = colors.randomElement() ?? .pink
                let rotation = Angle.degrees(Double.random(in: 0...360))
                let shape = ConfettiPiece.ShapeType.allCases.randomElement() ?? .circle
                return ConfettiPiece(x: x, size: size, color: color, rotation: rotation, shape: shape)
            }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                content
                    .navigationTitle("Engage Phase (macOS Edition)")
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
    }
    
    @ViewBuilder
    private var content: some View {
#if os(macOS)
        VStack(spacing: 16) {
            headerFlavor
            
            Form {
                Section("🧠 Big Idea") {
                    TextField("Shock us with brilliance… or just type something", text: $engage.bigIdea)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .bigIdea)
                        .help("Go on, be profound. We'll wait.")
                }
                
                Section("❓ Essential Question") {
                    TextField("Ask the question only you can answer", text: $engage.essentialQuestion)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .essentialQuestion)
                        .help("If it's not essential, we won't tell.")
                }
                
                Section("🧩 Challenge") {
                    TextField("Make it spicy (or mildly inconvenient)", text: $engage.challengeStatement)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .challenge)
                        .help("Constraints? We love those.")
                }
                
                Section {
                    Button(action: submit) {
                        HStack { Spacer(); Text("Analyze").font(.headline); Spacer() }
                    }
                    .buttonStyle(GradientPillButtonStyle())
                    .keyboardShortcut(.return, modifiers: [])
                }
                
                if viewModel.isResponding {
                    Text("Analyzing...")
                        .italic(true)
                        .padding()
                }
                
                if let _ = viewModel.challengeEvaluationResult {
                    resultSection
                }
            }
            .formStyle(.grouped)
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
        }
        .padding(24)
        .background(LinearGradient(colors: [.purple.opacity(0.45), .blue.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing))
#else
        // Fallback for other platforms: keep original structure, minus unavailable APIs
        Form {
            Section("Big Idea") {
                TextField("Enter big idea", text: $bigIdea)
            }
            
            Section("Essential Question") {
                TextField("Enter essential question", text: $essentialQuestion)
            }
            
            Section("Challenge") {
                TextField("Enter challenge", text: $challenge)
            }
            
            Section {
                Button(action: submit) {
                    HStack { Spacer(); Text("Submit").font(.headline); Spacer() }
                }
                .disabled(bigIdea.isEmpty || essentialQuestion.isEmpty || challenge.isEmpty)
            }
            
            if didSubmit {
                resultSection
            }
        }
#endif
    }
    
    private var headerFlavor: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome, Visionary.")
                .font(.largeTitle.weight(.bold))
            Text("Let's turn that spark into something… marginally impressive. No pressure.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var resultSection: some View {
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 4)
            }
            
        }
    }
    
    private func submit() {
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

