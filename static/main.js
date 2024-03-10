// Using Leaflet
// Initialize the map
const map = L.map('map', {
    center: [30, 0],
    zoom: 1,
});

let marker;

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);

window.searchLocation = function() {
    let location = document.getElementById('location').value;
    fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${location}`)
        .then(response => response.json())
        .then(data => {
            if (data.length > 0) {
                let lat = data[0].lat;
                let lon = data[0].lon;
                map.setView([lat, lon], 12);
                if (marker) {
                    map.removeLayer(marker);
                }
                marker = L.marker([lat, lon]).addTo(map);
                fetchWeather(lat, lon);
            }
        });
}

let rapidapikey;

fetch('/rapidapikey')
    .then(response => response.json())
    .then(data => {
        rapidapikey = data['x-rapidapi-key'];
    });

const date = new Date();
const year = date.getFullYear();
const month = ("0" + (date.getMonth() + 1)).slice(-2);  // Add 1 to month, and take the last two characters
const day = ("0" + date.getDate()).slice(-2);  // Take the last two characters

const formattedDate = year + "-" + month + "-" + day;

function fetchWeather(lat, lon) {
    fetch(`https://meteostat.p.rapidapi.com/point/daily?lat=${lat}&lon=${lon}&start=${formattedDate}&end=${formattedDate}`,{
        method: 'GET',
        headers: {
            "x-rapidapi-host": "meteostat.p.rapidapi.com",
            "x-rapidapi-key": rapidapikey,
        },
    })
    .then(response => response.json())
    .then(data => {
        if (data.data && data.data.length > 0) {
            document.getElementById('tavg').textContent = 'Average Temperature: ' + data.data[0].tavg + '°C';
            document.getElementById('tmin').textContent = 'Min Temperature: ' + data.data[0].tmin + '°C';
            document.getElementById('tmax').textContent = 'Max Temperature: ' + data.data[0].tmax + '°C';
        }
        else {
            document.getElementById('tavg').textContent = 'Average Temperature: N/A';
            document.getElementById('tmin').textContent = 'Min Temperature: N/A';
            document.getElementById('tmax').textContent = 'Max Temperature: N/A';
        }
    });
}