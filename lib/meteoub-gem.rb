require 'net/http'
require 'date'
require 'active_record'

module MeteoUB
  DATA_URL   = 'http://infomet.meteo.ub.edu/campbell/www.dat'
  MAXMIN_URL = 'http://infomet.meteo.ub.edu/campbell/maxmin.dat'

  class Data
    attr_accessor :data_uri
    attr_accessor :raw_data

    attr_accessor :datetime
    attr_accessor :temperature
    attr_accessor :pressure
    attr_accessor :humidity
    attr_accessor :sunrise
    attr_accessor :sunset
    attr_accessor :rain
    attr_accessor :precipitation
    attr_accessor :max_wind_speed
    attr_accessor :max_wind_speed_km_h
    attr_accessor :windrose
    attr_accessor :temperature_max
    attr_accessor :datetime_max
    attr_accessor :temperature_min
    attr_accessor :datetime_min

    def initialize
      @data_uri   = URI(DATA_URL)
      @maxmin_uri = URI(MAXMIN_URL)
      parse if get
    end

    def get
      @raw_data   = Net::HTTP.get(@data_uri).split("\n")
      @raw_maxmin = Net::HTTP.get(@maxmin_uri).split("\n")
      @raw_data && @raw_maxmin
    end

    def parse
      @datetime             = DateTime.strptime(@raw_data[0] + " " + @raw_data[1] + " UTC", "%d-%m-%y %k:%M %Z")
      @temperature          = @raw_data[2].to_f
      @pressure             = @raw_data[10].to_f
      @humidity             = @raw_data[7].to_f
      @sunrise              = parse_date(@raw_data[19]) if @raw_data[19]
      @sunset               = parse_date(@raw_data[20]) if @raw_data[20]
      @rain                 = @raw_data[22].to_i == 1
      @precipitation        = @raw_data[21].to_i
      @max_wind_speed       = @raw_data[12].to_f
      @max_wind_speed_km_h  = @max_wind_speed * 3.6
      @windrose             = parse_windrose(@raw_data[13].to_f)
      @temperature_max, @datetime_max = parse_maxmin(@raw_maxmin[0])
      @temperature_min, @datetime_min = parse_maxmin(@raw_maxmin[1])
    end

    def parse_date(date_raw)
      hour, minutes = sanitize_time(date_raw.split(":"))
      DateTime.strptime(@raw_data[0] + " #{hour}:#{minutes} UTC", "%d-%m-%y %k:%M %Z")
    end

    def parse_maxmin(maxmin_raw)
      temperature, time, date = maxmin_raw.split(" ")
      hour, minutes = sanitize_time(time.split(":"))
      [temperature.to_f, DateTime.strptime("#{date} #{hour}:#{minutes} UTC", "%Y%m%d %k:%M %Z")]
    end

    def sanitize_time(time_split)
      if time_split[1] == "60"
        time_split[1] = 0
        time_split[0] = time_split[0].to_i + 1
      end
      time_split
    end

    # http://cbc.riocean.com/wstat/012006rose.html
    def parse_windrose(windrose_raw)
      case(windrose_raw)
      when (0..11.25)
         return "N"
       when (11.26..33.75)
         return "NNE"
       when (33.76..56.25)
         return "NE"
       when (56.26..78.75)
         return "ENE"
       when (78.76..101.25)
         return "E"
       when (101.26..123.75)
         return "ESE"
       when (123.76..146.25)
         return "SE"
       when (146.26..168.75)
         return "SSE"
       when (168.76..191.25)
         return "S"
       when (191.16..213.75)
         return "SSW"
       when (213.76..236.25)
         return "SW"
       when (236.26..258.75)
         return "WSW"
       when (258.76..281.25)
         return "W"
       when (281.26..303.75)
         return "WNW"
       when (303.76..326.25)
         return "NW"
       when (326.26..348.75)
         return "NNW"
       when (348.76..360.0)
         return "N"
       else
         return "???"
      end
    end

    def save
      measure = Measure.new({:datetime => @datetime, :temperature => @temperature})
      measure.save
    end
	end
  class Measure < ActiveRecord::Base
  end
  class MeasureTable < ActiveRecord::Migration
    def self.up
    create_table :measures do |t|
      t.datetime :datetime
      t.float :temperature
      t.timestamps
    end
    end
    def self.down
      drop_table :measures
    end
  end
end
