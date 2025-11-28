use std::net::*;

pub struct TelloState {
    socket: UdpSocket,
}