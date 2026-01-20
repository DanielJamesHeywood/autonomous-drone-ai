
actor FlightController {
    
    var _tello: Tello?
    
    func initializeTello() async throws {
        let tello = Tello()
        repeat {
            do {
                try await tello.command()
                break
            } catch {
                try await Task.sleep(for: .seconds(1))
            }
        } while true
        repeat {
            do {
                try await tello.streamOn()
                break
            } catch {
                try await Task.sleep(for: .seconds(1))
            }
        } while true
        _tello = tello
    }
}
