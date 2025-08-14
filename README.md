# Turtl 🐢

A macOS menu bar app that helps you "eat your turtles" - the most important tasks of the day. Turtl uses AI to intelligently schedule your tasks at the optimal time based on priority, task type, and your schedule. 
## Features

- **Task Management**: Add tasks with priority levels (Low, Medium, High)
- **AI-Powered Scheduling**: Get intelligent suggestions for when to complete tasks
- **Calendar Integration**: Automatically schedule tasks in your calendar
- **Menu Bar Access**: Quick access from your menu bar
- **Data Persistence**: Tasks are saved between app launches
- **Priority-Based Alerts**: High priority tasks get calendar alerts

## How It Works

1. **Add a Task**: Click the turtle icon in your menu bar and enter your main task for the day
2. **Set Priority**: Choose the priority level (Low 🟢, Medium 🟡, High 🔴)
3. **Set Deadline**: Pick when the task needs to be completed
4. **AI Analysis**: The app analyzes your task and suggests the optimal time to complete it
5. **Calendar Integration**: The task is automatically scheduled in your calendar at the suggested time

## AI Suggestions

The AI considers several factors when suggesting the best time for your task:

- **Priority Level**: High priority tasks are scheduled earlier in the day
- **Task Type**: Creative tasks work better in the morning, administrative tasks in the afternoon
- **Deadline**: Urgent tasks are prioritized
- **Time Patterns**: Avoids typical break times for focus-intensive tasks

## Installation

1. Clone this repository
2. **Set up API Key**:
   - Copy `FrogTime/Secrets.swift.template` to `FrogTime/Secrets.swift`
   - Get your API key from [OpenRouter](https://openrouter.ai/)
   - Replace `YOUR_OPENROUTER_API_KEY_HERE` with your actual API key
3. Open `FrogTime.xcodeproj` in Xcode (project name remains the same for now)
4. Build and run the project
5. The app will appear in your menu bar as a turtle icon

## Security

- Never commit your `Secrets.swift` file to Git
- The API key is stored locally and never shared
- `Secrets.swift` is included in `.gitignore` for your protection

## Permissions

Turtl requires the following permissions:
- **Calendar Access**: To schedule your tasks
- **Network Access**: To connect to the AI service for time suggestions

## Technical Details

- Built with SwiftUI for macOS
- Uses EventKit for calendar integration
- AI powered by OpenRouter API
- Data persistence with UserDefaults
- Menu bar integration with NSPopover

## Development

The app is structured with the following key components:

- `FrogTimeApp.swift`: Main app entry point
- `AppDelegate.swift`: Menu bar integration
- `ContentView.swift`: Main UI and task management
- `FrogAI.swift`: AI integration for time suggestions
- `FrogPopoverView.swift`: Popover container

## License

This project is for personal use and learning purposes.
