import Network
import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    enum Error: Swift.Error {
        case receivedErrorResponse
        case receivedInvalidResponse
    }
    
    let task = Task(
        priority: .utility,
        operation: {
            let connection = NetworkConnection(to: .hostPort(host: "192.168.10.1", port: 8889), using: { UDP() })
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
    )
    
    var body: some Scene {
        Window("Autonomous Drone AI", id: "autonomousDroneAI", content: { AutonomousDroneAIView() })
    }
}
