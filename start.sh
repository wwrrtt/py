#!/bin/sh

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
VMESS_WSPATH=${VMESS_WSPATH:-'/vmess'}
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g" config.json

# 启动xray
nohup ./web run -config ./config.json >/dev/null 2>&1 &

# 启动cf tunnel
nohup ./argo tunnel --edge-ip-version auto run --token $TOKEN  >/dev/null 2>&1 &

# 启动Python应用程序
python3 main.py

echo "----- 系统进程...----- ."
ps -ef

echo "----- 系统信息...----- ."
cat /proc/version
echo "----- good luck (kid).----- ."
