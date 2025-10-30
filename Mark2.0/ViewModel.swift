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
      "challenge_statement": "..."
    }

    EVALUATION CRITERIA
    Check these 13 points:
    1. Challenge is a call to action, not just a topic.
    2. Big Idea, Essential Question, and Challenge refer to the same overarching concept or domain and the subject is consistent.
    3. The subject group (e.g., kids, adults, teenagers) is consistent.
    4. The Essential Question logically emerges from the Big Idea, and the Challenge concretely answers the Essential Question.
    5. Each level appropriately narrows in scope (Big Idea = broad, EQ = guiding, Challenge = actionable).
    6. Connection and congruity from Big Idea, Essential Question, and Challenge.
    7. Includes personal or contextual relevance (why it matters).
    8. Has available resources (mentors, data, experience).
    9. Does not involve law, health diagnosis, or medical advice.
    10. Actionable → can be done or prototyped with an app.
    11. Proper scope → not too broad or too small.
    12. No fixed solution in the challenge (how) → open for creative exploration.
    13. Clear context → who and where are involved.

    REFERENCE (for few-shot fine-tuning)

    Good Example Challenges:
    - Big Idea: Safety & Responsibility
      Essential Question: How might children understand traffic rules in a safer, more engaging way?
      Challenge: "Making it easier for kids to learn traffic rules safely."
      Reason: Encourages creative approaches (games, visuals, stories).

    - Big Idea: Health & Well-Being
      Essential Question: How might we encourage healthy hydration habits in daily life?
      Challenge: "Create an app to help people drink more water."
      Reason: Mentions an app but not the method; still open for exploration.

    - Big Idea: Everyday Tools in Healthcare Context
      Essential Question: How might dental checkups be supported to spot cavities efficiently?
      Challenge: "Helping dentist to identify cavity."
      Reason: Open for exploration, clear professional context (assistive, not medical advice).

    Bad Example Challenges:
    - Big Idea: Study Skills
      Essential Question: How might people study more effectively?
      Challenge: "Help people study better with pomodoro method."
      Reason: Jumps to a fixed solution, limiting exploration.

    - Big Idea: Language Learning
      Essential Question: How might learners acquire new vocabulary efficiently?
      Challenge: "Help people to learn language using flash card!"
      Reason: Preselects method (flashcards), limits creativity.

    - Big Idea: Environment & Sustainability
      Essential Question: How might communities reduce environmental impact?
      Challenge: "Ending global warming!"
      Reason: Far too broad; not actionable by learners.

    - Big Idea: Inclusive Education (Safety Boundaries)
      Essential Question: How might we better support diverse learning needs?
      Challenge: "Use AI to diagnose learning disorders."
      Reason: Violates rule on health diagnosis; beyond learner scope and ethics.

    Instruction to Model

    Evaluate step by step:
    1. Read input values.
    2. Compare against the 13 criteria.
    3. Decide Good to Go 👍🏻 / Not Good to Go 👎.
    4. Write clear reason and 2 short suggestions.
    Keep answer concise (<80 words total).
    """
    
    @Published var temperature: Double = 0.0
    @Published var maximumResponseTokens: Int = 4000
    
    @Published var challengeEvaluationResult: ChallengeEvaluationResult?
    
    private var hasPrewarmed = false
    
    var languageModelSession: LanguageModelSession?
    
    init() {
        setupLanguageModel()
    }
    
    func setupLanguageModel(){
        languageModelSession = LanguageModelSession(instructions: instructions)
        print("Language model setup complete.")
    }
    
    func prewarmIfNeeded() async {
        guard let languageModelSession else { return }
        if hasPrewarmed { return }
        do {
            try await languageModelSession.prewarm()
            hasPrewarmed = true
            print("Language model prewarmed.")
        } catch {
            // If prewarm fails, allow retry on next trigger
            hasPrewarmed = false
            print("Prewarm failed: \(error)")
        }
    }
    
    func reset(){
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
            
            if let result = response.content as ChallengeEvaluationResult? {
                let numberedSuggestions = result.improvementSuggestions.enumerated().map { index, suggestion in
                    "\(index + 1). \(suggestion)"
                }
                challengeEvaluationResult = ChallengeEvaluationResult(
                    evaluation: result.evaluation,
                    reason: result.reason,
                    improvementSuggestions: numberedSuggestions
                )
            } else {
                challengeEvaluationResult = response.content
            }
            
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

