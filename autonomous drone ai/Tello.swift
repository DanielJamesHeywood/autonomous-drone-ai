import Foundation
import Network

class Tello {
    
    public enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
    }
    
    let connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
    func command() async throws {
        try await connection.send("command".data(using: .utf8).unsafelyUnwrapped)
        switch try await connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    func takeoff() async throws {
        try await connection.send("takeoff".data(using: .utf8).unsafelyUnwrapped)
        switch try await connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
    
    func land() async throws {
        try await connection.send("land".data(using: .utf8).unsafelyUnwrapped)
        switch try await connection.receive().content {
        case "ok".data(using: .utf8).unsafelyUnwrapped:
            break
        case "error".data(using: .utf8).unsafelyUnwrapped:
            throw Error.receivedErrorResponse
        default:
            throw Error.receivedInvalidResponse
        }
    }
}

let tello = Tello()
