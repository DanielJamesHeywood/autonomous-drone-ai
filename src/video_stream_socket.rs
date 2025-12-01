use std::io;
use std::net::{Ipv4Addr, SocketAddrV4, UdpSocket};

pub struct VideoStreamSocket {
    socket: UdpSocket,
}

impl VideoStreamSocket {
    pub fn bind() -> io::Result<VideoStreamSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 11111))?;
        Ok(VideoStreamSocket { socket })
    }
}