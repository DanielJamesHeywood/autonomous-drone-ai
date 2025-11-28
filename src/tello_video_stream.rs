use std::net::*;

pub struct TelloVideoStream {
    socket: UdpSocket,
}