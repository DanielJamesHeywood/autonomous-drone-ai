
actor FlightController {
    
    var _tello: Tello?
    
    func initializeTello() async {
        let tello = Tello()
        repeat {
            do {
                try await tello.command()
                break
            } catch {
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch { return }
            }
        } while true
        repeat {
            do {
                try await tello.streamOn()
                break
            } catch {
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch { return }
            }
        } while true
        _tello = tello
    }
}
