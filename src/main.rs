mod command_socket;

use std::io;

fn main() {
    let command_socket =
        CommandSocket::bind_and_connect().expect("Failed to bind and connect command socket");
    let standard_input = io::stdin();
    loop {
        let mut buffer = String::new();
        standard_input
            .read_line(&mut buffer)
            .expect("Failed to read line from standard input");
    }
}
