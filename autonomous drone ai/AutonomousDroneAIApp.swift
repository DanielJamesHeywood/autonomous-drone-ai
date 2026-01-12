import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    let sendCommandsAndReceiveResponses = Task(
        priority: .utility,
        operation: {
            try await tello.command()
        }
    )
    
    var body: some Scene {
        Window("Autonomous Drone AI", id: "autonomousDroneAI", content: { AutonomousDroneAIView() })
    }
}
