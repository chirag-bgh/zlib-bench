use criterion::{black_box, criterion_group, criterion_main, Criterion};
use flate2::{write::ZlibEncoder, read::ZlibDecoder, Compression};
use std::fs::read;
use std::io::{Read, Write};

fn compress_benchmark(c: &mut Criterion) {
    let input = read("../bench_inputs/sample.txt").unwrap();
    c.bench_function("rust_zlib_compress", |b| {
        b.iter(|| {
            let mut e = ZlibEncoder::new(Vec::new(), Compression::default());
            e.write_all(black_box(&input)).unwrap();
            let _ = e.finish().unwrap();
        });
    });
}

fn decompress_benchmark(c: &mut Criterion) {
    let input = read("../bench_inputs/sample.txt").unwrap();
    let mut e = ZlibEncoder::new(Vec::new(), Compression::default());
    e.write_all(&input).unwrap();
    let compressed = e.finish().unwrap();

    c.bench_function("rust_zlib_decompress", |b| {
        b.iter(|| {
            let mut d = ZlibDecoder::new(&compressed[..]);
            let mut out = Vec::new();
            d.read_to_end(&mut out).unwrap();
        });
    });
}

criterion_group!(benches, compress_benchmark, decompress_benchmark);
criterion_main!(benches);

