import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    var body: some Scene {
        Window(
            "Autonomous Drone AI",
            id: "autonomousDroneAI",
            content: {
                AutonomousDroneAIView().task(priority: .utility) {
                    let tello = Tello()
                    try! await tello.command()
                } .task(priority: .utility) {} .task(priority: .utility) {}
            }
        )
    }
}
