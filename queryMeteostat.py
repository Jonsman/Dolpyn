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

'''
test = getMeteostatDaily(51.6167, 7.6167)
print(test.info())

tavg_data = test['tavg']
tavg_data = tavg_data.astype(str)
tmin_data = test['tmin']
tmax_data = test['tmax']

print(tavg_data)
print(type(tavg_data))
'''
