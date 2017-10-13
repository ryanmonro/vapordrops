function getLocation() {
  if (navigator.geolocation) {
    console.log("got location");
    navigator.geolocation.getCurrentPosition(setPosition);
  } else { 
    console.log("didn't got location");
    setLocations(false);
  }
}

function setPosition(position) {
  deviceLat = position.coords.latitude;
  deviceLong = position.coords.longitude;
  document.querySelector("#latbox").value = deviceLat;
  document.querySelector("#longbox").value = deviceLong;
}

getLocation();