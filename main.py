from flask import Flask
import threading
import subprocess

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

def start_tunnel_and_xray():
    subprocess.call(['nohup', '/app/argo', 'tunnel', '--edge-ip-version', 'auto', 'run', '--token', '$Token', '>/dev/null', '2>&1', '&'])
    subprocess.call(['nohup', '/app/xray', '-c', './config.json', '>/dev/null', '2>&1', '&'])

if __name__ == '__main__':
    # 启动 Cloudflare Argo 隧道和 Xray 代理服务
    threading.Thread(target=start_tunnel_and_xray).start()

    # 启动 Flask 应用程序
    app.run(host='0.0.0.0', port=5000)
