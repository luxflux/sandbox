require 'rom-mapper'
require 'pp'

input = {
  itinerary_info: {
    itinerary_pricing: {},
    reservation_items: {
      item: [
        {
          :flight_segment => {
            :destination_location => { :@location_code => 'BKK' },
            :equipment => { :@air_equip_type => '343' },
            :marketing_airline => { :@code => 'LX', :@flight_number => '0180' },
            :meal => [{ :@code => 'M' }, { :@code => 'B' }],
            :origin_location => { :@location_code => 'ZRH' },
            :supplier_ref => { :@id => 'DCLX*GR6TWQ' },
            :updated_arrival_time => '03-13T10:50',
            :updated_departure_time => '03-12T17:55',
            :@air_miles_flown => '5632',
            :@arrival_date_time => '03-13T10:50',
            :@day_of_week_ind => '6',
            :@departure_date_time => '2016-03-12T17:55',
            :@elapsed_time => '10.55',
            :@e_ticket => 'true',
            :@flight_number => '0180',
            :@number_in_party => '01',
            :@res_book_desig_code => 'C',
            :@segment_number => '0001',
            :@smoking_allowed => 'false',
            :@special_meal => 'true',
            :@status => 'HK',
            :@stop_quantity => '00',
            :@is_past => 'false'
          },
          :@rph => '1'
        },
        {},
        {}
      ]
    }
  }
}

class InputSanitizer < ROM::Mapper
  reject_keys true

  step do
    unwrap :itinerary_info do
      attribute :reservation_items
    end
  end

  step do
    unwrap :reservation_items do
      attribute :items, from: :item
    end
  end

  step do
    ungroup :items do
      attribute :flight_segment
    end
  end
end

class Mapper < ROM::Mapper
  reject_keys true
  step do
    unwrap :flight_segment do
      attribute :origin_location
      attribute :destination_location
      attribute :departure_time, from: :@departure_date_time
      attribute :arrival_time, from: :@arrival_date_time
      attribute :marketing_airline_code, from: :@code
      attribute :marketing_flight_number, from: :@flight_number
      attribute :flight_duration_minutes, from: :@elapsed_time
      attribute :miles, from: :@air_miles_flown
      attribute :meal_code, from: :meal
    end
  end

  step do
    unwrap :origin_location do
      attribute :origin_code, from: :@location_code
    end
    unwrap :destination_location do
      attribute :destination_code, from: :@location_code
    end
    attribute :departure_time
    attribute :arrival_time
    attribute :marketing_airline_code
    attribute :marketing_flight_number
    attribute :flight_duration_minute
    attribute :miles
    attribute :meal_code
  end
end

val = InputSanitizer.build.call([input])
pp val

pp Mapper.build.call(val)
