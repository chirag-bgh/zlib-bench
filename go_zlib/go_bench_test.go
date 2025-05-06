// go_bench_test.go
package main

import (
    "bytes"
    "compress/zlib"
    "io"
    "os"
    "testing"
)

func BenchmarkZlibCompress(b *testing.B) {
    input, _ := os.ReadFile("../bench_inputs/sample.txt")
    b.ResetTimer()

    for i := 0; i < b.N; i++ {
        var buf bytes.Buffer
        w := zlib.NewWriter(&buf)
        w.Write(input)
        w.Close()
    }
}

func BenchmarkZlibDecompress(b *testing.B) {
    input, _ := os.ReadFile("../bench_inputs/sample.txt")
    var buf bytes.Buffer
    w := zlib.NewWriter(&buf)
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

