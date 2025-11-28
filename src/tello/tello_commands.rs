use std::net::*;

pub struct TelloCommands {
    socket: UdpSocket,
}

impl TelloCommands {
    pub fn bind() -> std::io::Result<TelloCommands> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 0))?;
        socket.connect(SocketAddrV4::new(Ipv4Addr::new(192, 168, 10, 1), 8889))?;
        Ok(TelloCommands { socket })
    }
}