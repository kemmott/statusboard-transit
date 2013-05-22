require 'sinatra/base'
require 'rest-client'
require 'nokogiri'
require 'tzinfo'
require 'json'

class ClarendonRoutes < Sinatra::Base

	get '/stock' do
		resp = RestClient.get("http://www.google.com/ig/api?stock=COF&stock=AAPL")
		doc = Nokogiri::XML(resp)
		"COF,#{doc.css('last')[1].attributes['data'].value}\nAAPL,#{a_doc.css('last')[0].attributes['data'].value}"
	end

	get '/routes' do
		tz = TZInfo::Timezone.get('America/New_York')
		begin
			page_38b_west = RestClient.get("http://wmata.nextbus.com/customStopSelector/fancyNewPredictionLayer.jsp?a=wmata&r=38B&d=38B_38B_0&s=4880&ts=4823")
		    npage_38b_west = Nokogiri::HTML(page_38b_west)
		    time1_38b_west = npage_38b_west.css(".firstPrediction").text.match("[0-9]+|Arriving").to_s
		    time2_38b_west = npage_38b_west.css(".secondaryPredictions")[0].text.match("[0-9]+").to_s
		rescue StandardError=>e
			puts "[#{Time.now}] Bus REST Error: #{e}"
		end

	    begin
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
		rescue StandardError=>e
			puts "[#{Time.now}] Orange Line REST Error: #{e}"
		end
		transit_times = {
			:transit_times=>[
				{
					:route=>"38b",
					:directions=>[
						{
							:direction=>"west",
							:times=>[
								time1_38b_west,
								time2_38b_west
							]
						}
					]
				},
				{
					:route=>"orange",
					:directions=>[
						{
							:direction=>"west",
							:times=>[
								time1_orange_west,
								time2_orange_west
							]
						},
						{
							:direction=>"east",
							:times=>[
								time1_orange_east,
								time2_orange_east
							]
						}
					]
				}
			]
		}

		puts transit_times
	    JSON.pretty_generate(transit_times)

	end

	get '/' do
		"<a href='/transit_routes.html'>Transit Route Times</a>"
	end


end