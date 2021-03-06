#!/bin/bash
#
# Weather
# =======
#
# By Jezen Thomas <jezen@jezenthomas.com>
#
# This script sends a couple of requests over the network to retrieve
# approximate location data, and the current weather for that location. This is
# useful if for example you want to display the current weather in your tmux
# status bar.

# There are three things you will need to do before using this script.
#
# 1. Install jq with your package manager of choice (homebrew, apt-get, etc.)
# 2. Sign up for a free account with OpenWeatherMap to grab your API key
# 3. Add your OpenWeatherMap API key where it says API_KEY

# OPENWEATHERMAP API KEY (place yours here)
API_KEY="203f83b111a2007b23929eaf803fd893"

set -e

# Not all icons for weather symbols have been added yet. If the weather
# category is not matched in this case statement, the command output will
# include the category ID. You can add the appropriate emoji as you go along.
#
# Weather data reference: http://openweathermap.org/weather-conditions
weather_status(){
	case $1 in
		200) echo "thunderstorm with light rain";;
		201) echo "thunderstorm with rain";;
		202) echo "thunderstorm with heavy rain";;
		210) echo "light thunderstorm";;
		211) echo "thunderstorm";;
		212) echo "heavy thunderstorm";;
		221) echo "ragged thunderstorm";;
		230) echo "thunderstorm with light drizzle";;
		231) echo "thunderstorm with drizzle";;
		232) echo "thunderstorm with heavy";;
		300) echo "light intensity drizzle";;
		301) echo "drizzle";;
		302) echo "heavy intensity drizzle";;
		310) echo "light intensity drizzle rain";;
		311) echo "drizzle rain";;
		312) echo "heavy intensity drizzle rain";;
		313) echo "shower rain and drizzle";;
		314) echo "heavy shower rain and drizzle";;
		321) echo "shower drizzle";;
		500) echo "light rain";;
		501) echo "moderate rain";;
		502) echo "heavy intensity rain";;
		503) echo "very heavy rain";;
		504) echo "extreme rain";;
		511) echo "freezing rain";;
		520) echo "light intensity shower rain";;
		521) echo "shower rain";;
		522) echo "heavy intensity shower rain";;
		531) echo "ragged shower rain";;
		600) echo "light snow";;
		601) echo "snow";;
		602) echo "heavy snow";;
		611) echo "sleet";;
		612) echo "shower sleet";;
		615) echo "light rain and snow";;
		616) echo "rain and snow";;
		620) echo "light shower snow";;
		621) echo "shower snow";;
		622) echo "heavy shower snow";;
		701) echo "mist";;
		711) echo "smoke";;
		721) echo "haze";;
		731) echo "sand, dust whirls";;
		741) echo "fog";;
		751) echo "sand";;
		761) echo "dust";;
		762) echo "volcanic ash";;
		771) echo "squalls";;
		781) echo "tornado";;
		800) if [ $SUNRISE <= $TIME <= $SUNSET ]; then
			echo Sunny
		else
			echo Clear Sky
		fi;;
		801) echo "few clouds";;
		802) echo "scattered clouds";;
		803) echo "broken clouds";;
		804) echo "overcast clouds";;
		*) echo "$1"
	esac
}

LOCATION=$(curl --silent http://ip-api.com/csv)
CITY=$(echo "$LOCATION" | cut -d , -f 6)
LAT=$(echo "$LOCATION" | cut -d , -f 8)
LON=$(echo "$LOCATION" | cut -d , -f 9)

WEATHER=$(curl --silent http://api.openweathermap.org/data/2.5/weather\?lat="$LAT"\&lon="$LON"\&APPID="$API_KEY"\&units=metric)

CATEGORY=$(echo "$WEATHER" | jq .weather[0].id)
TEMP="$(echo "$WEATHER" | jq .main.temp | cut -d . -f 1)??C"
WIND_SPEED="$(echo "$WEATHER" | jq .wind.speed | awk '{print int($1+0.5)}')ms"
STATUS=$(weather_status "$CATEGORY")

SUNRISE="$(echo "$WEATHER" | jq .sys.sunrise)"
SUNSET="$(echo "$WEATHER" | jq .sys.sunset)"
TIME="$(echo "$WEATHER" | jq .dt)"

printf "%s" "$CITY: $STATUS, $TEMP, $WIND_SPEED" 
