require 'uri'
require 'net/http'
require 'json'

ELEVATION_BASE_URL = 'http://maps.google.com/maps/api/elevation/json'
CHART_BASE_URL = 'http://chart.apis.google.com/chart'

def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false", *elvtn_args)

    # stworzenie hashmap dla argumentow podanych w funkcji
    elvtn_args = {}

    elvtn_args.update({
        path: path,
        samples: samples,
        sensor: sensor
    })

    # generowanie url na podstawie hashmap

    url = ELEVATION_BASE_URL + '?' + URI.encode_www_form(elvtn_args)

    # pobranie zawartosci z tego adresu (po wczesniejszym parsowaniu na adres i strone)
    response = Net::HTTP.get(URI.parse(url))
    response = JSON.parse(response)

    elevationArray = []

    # iteracja po elementach elevation z czesci results
    
    for resultset in response['results']
      tmp = resultset['elevation'].round(7)
      elevationArray.insert(-1, tmp) #dodawanie do konca tablicy)
    end

    getChart(chartData=elevationArray)
end

def getChart(chartData, chartDataScaling="-500,5000", chartType="lc",chartLabel="Elevation in Meters",chartSize="500x160", chartColor="orange", *chart_args)

    chart_args = {}
    chart_args.update({
      cht: chartType,
      chs: chartSize,
      chl: chartLabel,
      chco: chartColor,
      chds: chartDataScaling,
      chxt: 'x,y',
      chxr: '1,-500,5000'
    })

    dataString = 't:' + chartData.join(",")
    chart_args['chd'] = dataString

    chartUrl = CHART_BASE_URL + '?' + URI.encode_www_form(chart_args)

    puts "Wygenerowano:\n"
    puts chartUrl

end


puts("")
puts("Elevation Chart Maker 1.0 przekodowane na Ruby")
puts("")

puts("Podaj pierwsza wspolrzedna (np 5.231,21.543), domyslnie Mt Whitney: ")
first = gets
puts("Podaj druga wspolrzedna, domyslnie Death Valley: ")
second = gets

first.chop!
second.chop!

if first.empty? 
	first = "36.578581,-118.291994"
	puts "ustawiono wartosci domyslne"
end

if second.empty? 
	second = "36.23998,-116.83171"
	puts "ustawiono wartosci domyslne"
end

pathStr = first + "|" + second

getElevation(pathStr)
