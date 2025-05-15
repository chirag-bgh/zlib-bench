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
| **Compression (Default)**   | 511,875 (6,372 B)   | 141,530 (6,634 B)   |
| **Compression (Fast)**      | 209,790 (6,888 B)   | 69,465 (10,565 B)   |
| **Compression (Best)**      | 641,862 (6,371 B)   | 294,520 (6,780 B)   |
| **Decompression (Default)** | 94,236              | 35,201              |
| **Decompression (Fast)**    | 102,733             | 35,462              |
| **Decompression (Best)**    | 93,994              | 36,062              |