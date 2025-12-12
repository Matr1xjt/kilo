#!/bin/bash
# 快速重新编译并更新 kilo 到 disk

set -e

echo "==> Building axlibc..."
cd ../../ulib/axlibc
cargo build --release --target riscv64gc-unknown-none-elf --features userlib > /dev/null 2>&1 || {
    echo "axlibc build failed!"
    exit 1
}

cd ../../user_programs/kilo

echo "==> Cleaning kilo..."
make clean

echo "==> Building kilo..."
make

echo "==> Copying to disk..."
cp ../bin/kilo ../../disk/bin/kilo

echo "==> Done! kilo updated in disk/bin/"
ls -lh ../../disk/bin/kilo
