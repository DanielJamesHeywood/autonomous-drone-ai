use std::io;
use std::net::{Ipv4Addr, SocketAddrV4, UdpSocket};

pub struct CommandSocket {
    socket: UdpSocket,
}

impl CommandSocket {
    pub fn bind_and_connect() -> io::Result<CommandSocket> {
        let socket = CommandSocket::bind()?;
        socket.connect()?;
        Ok(socket)
    }

    fn bind() -> io::Result<CommandSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 0))?;
        Ok(CommandSocket { socket })
    }

    fn connect(&self) -> io::Result<()> {
        self.socket
            .connect(SocketAddrV4::new(Ipv4Addr::new(192, 168, 10, 1), 8889))?;
        Ok(())
    }

    pub fn send_command_and_receive_response(&self) -> io::Result<()> {
        self.send_command()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_command(&self) -> io::Result<()> {
        self.socket.send("Command".as_bytes())?;
        Ok(())
    }

    pub fn send_takeoff_and_receive_response(&self) -> io::Result<()> {
        self.send_takeoff()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_takeoff(&self) -> io::Result<()> {
        self.socket.send("takeoff".as_bytes())?;
        Ok(())
    }

    pub fn send_land_and_receive_response(&self) -> io::Result<()> {
        self.send_land()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_land(&self) -> io::Result<()> {
        self.socket.send("land".as_bytes())?;
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
