use std::net::*;

pub struct StateSocket {
    socket: UdpSocket,
}

impl StateSocket {
    pub fn bind() -> std::io::Result<StateSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 8890))?;
        Ok(StateSocket { socket })
    }
}