import requests
import datetime
from dotenv import load_dotenv
import os

load_dotenv()



def getPointDataDaily(lat, lon):
    url = "https://meteostat.p.rapidapi.com/point/daily"
    date = datetime.datetime.now().date()

    querystring = {"lat":lat,"lon":lon,"start":date,"end":date}

    headers = {
        'x-rapidapi-host': "meteostat.p.rapidapi.com",
        'x-rapidapi-key': os.getenv("RAPID_API_KEY")
    }

    response = requests.get(url, headers=headers, params=querystring)
    return response.json()

def getPointDataHourly(lat, lon):
    url = "https://meteostat.p.rapidapi.com/point/hourly"
    date = datetime.datetime.now().date()

    querystring = {"lat":lat,"lon":lon,"start":date,"end":date}

    headers = {
        'x-rapidapi-host': "meteostat.p.rapidapi.com",
        'x-rapidapi-key': os.getenv("RAPID_API_KEY")
    }

    response = requests.get(url, headers=headers, params=querystring)
    return response.json()