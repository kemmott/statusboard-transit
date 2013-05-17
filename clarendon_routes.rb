require 'sinatra/base'
require 'rest-client'
require 'nokogiri'

class ClarendonRoutes < Sinatra::Base

	get '/' do
		page_38b_west = RestClient.get("http://wmata.nextbus.com/customStopSelector/fancyNewPredictionLayer.jsp?a=wmata&r=38B&d=38B_38B_0&s=4880&ts=4823")
	    npage_38b_west = Nokogiri::HTML(page_38b_west)
	    time1_38b_west = npage_38b_west.css(".firstPrediction").text.match("[0-9]+|Arriving").to_s
	    time2_38b_west = npage_38b_west.css(".secondaryPredictions")[0].text.match("[0-9]+").to_s

	    page_orange = RestClient.get("http://www.wmata.com/rider_tools/pids/showpid.cfm?station_id=97")
	    npage_orange = Nokogiri::HTML(page_orange)
	    time1_orange_west = npage_orange.css("table")[1].css("tbody tr td")[3].text.match("[0-9]+|ARR|BRD").to_s
	    if npage_orange.css("table")[1].css("tbody tr td")[7]
		    time2_orange_west = npage_orange.css("table")[1].css("tbody tr td")[7].text.match("[0-9]+").to_s
		end
	    time1_orange_east = npage_orange.css("table")[0].css("tbody tr td")[3].text.match("[0-9]+|ARR|BRD").to_s
	    if npage_orange.css("table")[0].css("tbody tr td")[7]
		    time2_orange_east = npage_orange.css("table")[0].css("tbody tr td")[7].text.match("[0-9]+").to_s
		end

		puts "[#{Time.now}] 38B W: #{time1_38b_west} - #{time2_38b_west}, O W: #{time1_orange_west} - #{time2_orange_west}, O E: #{time1_orange_east} - #{time2_orange_east}"

"<!DOCTYPE html>

<html lang='en'>
<head>
  <title>Clarendon WMATA</title>
    
  <meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, user-scalable=no' />
  <meta name='apple-mobile-web-app-capable' content='yes' />
    
  <link rel='stylesheet' type='text/css' href='/transit/css/style.css' />
  <script language='javascript'>
  	setTimeout('window.location.reload(true)', 60000);
  </script>
</head>
<body>
<div id='header'>Transit Info</div>
    <div id='trimet' class='small'>
        <div id='stops'>
			<div id='stop_1' class='stop westbound'>
				<div class='details'>
					<header class='route'>38B</header>
					<div class='dir-bubble' style="">W</div>
					<div class='description'>Wilson &amp; N Herndon</div>
					<div class='direction'>Westbound</div>
					<div class='locid'>1</div>
				</div>
				<div class='arrivals'>
					<div class='arrival'>#{time1_38b_west}#{if time1_38b_west.match('[0-9]') then ' min' end}</div>
					<div class='arrival'>#{time2_38b_west} min</div>
				</div>
			</div>
			<div id='stop_2' class='stop westbound'>
				<div class='details'>
					<header id='orange' class='route'>Or.</header>
					<div id='orange' class='dir-bubble' style="">W</div>
					<div class='description'>Clarendon &amp; N Highland</div>
					<div class='direction'>Westbound</div>
					<div class='locid'>2</div>
				</div>
				<div class='arrivals'>
					<div class='arrival'>#{time1_orange_west}#{if time1_orange_west.match('[0-9]') then ' min' end}</div>
					<div class='arrival'>#{time2_orange_west} min</div>
				</div>
			</div>
			<div id='stop_3' class='stop eastbound'>
				<div class='details'>
					<header id='orange' class='route'>Or.</header>
					<div id='orange' class='dir-bubble' style="">E</div>
					<div class='description'>Clarendon &amp; N Highland</div>
					<div class='direction'>Eastbound</div>
					<div class='locid'>3</div>
				</div>
				<div class='arrivals'>
					<div class='arrival'>#{time1_orange_east}#{if time1_orange_east.match('[0-9]') then ' min' end}</div>
					<div class='arrival'>#{time2_orange_east} min</div>
				</div>
			</div>
        </div>
    </div>
    <div id='header'>Want more bus lines listed?<br/>Ask Kevan.</div>
</body>
</html>"

	end

end