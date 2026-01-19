import GameController

actor TelloController {
    
    var _tello: Tello?
    
    var _isFlying = false
    
    func _buttonAPressed() async {
        guard let _tello else { return }
        do {
            try await _isFlying ? _tello.land() : _tello.takeoff()
            _isFlying.toggle()
        } catch {}
    }
    
    func _buttonBPressed() async {
        guard let _tello, _isFlying else { return }
        do {
            try await _tello.emergency()
            _isFlying = false
        } catch {}
    }
    
    init() {
        Task(
            priority: .utility,
            operation: {
                let tello = Tello()
            }
        )
        Task(
            priority: .utility,
            operation: {
                for await notification in NotificationCenter.default.notifications(named: .GCControllerDidBecomeCurrent) {
                    let controller = notification.object as! GCController
                    guard let gamepad = controller.extendedGamepad else { continue }
                    gamepad.buttonA.pressedChangedHandler = { [weak self] _, _, pressed in
                        guard let self, pressed else { return }
                        Task(
                            operation: {
                                await self._buttonAPressed()
                            }
                        )
                    }
                    gamepad.buttonB.pressedChangedHandler = { [weak self] _, _, pressed in
                        guard let self, pressed else { return }
                        Task(
                            operation: {
                                await self._buttonBPressed()
                            }
                        )
                    }
                }
            }
        )
        Task(
            priority: .utility,
            operation: {
                for await notification in NotificationCenter.default.notifications(named: .GCControllerDidStopBeingCurrent) {
                    let controller = notification.object as! GCController
                    guard let gamepad = controller.extendedGamepad else { continue }
                    gamepad.buttonA.pressedChangedHandler = nil
                    gamepad.buttonB.pressedChangedHandler = nil
                }
            }
        )
    }
    
    deinit {}
}
