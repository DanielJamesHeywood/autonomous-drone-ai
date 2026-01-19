import Foundation
import GameController
import SwiftUI

@main
struct AutonomousDroneAIApp: App {
    
    let _telloController = TelloController()
    
    var body: some Scene {
        Window(
            "Autonomous Drone AI",
            id: "autonomousDroneAI",
            content: {
                AutonomousDroneAIView()
            }
        )
    }
}
