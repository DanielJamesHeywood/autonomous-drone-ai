import Foundation
import Network

actor Tello {
    
    enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
    }
    
    let connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
    func command() async throws {
        try await sendCommandAndReceiveResponse("command")
    }
    
    func takeoff() async throws {
        try await sendCommandAndReceiveResponse("takeoff")
    }
    
    func land() async throws {
        try await sendCommandAndReceiveResponse("land")
    }
    
    func streamOn() async throws {
        try await sendCommandAndReceiveResponse("streamon")
    }
    
    func streamOff() async throws {
        try await sendCommandAndReceiveResponse("streamoff")
    }
    
    func emergency() async throws {
        try await sendCommandAndReceiveResponse("emergency")
    }
    
    func remoteControl(_ a: Int, _ b: Int, _ c: Int, _ d: Int) async throws {
        precondition(a.magnitude <= 100)
        precondition(b.magnitude <= 100)
        precondition(c.magnitude <= 100)
        precondition(d.magnitude <= 100)
        try await sendCommandAndReceiveResponse("rc \(a) \(b) \(c) \(d)")
    }
    
    func sendCommandAndReceiveResponse(_ command: String) async throws {
        try await sendCommand(command)
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
