import Network

class TelloVideoStream {
    
    class Iterator {}
    
    let _connection = NetworkConnection(
        to: .hostPort(host: "192.168.10.1", port: .any),
        using: .parameters { UDP() } .localPort(11111)
    )
}
