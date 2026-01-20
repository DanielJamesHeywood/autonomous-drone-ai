import Foundation
import GameController
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
                    for await notification in NotificationCenter.default.notifications(named: .GCControllerDidBecomeCurrent) {
                        let controller = notification.object as! GCController
                        guard let gamepad = controller.extendedGamepad else { continue }
                        gamepad.buttonA.pressedChangedHandler = { _, _, pressed in
                            guard pressed else { return }
                        }
                        gamepad.buttonB.pressedChangedHandler = { _, _, pressed in
                            guard pressed else { return }
                        }
                    }
                } .task(priority: .utility) {
                    for await notification in NotificationCenter.default.notifications(named: .GCControllerDidStopBeingCurrent) {
                        let controller = notification.object as! GCController
                        guard let gamepad = controller.extendedGamepad else { continue }
                        gamepad.buttonA.pressedChangedHandler = nil
                        gamepad.buttonB.pressedChangedHandler = nil
                    }
                }
            }
        )
    }
}
