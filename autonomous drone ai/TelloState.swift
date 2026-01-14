import Network

class TelloState {
    
    let _connection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(8890)
    )
}
