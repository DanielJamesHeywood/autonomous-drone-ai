import Foundation
import Network
import VideoToolbox

public enum TelloError: Error {
    case receivedError
    case receivedInvalidResponse
}

public class Tello {
    
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
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func takeoff() async throws {
        try await _connection.send("takeoff".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func land() async throws {
        try await _connection.send("land".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func streamOn() async throws {
        try await _connection.send("streamon".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func streamOff() async throws {
        try await _connection.send("streamoff".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func emergency() async throws {
        try await _connection.send("emergency".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
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
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
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
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
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
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
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
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
    
    @inlinable
    public func stop() async throws {
        try await _connection.send("stop".data(using: .utf8).unsafelyUnwrapped)
        switch try await _connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw TelloError.receivedError
        default:
            throw TelloError.receivedInvalidResponse
        }
    }
}

public let tello = Tello(_empty: ())
