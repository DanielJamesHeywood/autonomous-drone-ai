import Foundation
import Network

actor Tello {
    
    enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
        case receivedNoResponse
    }
    
    let _connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
    func command() async throws {
        try await _sendCommandAndReceiveResponse("command")
    }
    
    func takeoff() async throws {
        try await _sendCommandAndReceiveResponse("takeoff")
    }
    
    func land() async throws {
        try await _sendCommandAndReceiveResponse("land")
    }
    
    func streamOn() async throws {
        try await _sendCommandAndReceiveResponse("streamon")
    }
    
    func streamOff() async throws {
        try await _sendCommandAndReceiveResponse("streamoff")
    }
    
    func emergency() async throws {
        try await _sendCommandAndReceiveResponse("emergency")
    }
    
    func remoteControl(_ a: Int, _ b: Int, _ c: Int, _ d: Int) async throws {
        precondition(a.magnitude <= 100)
        precondition(b.magnitude <= 100)
        precondition(c.magnitude <= 100)
        precondition(d.magnitude <= 100)
        try await _sendCommandAndReceiveResponse("rc \(a) \(b) \(c) \(d)")
    }
    
    func _sendCommandAndReceiveResponse(_ command: String) async throws {
        try await _sendCommand(command)
        try await _receiveResponse()
    }
    
    func _sendCommand(_ command: String) async throws {
        guard let command = command.data(using: .utf8) else {
            preconditionFailure()
        }
        try await _connection.send(command)
    }
    
    func _receiveResponse() async throws {
        try await withThrowingTaskGroup(
            body: { group in
                group.addTask(
                    operation: { [self] in
                        switch try await _connection.receive().content {
                        case "ok".data(using: .utf8).unsafelyUnwrapped:
                            return
                        case "error".data(using: .utf8).unsafelyUnwrapped:
                            throw Error.receivedErrorResponse
                        default:
                            throw Error.receivedInvalidResponse
                        }
                    }
                )
                group.addTask(
                    operation: {
                        try await Task.sleep(for: .seconds(1))
                        throw Error.receivedNoResponse
                    }
                )
                try await group.next()
                group.cancelAll()
            }
        )
    }
}
