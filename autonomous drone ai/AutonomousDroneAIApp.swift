import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    let _renderer = Renderer()
    
    let _flightController = FlightController()
    
    var body: some Scene {
        Window(
            "Autonomous Drone AI",
            id: "autonomousDroneAI",
            content: {
                AutonomousDroneAIView(renderer: _renderer).task(priority: .utility) {
                    try? await _flightController.initializeTello()
                } .task(priority: .utility) {
                    await _flightController.handleControllersBecomingCurrent()
                } .task(priority: .utility) {
                    await _flightController.handleControllersStoppingBeingCurrent()
                }
            }
        )
    }
}
