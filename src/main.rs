mod sockets;

use sockets::CommandSocket;
use std::io;

fn main() {
    let command_socket =
        CommandSocket::bind_and_connect().expect("Failed to bind and connect command socket");
    command_socket
        .send_command_and_receive_response()
        .expect("Failed to send \"command\" and receive response");
    let standard_input = io::stdin();
    loop {
        let mut buffer = String::new();
        standard_input
            .read_line(&mut buffer)
            .expect("Failed to read line from standard input");
    }
}
