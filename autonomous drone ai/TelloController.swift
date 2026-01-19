import GameController

actor TelloController {
    
    var task1: Task<Void, Never>?
    
    var task2: Task<Void, Never>?
    
    var task3: Task<Void, Never>?
    
    var _tello: Tello?
    
    var _isFlying = false
    
    func _initializeTello(_ tello: Tello) {
        precondition(_tello == nil)
        _tello = tello
    }
    
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
        task1 = Task(
            priority: .utility,
            operation: {
                let tello = Tello()
                await _initializeTello(tello)
            }
        )
        task2 = Task(
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
        task3 = Task(
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
    
    deinit {
        task1.unsafelyUnwrapped.cancel()
        task2.unsafelyUnwrapped.cancel()
        task3.unsafelyUnwrapped.cancel()
    }
}
