package main

import (
    "bytes"
    "compress/zlib"
    "io"
    "os"
)

func main() {
    input, _ := os.ReadFile(os.Args[1])
    var buf bytes.Buffer
    w := zlib.NewWriter(&buf)
    w.Write(input)
    w.Close()
    io.Copy(os.Stdout, &buf)
}

