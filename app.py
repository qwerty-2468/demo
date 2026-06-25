from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Hello, DevOps World!</h1><p>Your continuous deployment pipeline on Google Cloud is fully working via Nginx!</p>"

if __name__ == "__main__":
    # Tells the app to listen on all interfaces (0.0.0.0) on Port 5000
    app.run(host="0.0.0.0", port=80)