import os
import requests


api_key = os.getenv("API_KEY", "Key not found")
latitude = float(os.getenv("LAT", "48.8566"))
longitude = float(os.getenv("LONG", "2.3522"))
url = f'https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={api_key}'
response = requests.get(url)

if response.status_code == 200:
    data = response.json()
    description = data['weather'][0]['description']
    temperature = data['main']['temp'] - 273.15
    print(f"The weather at the longitude and latitude given is {description} and the temperature reaches {temperature:.2f} degrés Celsius.")
