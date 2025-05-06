#!/bin/bash

set -e

GO_DIR="go_zlib"
RUST_DIR="rust_zlib"
INPUT_FILE="bench_inputs/sample.txt"
TMP_DIR="bench_tmp"

mkdir -p "$TMP_DIR"

echo "===> Running Go Benchmarks..."
cd "$GO_DIR"
go test -bench=. -benchmem > "../$TMP_DIR/go_bench_output.txt"
cd ..

echo "===> Running Rust Benchmarks..."
cd "$RUST_DIR"
cargo bench > "../$TMP_DIR/rust_bench_output.txt"
cd ..

echo "===> Compressing with Go..."
go run "$GO_DIR/compress_zlib.go" "$INPUT_FILE" default > "$TMP_DIR/go_compressed_default.bin"
go run "$GO_DIR/compress_zlib.go" "$INPUT_FILE" fast > "$TMP_DIR/go_compressed_fast.bin"
go run "$GO_DIR/compress_zlib.go" "$INPUT_FILE" best > "$TMP_DIR/go_compressed_best.bin"

echo "===> Compressing with Rust..."
cargo run --manifest-path "$RUST_DIR/Cargo.toml" --bin compress_zlib "$INPUT_FILE" "$TMP_DIR/rust_compressed_default.bin" default
cargo run --manifest-path "$RUST_DIR/Cargo.toml" --bin compress_zlib "$INPUT_FILE" "$TMP_DIR/rust_compressed_fast.bin" fast
cargo run --manifest-path "$RUST_DIR/Cargo.toml" --bin compress_zlib "$INPUT_FILE" "$TMP_DIR/rust_compressed_best.bin" best

# Get compressed sizes
go_size_default=$(wc -c < "$TMP_DIR/go_compressed_default.bin")
go_size_fast=$(wc -c < "$TMP_DIR/go_compressed_fast.bin")
go_size_best=$(wc -c < "$TMP_DIR/go_compressed_best.bin")

rust_size_default=$(wc -c < "$TMP_DIR/rust_compressed_default.bin")
rust_size_fast=$(wc -c < "$TMP_DIR/rust_compressed_fast.bin")
rust_size_best=$(wc -c < "$TMP_DIR/rust_compressed_best.bin")

# --- Extract benchmark values ---
extract_go_time() {
    grep "$1" "$TMP_DIR/go_bench_output.txt" | awk '{print $3}'
}

extract_rust_time() {
    grep -A1 "$1" "$TMP_DIR/rust_bench_output.txt" | grep 'time:' | sed -E 's/.*\[(.*) .*/\1/' | sed 's/µs//' | awk '{printf "%.0f", $1 * 1000}'
}

# Go results
go_compress_default=$(extract_go_time "BenchmarkCompressDefault")
go_compress_fast=$(extract_go_time "BenchmarkCompressFast")
go_compress_best=$(extract_go_time "BenchmarkCompressBest")
go_decompress_default=$(extract_go_time "BenchmarkDecompressDefault")
go_decompress_fast=$(extract_go_time "BenchmarkDecompressFast")
go_decompress_best=$(extract_go_time "BenchmarkDecompressBest")

# Rust results
rust_compress_default=$(extract_rust_time "rust_zlib_compress_default")
rust_compress_fast=$(extract_rust_time "rust_zlib_compress_fast")
rust_compress_best=$(extract_rust_time "rust_zlib_compress_best")
rust_decompress_default=$(extract_rust_time "rust_zlib_decompress_default")
rust_decompress_fast=$(extract_rust_time "rust_zlib_decompress_fast")
rust_decompress_best=$(extract_rust_time "rust_zlib_decompress_best")

# --- Print Table ---
echo ""
echo "=== 📊 Benchmark Comparison (ns/op, size in bytes) ==="
printf "%-35s %-15s %-15s\n" "Metric" "Go" "Rust"
printf "%-35s %-15s %-15s\n" "Compression (Default)" "$go_compress_default ($go_size_default)" "$rust_compress_default ($rust_size_default)"
printf "%-35s %-15s %-15s\n" "Compression (Fast)" "$go_compress_fast ($go_size_fast)" "$rust_compress_fast ($rust_size_fast)"
printf "%-35s %-15s %-15s\n" "Compression (Best)" "$go_compress_best ($go_size_best)" "$rust_compress_best ($rust_size_best)"
printf "%-35s %-15s %-15s\n" "Decompression (Default)" "$go_decompress_default" "$rust_decompress_default"
printf "%-35s %-15s %-15s\n" "Decompression (Fast)" "$go_decompress_fast" "$rust_decompress_fast"
printf "%-35s %-15s %-15s\n" "Decompression (Best)" "$go_decompress_best" "$rust_decompress_best"

