This project benchmarks and compares the performance and compression efficiency of `zlib` implementations in **Go** and **Rust**.

It measures:
- Compression and decompression time
- Compressed output size

Run benchmarks
```sh
./run_benchmarks.sh
```

### 📊 Benchmark Comparison (ns/op, size in bytes)

| Metric                      | Go (ns, size)      | Rust (ns, size)    |
|-----------------------------|---------------------|---------------------|
| **Compression (Default)**   | 512,077 (6,372 B)   | 334,090 (6,774 B)   |
| **Compression (Fast)**      | 214,264 (6,888 B)   | 80,253 (7,144 B)    |
| **Compression (Best)**      | 640,341 (6,371 B)   | 516,790 (6,766 B)   |
| **Decompression (Default)** | 92,822              | 35,413              |
| **Decompression (Fast)**    | 102,162             | 41,744              |
| **Decompression (Best)**    | 93,992              | 35,169              |