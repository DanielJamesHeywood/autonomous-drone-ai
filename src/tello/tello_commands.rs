use std::net::*;

pub struct TelloCommands {
    socket: UdpSocket,
}

impl TelloCommands {
    pub fn bind_and_connect() -> std::io::Result<TelloCommands> {
        let commands = TelloCommands::bind()?;
        commands.connect()?;
        Ok(commands)
    }

    fn bind() -> std::io::Result<TelloCommands> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 0))?;
        Ok(TelloCommands { socket })
    }

    fn connect(&self) -> std::io::Result<()> {
        self.socket
            .connect(SocketAddrV4::new(Ipv4Addr::new(192, 168, 10, 1), 8889))?;
        Ok(())
    }
}