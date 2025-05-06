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

echo "===> Compressing input with Go..."
go run "$GO_DIR/compress_zlib.go" "$INPUT_FILE" > "$TMP_DIR/go_compressed.bin"

echo "===> Compressing input with Rust..."
cargo run --manifest-path "$RUST_DIR/Cargo.toml" --bin compress_zlib "$INPUT_FILE" "$TMP_DIR/rust_compressed.bin"

# File size comparison
go_size=$(wc -c < "$TMP_DIR/go_compressed.bin")
rust_size=$(wc -c < "$TMP_DIR/rust_compressed.bin")

# Extract benchmark times
go_compress=$(grep 'BenchmarkZlibCompress' "$TMP_DIR/go_bench_output.txt" | awk '{print $3}')
go_decompress=$(grep 'BenchmarkZlibDecompress' "$TMP_DIR/go_bench_output.txt" | awk '{print $3}')

rust_compress=$(grep -A1 "rust_zlib_compress" "$TMP_DIR/rust_bench_output.txt" | grep 'time:' | sed -E 's/.*\[(.*) .*/\1/' | sed 's/µs//' | awk '{printf "%.0f", $1 * 1000}')
rust_decompress=$(grep -A1 "rust_zlib_decompress" "$TMP_DIR/rust_bench_output.txt" | grep 'time:' | sed -E 's/.*\[(.*) .*/\1/' | sed 's/µs//' | awk '{printf "%.0f", $1 * 1000}')

echo ""
echo "=== 📊 Benchmark Comparison ==="
printf "%-30s %-15s %-15s\n" "Metric" "Go" "Rust"
printf "%-30s %-15s %-15s\n" "Compression Time (ns/op)" "$go_compress" "$rust_compress"
printf "%-30s %-15s %-15s\n" "Decompression Time (ns/op)" "$go_decompress" "$rust_decompress"
printf "%-30s %-15s %-15s\n" "Compressed Size (bytes)" "$go_size" "$rust_size"

