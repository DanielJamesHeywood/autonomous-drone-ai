import Foundation
import GameController

actor FlightController {
    
    var _tello: Tello?
    
    func initializeTello() async throws {
        let tello = Tello()
        try await _retryingOnFailure {
            try await tello.command()
        }
        try await _retryingOnFailure {
            try await tello.streamOn()
        }
        _tello = tello
    }
    
    func handleControllerDidBecomeCurrentNotifications() async {
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
    }
    
    func handleControllerDidStopBeingCurrentNotifications() async {
        for await notification in NotificationCenter.default.notifications(named: .GCControllerDidStopBeingCurrent) {
            let controller = notification.object as! GCController
            guard let gamepad = controller.extendedGamepad else { continue }
            gamepad.buttonA.pressedChangedHandler = nil
            gamepad.buttonB.pressedChangedHandler = nil
        }
    }
    
    func _retryingOnFailure(_ body: () async throws -> Void) async throws {
        repeat {
            do {
                try await body()
                return
            } catch {
                try await Task.sleep(for: .seconds(1))
            }
        } while true
    }
}
