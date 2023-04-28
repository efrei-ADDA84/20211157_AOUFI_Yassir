from flask import Flask, jsonify
import os
import requests

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST', 'PUT'])
def weather():
    lat = 48.85667
    lon = 2.35222
    api_key = os.environ.get('API_KEY')
    url = f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}'
    response = requests.get(url)
    if response.status_code == 200:
        weather_data = response.json()
        response = {
            'temperature': round(weather_data['main']['temp'] - 272.15, 2), 
            'description': weather_data['weather'][0]['description']
        }
        return jsonify(response)
    else:
        return jsonify({'error': 'unable to get weather data'})

if __name__ == '__main__':
   
    app.run(host='0.0.0.0', port=8081)
