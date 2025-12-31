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
}

public let tello = Tello(_empty: ())
