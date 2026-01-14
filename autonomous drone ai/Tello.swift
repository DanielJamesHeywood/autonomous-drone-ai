import Foundation
import Network

actor Tello {
    
    class State {
        
        let _connection = NetworkConnection(
            to: .hostPort(host: "192.168.10.1", port: .any),
            using: .parameters { UDP() } .localPort(8890)
        )
    }
    
    class VideoStream {
        
        let _connection = NetworkConnection(
            to: .hostPort(host: "192.168.10.1", port: .any),
            using: .parameters { UDP() } .localPort(11111)
        )
    }
    
    enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
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
    
    func emergency() async throws {
        try await _sendCommand("emergency")
    }
    
    func remoteControl(_ a: Int, _ b: Int, _ c: Int, _ d: Int) async throws {
        precondition(a.magnitude <= 100)
        precondition(b.magnitude <= 100)
        precondition(c.magnitude <= 100)
        precondition(d.magnitude <= 100)
        try await _sendCommand("rc \(a) \(b) \(c) \(d)")
    }
    
    func _sendCommandAndReceiveResponse(_ command: String) async throws {
        try await withThrowingDiscardingTaskGroup(
            body: { group in
                var currentSleepTask: Task<(), any Swift.Error>?
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
                            try await sleepTask.value
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
        try await _connection.send(command)
    }
    
    func _receiveResponse() async throws {
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
