import Network
import VideoToolbox

public class Tello {
    
    public enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
    }
    
    public enum Direction: String {
        case left = "l"
        case right = "r"
        case forward = "f"
        case back = "b"
    }
    
    @usableFromInline
    internal let _connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
    @usableFromInline
    internal let _stateConnection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(8890)
    )
    
    @usableFromInline
    internal let _videoStreamConnection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(11111)
    )
    
    @usableFromInline
    internal var _videoStreamDecompressionSession: VTDecompressionSession?
    
    @inlinable
    internal init(_empty: ()) {}
    
    @inlinable
    public func command() async throws {
        try await _connection.send("command".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func takeoff() async throws {
        try await _connection.send("takeoff".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func land() async throws {
        try await _connection.send("land".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func streamOn() async throws {
        try await _connection.send("streamon".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func streamOff() async throws {
        try await _connection.send("streamoff".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func emergency() async throws {
        try await _connection.send("emergency".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func up(_ x: Int) async throws {
        precondition((20...500).contains(x))
        try await _connection.send("up \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func down(_ x: Int) async throws {
        precondition((20...500).contains(x))
        try await _connection.send("down \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func left(_ x: Int) async throws {
        precondition((20...500).contains(x))
        try await _connection.send("left \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func right(_ x: Int) async throws {
        precondition((20...500).contains(x))
        try await _connection.send("right \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func forward(_ x: Int) async throws {
        precondition((20...500).contains(x))
        try await _connection.send("forward \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func back(_ x: Int) async throws {
        precondition((20...500).contains(x))
        try await _connection.send("back \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func clockwise(_ x: Int) async throws {
        precondition((1...360).contains(x))
        try await _connection.send("cw \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func counterclockwise(_ x: Int) async throws {
        precondition((1...360).contains(x))
        try await _connection.send("ccw \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func flip(_ x: Direction) async throws {
        try await _connection.send("flip \(x.rawValue)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func go(_ xyz: (Int, Int, Int), speed: Int) async throws {
        let (x, y, z) = xyz
        precondition(x.magnitude <= 500)
        precondition(y.magnitude <= 500)
        precondition(z.magnitude <= 500)
        precondition((10...100).contains(speed))
        precondition(!(x.magnitude < 20 && y.magnitude < 20 && z.magnitude < 20))
        try await _connection.send("go \(x) \(y) \(z) \(speed)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func stop() async throws {
        try await _connection.send("stop".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func curve(_ xyz1: (Int, Int, Int), _ xyz2: (Int, Int, Int), speed: Int) async throws {
        let (x1, y1, z1) = xyz1
        let (x2, y2, z2) = xyz2
        precondition(x1.magnitude <= 500)
        precondition(y1.magnitude <= 500)
        precondition(z1.magnitude <= 500)
        precondition(x2.magnitude <= 500)
        precondition(y2.magnitude <= 500)
        precondition(z2.magnitude <= 500)
        precondition((10...60).contains(speed))
        precondition(!(x1.magnitude < 20 && y1.magnitude < 20 && z1.magnitude < 20))
        precondition(!(x2.magnitude < 20 && y2.magnitude < 20 && z2.magnitude < 20))
        try await _connection.send("curve \(x1) \(y1) \(z1) \(x2) \(y2) \(z2) \(speed)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func speed(_ x: Int) async throws {
        precondition((10...100).contains(x))
        try await _connection.send("speed \(x)".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func speed() async throws -> Int {
        try await _connection.send("speed?".data(using: .utf8).unsafelyUnwrapped)
        guard let response = try await String(data: _connection.receive().content, encoding: .utf8) else {
            throw Error.receivedInvalidResponse
        }
        guard let x = Int(response), (10...100).contains(x) else {
            throw Error.receivedInvalidResponse
        }
        return x
    }
    
    @inlinable
    public func battery() async throws -> Int {
        try await _connection.send("battery?".data(using: .utf8).unsafelyUnwrapped)
        guard let response = try await String(data: _connection.receive().content, encoding: .utf8) else {
            throw Error.receivedInvalidResponse
        }
        guard let x = Int(response), (0...100).contains(x) else {
            throw Error.receivedInvalidResponse
        }
        return x
    }
    
    @inlinable
    public func time() async throws -> Int {
        try await _connection.send("time?".data(using: .utf8).unsafelyUnwrapped)
        guard let response = try await String(data: _connection.receive().content, encoding: .utf8) else {
            throw Error.receivedInvalidResponse
        }
        guard let time = Int(response), time >= 0 else {
            throw Error.receivedInvalidResponse
        }
        return time
    }
}

public let tello = Tello(_empty: ())
