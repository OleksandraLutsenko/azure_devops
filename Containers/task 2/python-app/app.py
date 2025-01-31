from flask import Flask
from config import Config  # Import the config file

app = Flask(__name__)
app.config.from_object(Config)  # Load configuration from config.py

@app.route("/")
def home():
    return (
        f"🚀 Flask App Running!<br>"
        f"🔹 Debug Mode: {app.config['DEBUG']}<br>"
        f"🔑 API Key: {app.config['API_KEY']}<br>"
        f"📡 Database URL: {app.config['DATABASE_URL']}<br>"
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=app.config["PORT"], debug=app.config["DEBUG"])
    