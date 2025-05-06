use criterion::{criterion_group, criterion_main, Criterion, black_box};
use flate2::{Compression, write::ZlibEncoder, read::ZlibDecoder};
use std::fs::read;
use std::io::{Write, Read};

fn run_compress_bench(c: &mut Criterion, name: &str, level: Compression) {
    let input = read("../bench_inputs/sample.txt").unwrap();
    c.bench_function(name, |b| {
        b.iter(|| {
            let mut encoder = ZlibEncoder::new(Vec::new(), level);
            encoder.write_all(black_box(&input)).unwrap();
            let _ = encoder.finish().unwrap();
        });
    });
}

fn run_decompress_bench(c: &mut Criterion, name: &str, level: Compression) {
    let input = read("../bench_inputs/sample.txt").unwrap();
    let mut encoder = ZlibEncoder::new(Vec::new(), level);
    encoder.write_all(&input).unwrap();
    let compressed = encoder.finish().unwrap();

    c.bench_function(name, |b| {
        b.iter(|| {
            let mut decoder = ZlibDecoder::new(&compressed[..]);
            let mut out = Vec::new();
            decoder.read_to_end(&mut out).unwrap();
        });
    });
}

fn zlib_benchmarks(c: &mut Criterion) {
    run_compress_bench(c, "rust_zlib_compress_default", Compression::default());
    run_compress_bench(c, "rust_zlib_compress_fast", Compression::fast());
    run_compress_bench(c, "rust_zlib_compress_best", Compression::best());

    run_decompress_bench(c, "rust_zlib_decompress_default", Compression::default());
    run_decompress_bench(c, "rust_zlib_decompress_fast", Compression::fast());
    run_decompress_bench(c, "rust_zlib_decompress_best", Compression::best());
}

criterion_group!(benches, zlib_benchmarks);
criterion_main!(benches);
