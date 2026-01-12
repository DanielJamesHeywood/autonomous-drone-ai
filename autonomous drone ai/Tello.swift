import Foundation
import Network

actor Tello {
    
    enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
    }
    
    let connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
    func command() async throws {
        try await sendCommand("command")
        try await receiveResponse()
    }
    
    func takeoff() async throws {
        try await sendCommand("takeoff")
        try await receiveResponse()
    }
    
    func land() async throws {
        try await sendCommand("land")
        try await receiveResponse()
    }
    
    func streamOn() async throws {
        try await sendCommand("streamon")
        try await receiveResponse()
    }
    
    func streamOff() async throws {
        try await sendCommand("streamoff")
        try await receiveResponse()
    }
    
    func emergency() async throws {
        try await sendCommand("emergency")
        try await receiveResponse()
    }
    
    func sendCommand(_ command: String) async throws {
        guard let command = command.data(using: .utf8) else {
            preconditionFailure()
        }
        try await connection.send(command)
    }
    
    func receiveResponse() async throws {
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
