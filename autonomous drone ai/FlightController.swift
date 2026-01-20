
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
