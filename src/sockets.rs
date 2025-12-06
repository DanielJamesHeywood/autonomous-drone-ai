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
        self.socket.send("command".as_bytes())?;
        Ok(())
    }

    pub fn send_take_off_and_receive_response(&self) -> io::Result<()> {
        self.send_take_off()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_take_off(&self) -> io::Result<()> {
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

    pub fn send_stream_on_and_receive_response(&self) -> io::Result<()> {
        self.send_stream_on()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_stream_on(&self) -> io::Result<()> {
        self.socket.send("streamon".as_bytes())?;
        Ok(())
    }

    pub fn send_stream_off_and_receive_response(&self) -> io::Result<()> {
        self.send_stream_off()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_stream_off(&self) -> io::Result<()> {
        self.socket.send("streamoff".as_bytes())?;
        Ok(())
    }

    pub fn send_emergency_and_receive_response(&self) -> io::Result<()> {
        self.send_emergency()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_emergency(&self) -> io::Result<()> {
        self.socket.send("emergency".as_bytes())?;
        Ok(())
    }

    pub fn send_up_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_up(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_up(&self, x: u16) -> io::Result<()> {
        if !(20..=500).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 20 and 500 centimetres",
            ));
        }
        self.socket.send(format!("up {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_down_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_down(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_down(&self, x: u16) -> io::Result<()> {
        if !(20..=500).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 20 and 500 centimetres",
            ));
        }
        self.socket.send(format!("down {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_left_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_left(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_left(&self, x: u16) -> io::Result<()> {
        if !(20..=500).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 20 and 500 centimetres",
            ));
        }
        self.socket.send(format!("left {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_right_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_right(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_right(&self, x: u16) -> io::Result<()> {
        if !(20..=500).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 20 and 500 centimetres",
            ));
        }
        self.socket.send(format!("right {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_forward_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_forward(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_forward(&self, x: u16) -> io::Result<()> {
        if !(20..=500).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 20 and 500 centimetres",
            ));
        }
        self.socket.send(format!("forward {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_back_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_back(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_back(&self, x: u16) -> io::Result<()> {
        if !(20..=500).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 20 and 500 centimetres",
            ));
        }
        self.socket.send(format!("back {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_cw_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_cw(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_cw(&self, x: u16) -> io::Result<()> {
        if !(1..=360).contains(&x) {
            return Err(io::Error::other("\"x\" must be between 1 and 360 degrees"));
        }
        self.socket.send(format!("cw {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_ccw_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_ccw(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_ccw(&self, x: u16) -> io::Result<()> {
        if !(1..=360).contains(&x) {
            return Err(io::Error::other("\"x\" must be between 1 and 360 degrees"));
        }
        self.socket.send(format!("ccw {x}").as_bytes())?;
        Ok(())
    }

    pub fn send_stop_and_receive_response(&self) -> io::Result<()> {
        self.send_stop()?;
        self.receive_response()?;
        Ok(())
    }

    fn send_stop(&self) -> io::Result<()> {
        self.socket.send("stop".as_bytes())?;
        Ok(())
    }

    pub fn send_speed_and_receive_response(&self, x: u16) -> io::Result<()> {
        self.send_speed(x)?;
        self.receive_response()?;
        Ok(())
    }

    fn send_speed(&self, x: u16) -> io::Result<()> {
        if !(10..=100).contains(&x) {
            return Err(io::Error::other(
                "\"x\" must be between 10 and 100 centimetres per second",
            ));
        }
        self.socket.send(format!("speed {x}").as_bytes())?;
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

pub struct StateSocket {
    socket: UdpSocket,
}

impl StateSocket {
    pub fn bind() -> io::Result<StateSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 8890))?;
        Ok(StateSocket { socket })
    }
}

pub struct VideoStreamSocket {
    socket: UdpSocket,
}

impl VideoStreamSocket {
    pub fn bind() -> io::Result<VideoStreamSocket> {
        let socket = UdpSocket::bind(SocketAddrV4::new(Ipv4Addr::new(0, 0, 0, 0), 11111))?;
        Ok(VideoStreamSocket { socket })
    }
}
