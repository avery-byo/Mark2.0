//
//  ChallengeEvaluator.swift
//  Mark2.0
//
//  Created by Rizal Hilman on 29/10/25.
//

// RAW JSON
//{
//  "evaluation": "👎 Not Good to Go",
//  "reason": "Involves health diagnosis outside learners’ scope.",
//  "improvement_suggestions": [
//    "Stay within education context.",
//    "Reframe toward improving engagement or reflection."
//  ]
//}
import Foundation
import FoundationModels

@Generable
struct ChallengeEvaluationResult {
    @Guide(description: "Overall verdict for the evaluation, e.g. '👍 Good to Go' or '👎 Not Good to Go'. Keep it short.")
    let evaluation: String
    
    @Guide(description: "One-sentence rationale explaining the verdict. State the key issue or justification clearly.")
    let reason: String
    
    @Guide(description: "When the verdict is not '👍 Good to Go', provide 1–5 concise, imperative suggestions to improve the challenge. If it is '👍 Good to Go', return an empty array.")
    let improvementSuggestions: [String]
}
