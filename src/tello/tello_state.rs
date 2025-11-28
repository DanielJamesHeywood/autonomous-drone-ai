use std::net::*;

pub struct TelloState {
    socket: UdpSocket,
}

impl TelloState {
    pub fn bind() -> std::io::Result<TelloState> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 8890))?;
        Ok(TelloState { socket })
    }
}