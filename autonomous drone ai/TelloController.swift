import GameController

actor TelloController {
    
    var _tello: Tello?
    
    var _isFlying = false
    
    func initializeTello(_ tello: Tello) {
        precondition(_tello == nil)
        _tello = tello
    }
    
    func buttonAPressed() async {
        guard let _tello else { return }
        do {
            try await _isFlying ? _tello.land() : _tello.takeoff()
            _isFlying.toggle()
        } catch {}
    }
    
    func buttonBPressed() async {
        guard let _tello, _isFlying else { return }
        do {
            try await _tello.emergency()
            _isFlying = false
        } catch {}
    }
}
