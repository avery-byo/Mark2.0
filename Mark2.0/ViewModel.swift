//
//  ViewModel.swift
//  Mark2.0
//
//  Created by Rizal Hilman on 29/10/25.
//

import Foundation
import FoundationModels
import Combine

struct Engage {
    var bigIdea: String
    var essentialQuestion: String
    var challengeStatement: String
}

@MainActor
class ViewModel: ObservableObject {
    @Published var isResponding = false
    @Published var errorMessage: String?
    @Published var instructions: String = """
        You are an AI mentor guiding learner teams to self-evaluate their Engage Phase in Challenge-Based Learning (CBL).
        Evaluate the Challenge Statement based on clarity, relevance, and actionability.
        Your goal: help learners decide if their Challenge is ready to move forward or needs improvement.
        Output must be short, structured, and actionable.
        INPUT FORMAT
        Learners provide:
        {
          "big_idea": "...",
          "essential_question": "...",
          "challenge_statement": "...",
        }
        EVALUATION CRITERIA
        Check these 9 points:
        1. Challenge is a call to action, not just a topic.
        2. Connects to the Essential Question and Big Idea.
        3. Includes personal or contextual relevance (why it matters).
        4. Has available resources (mentors, data, experience).
        5. Does not involve law, health diagnosis, or medical advice.
        6. Actionable → can be done or prototyped with an app.
        7. Proper scope → not too broad or too small.
        8. No fixed solution in the challenge (how) → open for creative exploration.
        9. Clear context → who and where are involved
        
        REFERENCE (for few-shot fine-tuning)
        Good Examples Challenges: 
        - "Making it easier for kids to learn traffic rules safely." → reason: Encourages creative approaches (games, visuals, stories).
        - "Create an app to help people drink more water." → reason: It mention an app but still don’t know how the app work, still open for exploration.
        - "Helping dentist to identify cavity" ← reason: open for exploration, have a clear context.
        
        Neutral Example Challenges: 
        - "Build an app for better learning using Foundation Models." → reason: Too broad and context-free; audience, setting, and scope are unclear.
        - "Use AI to diagnose learning disorders." ← reason: if learnes don't have the guiding resources or experiences its going to be difficult
        - "Improve group collaboration with an AI assistant." → reason: Aligned with learning but still generic; may be too wide for timeline
        
        Bad Example Challenges:
        - "Help people study better with pomodoro method" ← reason: jump to solution, limiting other approach
        - "Help people to learn language using flash card!" ← reson: Jump into solution, limiting possibility for other solutions
        - "Ending global warming!" → reason: Way too broad; not actionable by learners.


        Instruction to Model

        Evaluate step by step:
        1. Read input values.
        2. Compare against the 9 criteria.
        3. Decide Good 👍🏻 / Neutral 🖖🏻 / Not Good 👎.
        4. Write clear reason and 2 short suggestions.
        Keep answer concise (<80 words total).
        """
    
    @Published var temperature: Double = 0.0
    @Published var maximumResponseTokens: Int = 4000
    
    @Published var challengeEvaluationResult: ChallengeEvaluationResult?
    
    var languageModelSession: LanguageModelSession?
    
    init() {
        setupLanguageModel()
    }
    
    func setupLanguageModel(){
        languageModelSession = LanguageModelSession(instructions: instructions)
        print("Language model setup complete.")
    }
    
    func reset(){
        setupLanguageModel()
        challengeEvaluationResult = nil
        isResponding = false
        errorMessage = nil
    }
    
    
    
    func generateResponse(for engage: Engage) async {
        do {
            // Update responding status
            challengeEvaluationResult = nil
            isResponding = true
            errorMessage = nil
            
            guard let languageModelSession else { return }
            let options = GenerationOptions(temperature: temperature, maximumResponseTokens: maximumResponseTokens)
            
            
            let prompt = Prompt {
                """
                {
                  "big_idea": "\(engage.bigIdea)",
                  "essential_question": "\(engage.essentialQuestion)",
                  "challenge_statement": "\(engage.challengeStatement)"
                }
                """
            }
            
            let response = try await languageModelSession.respond(to: prompt,
                                                                  generating: ChallengeEvaluationResult.self,
                                                                  options: options)
            
            challengeEvaluationResult = response.content
            print("Response: \(response)")
            
            
            // Update responding status
            isResponding = false
        } catch {
            isResponding = false
            errorMessage = error.localizedDescription
            print("sendMessage error:", error)
        }
    }
}
