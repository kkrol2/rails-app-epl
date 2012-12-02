class FixturesController < ApplicationController
  
  def index
	page_content = open('http://www.premierleague.com/en-gb/matchday/matches.html')
	#puts page_content
	html_doc = Nokogiri::HTML(page_content)
	begin
		array = getMatchesList(html_doc)
		Fixture.delete_all
		array.each do |fixture|
			fixture.save
		end
	rescue Exception=>e
		array = Fixture.all
	end
	j = ActiveSupport::JSON
	respond_to do |format|
    	format.json { render :json => j.encode(array) }
    end

  end

  def getMatchesList(html)
  	array = Array.new
  	html.css("table.contentTable").each do |elem|
 
  		elem.css("tr").each do |match|
  			if match.at_css("td.clubs")
  				date = elem.css("tr")[0].to_str()
  				fixture = Fixture.new
  				clubs = match.css("td.clubs")[0].to_str()
  				fixture.first_team = (clubs.split("v")[0]).gsub("\r\n","").strip
  				fixture.second_team =(clubs.split("v")[1]).gsub("\r\n","").strip
  				time=match.css("td.time")[0].to_str()
  				date=date.split("\r\n")[0]+format_string(time)
  				fixture.date = date
  				fixture.location = match.css("td.location").css("a").text
  				array.push(fixture)

  			end
  		end
  	end
  	array
  end

  def format_string(s)
  	@replacements = [
      [ " " , ""],
      [ "\r\n" , ""],
    ]
  	@replacements.each do |pair|
    	s.gsub!(pair[0], pair[1])
  	end
  	s
  end

  def open(url)
  	require 'net/http'
  	require 'uri'
  	Net::HTTP.get(URI.parse(url))
  end
end
