import Foundation
import GameController
import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    let _telloController = TelloController()
    
    var body: some Scene {
        Window(
            "Autonomous Drone AI",
            id: "autonomousDroneAI",
            content: {
                AutonomousDroneAIView().task(priority: .utility) {
                    let tello = Tello()
                    try! await tello.command()
                    try! await tello.streamOn()
                    await _telloController.initializeTello(tello)
                } .task(priority: .utility) {
                    for await notification in NotificationCenter.default.notifications(named: .GCControllerDidBecomeCurrent) {
                        let controller = notification.object as! GCController
                        guard let gamepad = controller.extendedGamepad else { continue }
                        gamepad.buttonA.pressedChangedHandler = { [self] _, _, pressed in
                            guard pressed else { return }
                            Task(
                                operation: {
                                    await _telloController.buttonAPressed()
                                }
                            )
                        }
                        gamepad.buttonB.pressedChangedHandler = { [self] _, _, pressed in
                            guard pressed else { return }
                            Task(
                                operation: {
                                    await _telloController.buttonBPressed()
                                }
                            )
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
