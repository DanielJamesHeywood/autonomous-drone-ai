import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    let sendCommandsAndReceiveResponses = Task(
        priority: .utility,
        operation: {
            try await Tello().command()
        }
    )
    
    var body: some Scene {
        Window("Autonomous Drone AI", id: "autonomousDroneAI", content: { AutonomousDroneAIView() })
    }
}
