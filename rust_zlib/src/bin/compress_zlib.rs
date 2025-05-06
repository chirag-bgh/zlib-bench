use std::env;
use std::fs::{read, write};
use flate2::{write::ZlibEncoder, Compression};
use std::io::Write;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input = read(&args[1]).unwrap();
    let mut encoder = ZlibEncoder::new(Vec::new(), Compression::default());
    encoder.write_all(&input).unwrap();
    let compressed = encoder.finish().unwrap();
    write(&args[2], compressed).unwrap();
}

