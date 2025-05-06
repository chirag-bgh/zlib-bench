package main

import (
    "bytes"
    "compress/zlib"
    "io"
    "os"
    "testing"
)

func loadInput() []byte {
    input, _ := os.ReadFile("../bench_inputs/sample.txt")
    return input
}

func benchmarkCompress(b *testing.B, level int) {
    input := loadInput()
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        var buf bytes.Buffer
        w, _ := zlib.NewWriterLevel(&buf, level)
        w.Write(input)
        w.Close()
    }
}

func benchmarkDecompress(b *testing.B, level int) {
    input := loadInput()
    var buf bytes.Buffer
    w, _ := zlib.NewWriterLevel(&buf, level)
    w.Write(input)
    w.Close()
    compressed := buf.Bytes()

    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        r, _ := zlib.NewReader(bytes.NewReader(compressed))
        io.ReadAll(r)
        r.Close()
    }
}

func BenchmarkCompressDefault(b *testing.B) { benchmarkCompress(b, zlib.DefaultCompression) }
func BenchmarkCompressFast(b *testing.B)    { benchmarkCompress(b, zlib.BestSpeed) }
func BenchmarkCompressBest(b *testing.B)    { benchmarkCompress(b, zlib.BestCompression) }

func BenchmarkDecompressDefault(b *testing.B) { benchmarkDecompress(b, zlib.DefaultCompression) }
func BenchmarkDecompressFast(b *testing.B)    { benchmarkDecompress(b, zlib.BestSpeed) }
func BenchmarkDecompressBest(b *testing.B)    { benchmarkDecompress(b, zlib.BestCompression) }
