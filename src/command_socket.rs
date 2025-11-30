use std::net::{Ipv4Addr, SocketAddrV4, UdpSocket};

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

    fn receive_response(&self) -> io::Result<()> {
        let mut buffer = [0; 5];
        let number_of_bytes_read = self.socket.recv(&mut buffer)?;
        match str::from_utf8(&buffer[..number_of_bytes_read]).map_err(io::Error::other)? {
            "ok" => Ok(()),
            "error" => Err(io::Error::other("received \"error\" response")),
            _ => Err(io::Error::other("received invalid response")),
        }
    }
}
