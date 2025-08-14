//
//  FrogAI.swift
//  Turtl
//
//  Created by Charvi Bansal on 7/31/25.
//
import Foundation

class TurtlAI {
    static let shared = FrogAI()
    
    let apiKey = openAIKey
    
    func suggestTime(for task: String, priority: Task.Priority = .medium, deadline: Date = Date(), completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let deadlineString = dateFormatter.string(from: deadline)
        let priorityString = priority.rawValue
        
        let systemPrompt = """
        You are an AI assistant that helps users schedule their tasks optimally. Based on the task description, priority level, and deadline, suggest the best time of day to complete the task.
        
        Consider these factors:
        - High priority tasks should be done earlier in the day
        - Creative tasks work better in the morning when the mind is fresh
        - Administrative tasks can be done in the afternoon
        - Physical tasks might be better in the morning or early afternoon
        - Tasks requiring focus should avoid typical break times
        
        Respond with a concise suggestion like:
        - "Morning (9-11 AM) - Best for creative work and high priority tasks"
        - "Afternoon (2-4 PM) - Good for administrative tasks"
        - "Evening (6-8 PM) - Suitable for planning and review tasks"
        - "Early morning (7-9 AM) - Ideal for important tasks requiring focus"
        
        Keep your response under 100 characters and be specific about the time window.
        """
        
        let userPrompt = """
        Task: \(task)
        Priority: \(priorityString)
        Deadline: \(deadlineString)
        
        When is the best time to complete this task?
        """
        
        let messages: [[String: String]] = [
            ["role": "system", "content": systemPrompt],
            ["role": "user", "content": userPrompt]
        ]
        
        let payload: [String: Any] = [
            "model": "mistralai/mistral-7b-instruct:free",
            "messages": messages,
            "temperature": 0.3,
            "max_tokens": 150
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("TurtlApp (charvi.dev)", forHTTPHeaderField: "HTTP-Referer")
        request.addValue("charvi.dev", forHTTPHeaderField: "X-Title")

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ API Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let choices = json?["choices"] as? [[String: Any]],
                       let msg = choices.first?["message"] as? [String: Any],
                       let suggestion = msg["content"] as? String {
                        
                        // Clean up the suggestion
                        let cleanedSuggestion = suggestion.trimmingCharacters(in: .whitespacesAndNewlines)
                        completion(cleanedSuggestion)
                    } else {
                        print("❌ Could not extract suggestion from response")
                        completion(self.getDefaultSuggestion(for: priority))
                    }
                } catch {
                    print("❌ JSON Parse Error: \(error.localizedDescription)")
                    completion(self.getDefaultSuggestion(for: priority))
                }
            } else {
                print("❌ No data received from API")
                completion(self.getDefaultSuggestion(for: priority))
            }
        }.resume()
    }
    
    private func getDefaultSuggestion(for priority: Task.Priority) -> String {
        switch priority {
        case .high:
            return "Morning (9-11 AM) - Best for high priority tasks"
        case .medium:
            return "Afternoon (2-4 PM) - Good for medium priority tasks"
        case .low:
            return "Evening (6-8 PM) - Suitable for low priority tasks"
        }
    }
}
