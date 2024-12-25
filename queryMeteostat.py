from datetime import datetime
from meteostat import Point, Daily, Hourly

def getMeteostatDaily(lat, lon):
    date = datetime(datetime.now().year, datetime.now().month, datetime.now().day)
    point = Point(lat, lon)
    weather = Daily(point, date, date)
    weather = weather.fetch()
    return weather

def getMeteostatHourly(lat, lon):
    date = datetime(datetime.now().year, datetime.now().month, datetime.now().day)
    point = Point(lat, lon)
    weather = Hourly(point, date, date)
    weather = weather.fetch()
    return weather