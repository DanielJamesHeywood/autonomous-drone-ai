use std::io;

fn main() -> io::Result<()> {
    let standard_input = io::stdin();
    loop {
        let mut buffer = String::new();
        standard_input.read_line(&mut buffer)?;
    }
}
