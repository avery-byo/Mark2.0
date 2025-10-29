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
    @State private var path: [DetailData] = []

    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section("Big Idea") {
                    TextField("Enter big idea", text: $bigIdea)
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                }

                Section("Essential Question") {
                    TextField("Enter essential question", text: $essentialQuestion)
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                }

                Section("Challenge") {
                    TextField("Enter challenge", text: $challenge)
                        .textInputAutocapitalization(.sentences)
                        .autocorrectionDisabled(false)
                }

                Section {
                    Button(action: submit) {
                        HStack {
                            Spacer()
                            Text("Submit")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .disabled(bigIdea.isEmpty || essentialQuestion.isEmpty || challenge.isEmpty)
                }
            }
            .navigationTitle("Engage Phase")
            .navigationDestination(for: DetailData.self) { data in
                DetailView(data: data)
            }
        }
    }

    private func submit() {
        let data = DetailData(bigIdea: bigIdea, essentialQuestion: essentialQuestion, challenge: challenge)
        path.append(data)
    }
}

struct DetailData: Hashable, Identifiable {
    let id = UUID()
    let bigIdea: String
    let essentialQuestion: String
    let challenge: String
}

struct DetailView: View {
    let data: DetailData

    var body: some View {
        List {
            
            Section("Evaluation") {
                Text("􀊀")
            }
            Section("Reason") {
                Text("This challenge is too ez la")
            }
            Section("Improvement Suggestion") {
                Text("You need to blablabla")
            }
        }
        .navigationTitle("Summary")
    }
}

#Preview {
    ContentView()
}
