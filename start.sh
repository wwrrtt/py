#!/bin/sh

# 启动cf tunnel
nohup ./argo tunnel --edge-ip-version auto run --token $Token  >/dev/null 2>&1 &

# 启动xray
nohup ./xray run ./config.json >/dev/null 2>&1 &

# 启动Python应用程序
python3 main.py

echo "----- 系统进程...----- ."
ps -ef

echo "----- 系统信息...----- ."
cat /proc/version
echo "----- good luck (kid).----- ."