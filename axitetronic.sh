#!/bin/bash

SPEEDTEST_SERVER=24374 #GTT NYC
swapoff -a

apt update && apt dist-upgrade -y
apt install sysbench nginx mysql-server python redis-server zip unzip -y

apt install gnupg1 apt-transport-https dirmngr
export INSTALL_KEY=379CE192D401AB61
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY
echo "deb https://ookla.bintray.com/debian generic main" | sudo tee  /etc/apt/sources.list.d/speedtest.list
apt update
apt install speedtest

mkdir results

cat /proc/cpuinfo > results/proc-cpuinfo.txt

sysbench cpu run > results/sysbench-cpu.txt

sysbench memory --memory-oper=read run > results/sysbench-memory-read.txt
sysbench memory --memory-oper=write run > results/sysbench-memory-write.txt

sysbench fileio prepare
sysbench fileio --file-test-mode=rndrw run > results/sysbench-fileio.txt
sysbench fileio cleanup

sysbench threads --threads=10 run > results/sysbench-threads.txt
sysbench mutex--threads=10 run > results/sysbench-mutex.txt

mysql -uroot -e "CREATE DATABASE sbtest;"

TESTS=(
  "bulk_insert"
  "oltp_delete"
  "oltp_insert"
  "oltp_point_select"
  "oltp_read_only"
  "oltp_read_write"
  "oltp_update_index"
  "oltp_update_non_index"
  "oltp_write_only"
  "select_random_points"
  "select_random_ranges"
)

for TEST in "${TESTS[@]}"; do
  sysbench --db-driver=mysql --table-size=1000000 --mysql-user=root "/usr/share/sysbench/$TEST.lua" prepare
  sysbench --db-driver=mysql --table-size=1000000 --mysql-user=root "/usr/share/sysbench/$TEST.lua" run > "results/sysbench-mysql-$TEST.txt"
  sysbench --db-driver=mysql --table-size=1000000 --mysql-user=root "/usr/share/sysbench/$TEST.lua" cleanup
done

redis-benchmark -q -n 100000 --csv > results/redis-benchmark.txt

speedtest --format=human-readable --server-id="$SPEEDTEST_SERVER" > results/speedtest1.txt
speedtest --format=human-readable --server-id="$SPEEDTEST_SERVER" > results/speedtest2.txt
speedtest --format=human-readable --server-id="$SPEEDTEST_SERVER" > results/speedtest3.txt

zip -r -0 results.zip results/
