# 使用Python基础镜像
FROM python:3
EXPOSE 5000

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    wget \
    unzip

# 升级pip
RUN pip install --upgrade pip

# 将 app.py 复制到容器中
COPY main.py /app/main.py
COPY config.json /app/config.json
COPY start.sh /app/start.sh

# 为脚本设置可执行权限
RUN chmod +x start.sh

# 下载 Cloudflare Argo 隧道
RUN wget -O argo https://github.com/cloudflare/cloudflared/releases/download/2024.5.0/cloudflared-linux-amd64 && \
    chmod +x /app/argo

# 下载 Xray
RUN wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip temp.zip xray && \
    mv /app/xray /app/web && \
    chmod +x /app/web && \
    rm temp.zip

# 安装 Python 依赖
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Start the application with the start.sh script and uvicorn
ENTRYPOINT ["./start.sh"]
