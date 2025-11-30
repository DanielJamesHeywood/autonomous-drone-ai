use std::net::*;

pub struct CommandSocket {
    socket: UdpSocket,
}

impl CommandSocket {
    pub fn bind_and_connect() -> std::io::Result<CommandSocket> {
        let socket = CommandSocket::bind()?;
        socket.connect()?;
        Ok(socket)
    }

    fn bind() -> std::io::Result<CommandSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 0))?;
        Ok(CommandSocket { socket })
    }

    fn connect(&self) -> std::io::Result<()> {
        self.socket
            .connect(SocketAddrV4::new(Ipv4Addr::new(192, 168, 10, 1), 8889))?;
        Ok(())
    }
}