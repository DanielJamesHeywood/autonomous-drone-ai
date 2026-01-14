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
                    try! await tello.streamOn()
                } .task(priority: .utility) {
                    Tello.State()
                } .task(priority: .utility) {
                    Tello.VideoStream()
                }
            }
        )
    }
}
