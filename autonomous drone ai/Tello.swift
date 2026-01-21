import Foundation
import Network

actor Tello {
    
    enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
    }
    
    var _connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
    
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
    
    func emergency() async throws {
        try await _sendCommand("emergency")
    }
    
    func _sendCommandAndReceiveResponse(_ command: String) async throws {
        try await withThrowingDiscardingTaskGroup(
            body: { group in
                var currentSleepTask: Task<Void, any Swift.Error>?
                var receivedResponse = false
                group.addTask(
                    operation: { [self] in
                        repeat {
                            try await _sendCommand(command)
                            let sleepTask = Task(
                                operation: {
                                    try await Task.sleep(for: .seconds(1))
                                }
                            )
                            currentSleepTask = sleepTask
                            try? await sleepTask.value
                            currentSleepTask = nil
                        } while !receivedResponse
                    }
                )
                group.addTask(
                    operation: { [self] in
                        try await _receiveResponse()
                        receivedResponse = true
                        currentSleepTask?.cancel()
                    }
                )
            }
        )
    }
    
    func _sendCommand(_ command: String) async throws {
        guard let command = command.data(using: .utf8) else {
            preconditionFailure()
        }
        try await _recreatingConnectionOnFailure {
            try await _connection.send(command)
        }
    }
    
    func _receiveResponse() async throws {
        try await _recreatingConnectionOnFailure {
            switch try await _connection.receive().content {
            case "ok".data(using: .utf8).unsafelyUnwrapped:
                return
            case "error".data(using: .utf8).unsafelyUnwrapped:
                throw Error.receivedErrorResponse
            default:
                throw Error.receivedInvalidResponse
            }
        }
    }
    
    func _recreatingConnectionOnFailure(_ body: () async throws -> Void) async rethrows {
        do {
            try await body()
        } catch let error as Error {
            throw error
        } catch {
            _connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
            throw error
        }
    }
}
