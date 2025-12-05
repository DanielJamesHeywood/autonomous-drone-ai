use std::io;

fn main() {
    let standard_input = io::stdin();
    loop {
        let mut buffer = String::new();
        standard_input
            .read_line(&mut buffer)
            .expect("Failed to read line from standard input");
    }
}
