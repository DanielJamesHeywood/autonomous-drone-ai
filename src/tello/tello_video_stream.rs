use std::net::*;

pub struct TelloVideoStream {
    socket: UdpSocket,
}

impl TelloVideoStream {
    pub fn bind() -> std::io::Result<TelloVideoStream> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 11111))?;
        Ok(TelloVideoStream { socket })
    }
}