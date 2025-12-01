use std::io;
use std::net::{Ipv4Addr, SocketAddrV4, UdpSocket};

pub struct StateSocket {
    socket: UdpSocket,
}

impl StateSocket {
    pub fn bind() -> io::Result<StateSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 8890))?;
        Ok(StateSocket { socket })
    }
}