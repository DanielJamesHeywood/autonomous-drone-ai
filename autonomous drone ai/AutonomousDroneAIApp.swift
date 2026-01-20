import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    let _flightController = FlightController()
    
    var body: some Scene {
        Window(
            "Autonomous Drone AI",
            id: "autonomousDroneAI",
            content: {
                AutonomousDroneAIView().task(priority: .utility) {
                    try? await _flightController.initializeTello()
                } .task(priority: .utility) {
                    await _flightController.handleControllerDidBecomeCurrentNotifications()
                } .task(priority: .utility) {
                    await _flightController.handleControllerDidStopBeingCurrentNotifications()
                }
            }
        )
    }
}
