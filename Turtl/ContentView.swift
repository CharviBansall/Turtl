//
//  ContentView.swift
//  Turtl
//
//  Created by Charvi Bansal on 7/31/25.
//

import SwiftUI
import EventKit

// MARK: - Glass Effect Modifiers

struct GlassEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct ThinGlassEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }
}

struct RegularGlassEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CircleGlassEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.thinMaterial)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
            )
    }
}

struct InteractiveModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.1), value: true)
    }
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var priority: Priority
    var deadline: Date
    var isCompleted: Bool = false
    var scheduledTime: Date?
    var aiSuggestion: String?
    
    init(title: String, priority: Priority, deadline: Date) {
        self.id = UUID()
        self.title = title
        self.priority = priority
        self.deadline = deadline
    }
    
    enum Priority: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var emoji: String {
            switch self {
            case .low: return "🟢"
            case .medium: return "🟡"
            case .high: return "🔴"
            }
        }
        
        var displayEmoji: String {
            // Moon icons representing time of day
            switch self {
            case .low: return "🌑" // New moon - night
            case .medium: return "🌓" // Half moon - afternoon
            case .high: return "🌕" // Full moon - morning
            }
        }
        
        var timeDescription: String {
            switch self {
            case .low: return "Night"
            case .medium: return "Afternoon"
            case .high: return "Morning"
            }
        }
    }
}

struct ContentView: View {
    @State private var newTaskTitle = ""
    @State private var selectedPriority: Task.Priority = .medium
    @State private var selectedTimePreference: Task.Priority = .medium
    @State private var deadline = Date()
    @State private var tasks: [Task] = []
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @FocusState private var isTaskInputFocused: Bool
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "tortoise.fill")
                    .foregroundColor(.green)
                Text("Turtl")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .modifier(ThinGlassEffectModifier())
            .padding(.bottom, 8)
            
            // Task Input Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    TextField("What's your turtle today?", text: $newTaskTitle)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isTaskInputFocused)
                        .onSubmit {
                            addTask()
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                HStack {
                    // Date Picker with Icon
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        DatePicker("", selection: $deadline, displayedComponents: .date)
                            .labelsHidden()
                    }
                    
                    // Moon Icon Selector (all three options)
                    HStack(spacing: 4) {
                        ForEach(Task.Priority.allCases, id: \.self) { priority in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTimePreference = priority
                                }
                            }) {
                                Text(priority.displayEmoji)
                                    .font(.title3)
                                    .opacity(selectedTimePreference == priority ? 1.0 : 0.4)
                                    .scaleEffect(selectedTimePreference == priority ? 1.2 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .help("\(priority.timeDescription) - Preferred Time")
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .modifier(ThinGlassEffectModifier())
                    
                    // Priority Icon Button (independent of moon selection)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            cyclePriority()
                        }
                    }) {
                        Text(selectedPriority.rawValue)
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(width: 65, height: 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .help("Priority: \(selectedPriority.rawValue) - Tap to cycle")
                    .modifier(ThinGlassEffectModifier())
                    .modifier(InteractiveModifier())
                    .animation(.easeInOut(duration: 0.2), value: selectedPriority)
                    
                    Spacer()
                    
                    // Add Button (now optional since Enter key works)
                    if !newTaskTitle.isEmpty {
                        Button(action: addTask) {
                            Image(systemName: isLoading ? "hourglass" : "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .modifier(CircleGlassEffectModifier())
                        .modifier(InteractiveModifier())
                        .disabled(isLoading)
                        .help("Add Task")
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            
            Divider()
            
            // Tasks List
            if tasks.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tortoise")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No turtles to eat yet!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .modifier(ThinGlassEffectModifier())
                .help("Add your first task above")
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(tasks) { task in
                            TaskRow(task: task) { updatedTask in
                                if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                                    tasks[index] = updatedTask
                                    saveTasks()
                                }
                            } onDelete: { taskToDelete in
                                tasks.removeAll { $0.id == taskToDelete.id }
                                saveTasks()
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 320, height: 400)
        .modifier(GlassEffectModifier())
        .animation(.easeInOut(duration: 0.2), value: tasks.count)
        .alert("Turtl", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            loadTasks()
            // Auto-focus on task input
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTaskInputFocused = true
            }
        }
    }
    
    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        
        isLoading = true
        
        let newTask = Task(
            title: newTaskTitle,
            priority: selectedPriority,
            deadline: deadline
        )
        
        // Get AI suggestion for the best time
        FrogAI.shared.suggestTime(for: newTaskTitle, priority: selectedPriority, deadline: deadline) { suggestion in
            DispatchQueue.main.async {
                var taskWithSuggestion = newTask
                taskWithSuggestion.aiSuggestion = suggestion
                
                // Schedule the task in calendar using time preference
                scheduleTaskInCalendar(taskWithSuggestion, timePreference: selectedTimePreference)
                
                tasks.append(taskWithSuggestion)
                saveTasks() // Save the updated tasks
                newTaskTitle = ""
                isLoading = false
                
                // Refocus on input for quick task entry
                isTaskInputFocused = true
                
                if let suggestion = suggestion {
                    alertMessage = "Task added! AI suggests: \(suggestion)"
                    showingAlert = true
                }
            }
        }
    }
    
    private func cyclePriority() {
        // Cycle through priorities: Low -> Medium -> High -> Low
        switch selectedPriority {
        case .low:
            selectedPriority = .medium
        case .medium:
            selectedPriority = .high
        case .high:
            selectedPriority = .low
        }
    }
    
    private func scheduleTaskInCalendar(_ task: Task, timePreference: Task.Priority) {
        // Request calendar access using the new API for macOS 14.0+
        if #available(macOS 14.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                if granted {
                    self.createCalendarEvent(for: task, timePreference: timePreference)
                } else {
                    print("❌ Calendar access denied")
                }
            }
        } else {
            // Fallback for older macOS versions
            eventStore.requestAccess(to: .event) { granted, error in
                if granted {
                    self.createCalendarEvent(for: task, timePreference: timePreference)
                } else {
                    print("❌ Calendar access denied")
                }
            }
        }
    }
    
    private func createCalendarEvent(for task: Task, timePreference: Task.Priority) {
        // Create event
        let event = EKEvent(eventStore: self.eventStore)
        event.title = "🐢 \(task.title)"
        event.notes = "Priority: \(task.priority.rawValue)\nAI Suggestion: \(task.aiSuggestion ?? "No suggestion available")"
        
        // Set event time based on AI suggestion or default to morning
        let calendar = Calendar.current
        var eventDate = task.deadline
        
        // Try to parse AI suggestion for time
        if let suggestion = task.aiSuggestion?.lowercased() {
            // Parse time suggestions
            if suggestion.contains("morning") || suggestion.contains("9") || suggestion.contains("10") {
                eventDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            } else if suggestion.contains("early morning") || suggestion.contains("7") || suggestion.contains("8") {
                eventDate = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            } else if suggestion.contains("afternoon") || suggestion.contains("2") || suggestion.contains("3") || suggestion.contains("14") || suggestion.contains("15") {
                eventDate = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            } else if suggestion.contains("evening") || suggestion.contains("6") || suggestion.contains("7") || suggestion.contains("18") || suggestion.contains("19") {
                eventDate = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            } else if suggestion.contains("late") || suggestion.contains("4") || suggestion.contains("5") || suggestion.contains("16") || suggestion.contains("17") {
                eventDate = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            } else {
                // Default based on moon icon preference
                switch timePreference {
                case .high: // 🌕 Full moon - morning
                    eventDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: task.deadline) ?? task.deadline
                case .medium: // 🌓 Half moon - afternoon
                    eventDate = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: task.deadline) ?? task.deadline
                case .low: // 🌑 New moon - night
                    eventDate = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: task.deadline) ?? task.deadline
                }
            }
        } else {
            // Default based on moon icon preference
            switch timePreference {
            case .high: // 🌕 Full moon - morning
                eventDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            case .medium: // 🌓 Half moon - afternoon
                eventDate = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            case .low: // 🌑 New moon - night
                eventDate = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: task.deadline) ?? task.deadline
            }
        }
        
        event.startDate = eventDate
        event.endDate = calendar.date(byAdding: .hour, value: 1, to: eventDate) ?? eventDate
        event.calendar = self.eventStore.defaultCalendarForNewEvents
        
        // Add alarm for high priority tasks
        if task.priority == .high {
            let alarm = EKAlarm(relativeOffset: -3600) // 1 hour before
            event.addAlarm(alarm)
        }
        
        do {
            try self.eventStore.save(event, span: .thisEvent)
            print("✅ Task scheduled in calendar: \(task.title) at \(eventDate)")
        } catch {
            print("❌ Failed to save event: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Data Persistence
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "SavedTasks")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "SavedTasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
}

struct TaskRow: View {
    let task: Task
    let onUpdate: (Task) -> Void
    let onDelete: (Task) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Button(action: {
                    var updatedTask = task
                    updatedTask.isCompleted.toggle()
                    onUpdate(updatedTask)
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                        .font(.title2)
                }
                .modifier(CircleGlassEffectModifier())
                .modifier(InteractiveModifier())
                .buttonStyle(PlainButtonStyle())
                .help(task.isCompleted ? "Mark as incomplete" : "Mark as complete")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(task.title)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .gray : .primary)
                    
                    if let suggestion = task.aiSuggestion {
                        HStack(spacing: 4) {
                            Image(systemName: "brain.head.profile")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(suggestion)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Priority Icon
                Text(task.priority.displayEmoji)
                    .font(.title3)
                    .help("\(task.priority.timeDescription) - \(task.priority.rawValue) Priority")
                
                // Delete Button
                Button(action: { onDelete(task) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title3)
                }
                .modifier(CircleGlassEffectModifier())
                .modifier(InteractiveModifier())
                .buttonStyle(PlainButtonStyle())
                .help("Delete task")
            }
            
            HStack {
                // Date with Icon
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(task.deadline, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Priority Badge
                Text(task.priority.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(priorityColor.opacity(0.2))
                    .cornerRadius(4)
            }
        }
        .padding(8)
        .modifier(ThinGlassEffectModifier())
        .modifier(InteractiveModifier())
    }
    
    private var priorityColor: Color {
        switch task.priority {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
                }
            }

            #Preview {
                ContentView()
            }
