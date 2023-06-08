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

# 安装 Cloudflare Argo
RUN wget -O argo https://github.com/cloudflare/cloudflared/releases/download/2023.5.1/cloudflared-linux-amd64 && \
    chmod +x argo

# 安装 Xray
RUN wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    chmod +x xray

# 安装 Python 依赖
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Start the application with the start.sh script and uvicorn
ENTRYPOINT ["./start.sh"]
