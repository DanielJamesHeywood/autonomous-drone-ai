use std::net::*;

pub struct VideoStreamSocket {
    socket: UdpSocket,
}

impl VideoStreamSocket {
    pub fn bind() -> std::io::Result<VideoStreamSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 11111))?;
        Ok(VideoStreamSocket { socket })
    }
}