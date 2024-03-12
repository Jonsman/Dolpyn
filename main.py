from flask import Flask, request, render_template, jsonify
import queryRapidapi
import queryMeteostat
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/info')
def info():
    return render_template('info.html')

@app.route('/daily')
def daily():
    try:
        lat = float(request.args.get('lat'))
        lon = float(request.args.get('lon'))
    except:
        return "Request like this /daily?lat=51.61&lon=7.52 to get the weather data for today.", 400
    return queryRapidapi.getPointDataDaily(lat, lon)

@app.route('/hourly')
def hourly():
    try:
        lat = float(request.args.get('lat'))
        lon = float(request.args.get('lon'))
    except:
        return "Request like this /hourly?lat=51.61&lon=7.52 to get the hourly weather data for today.", 400
    return queryRapidapi.getPointDataHourly(lat, lon)

@app.route('/rapidapikey')
def token():
    return jsonify({
        "x-rapidapi-key": os.getenv("RAPID_API_KEY")
    })

if __name__ == "__main__":
    #app.run(host="0.0.0.0", port=5000, debug=True)
    app.run(host="0.0.0.0", port=5000)