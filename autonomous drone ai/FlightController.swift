import Foundation
import GameController

actor FlightController {
    
    var _tello: Tello?
    
    var _isFlying = false
    
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
    
    func handleControllersBecomingCurrent() async {
        for await notification in NotificationCenter.default.notifications(named: .GCControllerDidBecomeCurrent) {
            let controller = notification.object as! GCController
            guard let gamepad = controller.extendedGamepad else { continue }
            gamepad.buttonA.pressedChangedHandler = { [self] _, _, pressed in
                guard let _tello, pressed else { return }
                Task(
                    operation: {
                        try await _isFlying ? _tello.land() : _tello.takeoff()
                        _isFlying.toggle()
                    }
                )
            }
            gamepad.buttonB.pressedChangedHandler = { [self] _, _, pressed in
                guard let _tello, pressed else { return }
                Task(
                    operation: {
                        try await _tello.emergency()
                        _isFlying = false
                    }
                )
            }
        }
    }
    
    func handleControllersStoppingBeingCurrent() async {
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
