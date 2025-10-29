
//
//  ContentView.swift
//  Mark2.0
//
//  Created by Allicia Viona Sagi on 29/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var bigIdea: String = ""
    @State private var essentialQuestion: String = ""
    @State private var challenge: String = ""
    @State private var didSubmit: Bool = false
    @FocusState private var focusedField: Field?

    enum Field: Hashable { case bigIdea, essentialQuestion, challenge }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Engage Phase (macOS Edition)")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: submit) {
                            Label("Submit", systemImage: "paperplane.fill")
                        }
                        .keyboardShortcut(.return, modifiers: [])
                        .disabled(bigIdea.isEmpty || essentialQuestion.isEmpty || challenge.isEmpty)
                        .help("Ship it. What could possibly go wrong?")
                    }
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
                    TextField("Shock us with brilliance… or just type something", text: $bigIdea)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .bigIdea)
                        .help("Go on, be profound. We'll wait.")
                }

                Section("❓ Essential Question") {
                    TextField("Ask the question only you can answer", text: $essentialQuestion)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .essentialQuestion)
                        .help("If it's not essential, we won't tell.")
                }

                Section("🧩 Challenge") {
                    TextField("Make it spicy (or mildly inconvenient)", text: $challenge)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .challenge)
                        .help("Constraints? We love those.")
                }

                Section {
                    Button(action: submit) {
                        HStack { Spacer(); Text("Submit").font(.headline); Spacer() }
                    }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.return, modifiers: [])
                    .disabled(bigIdea.isEmpty || essentialQuestion.isEmpty || challenge.isEmpty)
                }

                if didSubmit {
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
            VStack(alignment: .leading, spacing: 8) {
                Text("Evaluation: ✅ Stunning. We are dazzled. Totally not biased.")
                Text("Reason: Because you typed words. Revolutionary.")
                Text("Improvement Suggestion: Add constraints, sprinkle ambition, and maybe a plot twist.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func submit() {
        withAnimation(.spring(duration: 0.5)) {
            didSubmit = true
        }
    }
}

#Preview {
    ContentView()
}
