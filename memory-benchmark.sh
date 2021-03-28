#!/bin/bash
#This script was created to thoroughly benchmark the memory performance of a system utilizing sysbench. This has been tested on Debian 10.

#Update the package repository and upgrade packages
apt update && apt -y dist-upgrade
#Install sysbench, zip & unzip
curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | bash
apt -y install sysbench zip unzip

#Create the results directory
mkdir results

#Gather memory information and place it in a text file
cat /proc/meminfo > results/proc-meminfo.txt

#Perform default sysbench memory read and write benchmarks
sysbench memory --memory-oper=read run > results/sysbench-memory-read-default.txt
sysbench memory --memory-oper=write run > results/sysbench-memory-write-default.txt

#Perform 1K block size sysbench memory sequential read and write benchmarks with a total of 100GB of data transferred.
sysbench memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-access-mode=seq --memory-oper=read run > results/sysbench-memory-bs-1K-seq-read.txt
sysbench memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-access-mode=seq --memory-oper=write run > results/sysbench-memory-bs-1K-seq-write.txt

#Perform 1M block size sysbench memory sequential read and write benchmarks with a total of 100GB of data transferred.
sysbench memory --memory-block-size=1M --memory-scope=global --memory-total-size=100G --memory-access-mode=seq --memory-oper=read run > results/sysbench-memory-bs-1M-seq-read.txt
sysbench memory --memory-block-size=1M --memory-scope=global --memory-total-size=100G --memory-access-mode=seq --memory-oper=write run > results/sysbench-memory-bs-1M-seq-write.txt

#Perform 1G block size sysbench memory sequential read and write benchmarks with a total of 100GB of data transferred.
sysbench memory --memory-block-size=1G --memory-scope=global --memory-total-size=100G --memory-access-mode=seq --memory-oper=read run > results/sysbench-memory-bs-1G-seq-read.txt
sysbench memory --memory-block-size=1G --memory-scope=global --memory-total-size=100G --memory-access-mode=seq --memory-oper=write run > results/sysbench-memory-bs-1G-seq-write.txt

#Perform 1K block size sysbench memory random read and write benchmarks with a total of 100GB of data transferred.
sysbench memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-access-mode=rnd--memory-oper=read run > results/sysbench-memory-bs-1K-rnd-read.txt
sysbench memory --memory-block-size=1K --memory-scope=global --memory-total-size=100G --memory-access-mode=rnd --memory-oper=write run > results/sysbench-memory-bs-1K-rnd-write.txt

#Perform 1M block size sysbench memory random read and write benchmarks with a total of 100GB of data transferred.
sysbench memory --memory-block-size=1M --memory-scope=global --memory-total-size=100G --memory-access-mode=rnd --memory-oper=read run > results/sysbench-memory-bs-1M-rnd-read.txt
sysbench memory --memory-block-size=1M --memory-scope=global --memory-total-size=100G --memory-access-mode=rnd --memory-oper=write run > results/sysbench-memory-bs-1M-rnd-write.txt

#Perform 1G block size sysbench memory random read and write benchmarks with a total of 100GB of data transferred.
sysbench memory --memory-block-size=1G --memory-scope=global --memory-total-size=100G --memory-access-mode=rnd --memory-oper=read run > results/sysbench-memory-bs-1G-rnd-read.txt
sysbench memory --memory-block-size=1G --memory-scope=global --memory-total-size=100G --memory-access-mode=rnd --memory-oper=write run > results/sysbench-memory-bs-1G-rnd-write.txt

#Wrap up the results folder into a package
zip -r -0 results.zip results/
