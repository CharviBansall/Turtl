//
//  TurtlAI.swift
//  Turtl
//
//  Created by Charvi Bansal on 7/31/25.
//
import Foundation

class TurtlAI {
    static let shared = TurtlAI()
    
    let apiKey = openAIKey
    
    func suggestTime(for task: String, priority: Task.Priority = .medium, deadline: Date = Date(), completion: @escaping (String?) -> Void) {
        // First, try to extract explicit time from the task description
        if let extractedTime = extractTimeFromTask(task) {
            completion(extractedTime)
            return
        }
        
        // If no explicit time found, use AI to suggest optimal time
        suggestOptimalTime(for: task, priority: priority, deadline: deadline, completion: completion)
    }
    
    private func extractTimeFromTask(_ task: String) -> String? {
        let lowercasedTask = task.lowercased()
        
        // Common time patterns
        let timePatterns = [
            // Specific times
            ("(\\d{1,2}):?(\\d{2})?\\s*(am|pm)", "specific_time"),
            ("(\\d{1,2})\\s*(am|pm)", "specific_time"),
            ("(\\d{1,2})\\s*(o'clock|oclock)", "specific_time"),
            
            // Time ranges
            ("(\\d{1,2}):?(\\d{2})?\\s*-\\s*(\\d{1,2}):?(\\d{2})?\\s*(am|pm)", "time_range"),
            
            // Relative times
            ("at\\s+(\\d{1,2}):?(\\d{2})?\\s*(am|pm)", "at_time"),
            ("by\\s+(\\d{1,2}):?(\\d{2})?\\s*(am|pm)", "by_time"),
            ("around\\s+(\\d{1,2}):?(\\d{2})?\\s*(am|pm)", "around_time"),
            
            // Time of day
            ("in\\s+the\\s+(morning|afternoon|evening|night)", "time_of_day"),
            ("(morning|afternoon|evening|night)", "time_of_day"),
            
            // Specific hours
            ("(\\d{1,2})\\s*pm", "pm_time"),
            ("(\\d{1,2})\\s*am", "am_time")
        ]
        
        for (pattern, type) in timePatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(lowercasedTask.startIndex..<lowercasedTask.endIndex, in: lowercasedTask)
                if let match = regex.firstMatch(in: lowercasedTask, options: [], range: range) {
                    let extractedText = String(lowercasedTask[Range(match.range, in: lowercasedTask)!])
                    return formatExtractedTime(extractedText, type: type)
                }
            }
        }
        
        return nil
    }
    
    private func formatExtractedTime(_ timeText: String, type: String) -> String {
        let cleaned = timeText.trimmingCharacters(in: .whitespaces)
        
        switch type {
        case "specific_time", "at_time", "by_time", "around_time":
            return "Explicit time: \(cleaned)"
        case "time_range":
            return "Time range: \(cleaned)"
        case "time_of_day":
            return "Time of day: \(cleaned)"
        case "pm_time":
            return "Afternoon/Evening: \(cleaned)"
        case "am_time":
            return "Morning: \(cleaned)"
        default:
            return "Time: \(cleaned)"
        }
    }
    
    private func suggestOptimalTime(for task: String, priority: Task.Priority, deadline: Date, completion: @escaping (String?) -> Void) {
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
        - Meetings and social tasks should consider typical business hours
        
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
