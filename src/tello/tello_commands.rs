use std::net::*;

pub struct TelloCommands {
    socket: UdpSocket,
}

impl TelloState {
    pub fn bind() -> std::io::Result<TelloState> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 0))?;
        Ok(TelloState { socket })
    }
}