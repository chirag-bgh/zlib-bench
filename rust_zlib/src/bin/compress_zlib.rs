use std::env;
use std::fs::{read, write};
use flate2::{write::ZlibEncoder, Compression};
use std::io::Write;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 4 {
        panic!("Usage: compress_zlib <input> <output> <level: default|fast|best>");
    }

    let input = read(&args[1]).unwrap();
    let level = match args[3].as_str() {
        "fast" => Compression::fast(),
        "best" => Compression::best(),
        _ => Compression::default(),
    };

    let mut encoder = ZlibEncoder::new(Vec::new(), level);
    encoder.write_all(&input).unwrap();
    let compressed = encoder.finish().unwrap();
    write(&args[2], compressed).unwrap();
}