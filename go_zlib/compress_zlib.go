package main

import (
    "bytes"
    "compress/zlib"
    "io"
    "os"
)

func main() {
    if len(os.Args) < 3 {
        panic("Usage: compress_zlib <input> <level: default|fast|best>")
    }

    inputFile := os.Args[1]
    level := zlib.DefaultCompression
    switch os.Args[2] {
    case "fast":
        level = zlib.BestSpeed
    case "best":
        level = zlib.BestCompression
    }

    input, _ := os.ReadFile(inputFile)
    var buf bytes.Buffer
    w, _ := zlib.NewWriterLevel(&buf, level)
    w.Write(input)
    w.Close()
    io.Copy(os.Stdout, &buf)
}
