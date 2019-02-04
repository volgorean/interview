RSpec.describe Location do
  let(:dc) { FactoryGirl.build :location, :as_dc }
  subject(:address) { described_class.new }

  describe 'self.from_address' do
    let(:payload) {{ 'longt' => dc.lng, 'latt' => dc.lat }}
    let(:result) { [ double(data: payload) ] }

    it 'geocodes with Geocoder API' do
      expect(Geocoder).to receive(:coordinates).with(dc.full_address).and_return result
      Location.from_address(dc.full_address)
    end

    it 'is geocoded' do
      location = Location.from_address(dc.full_address)
      expect(location).to have_attributes(lat: dc.lat, lng: dc.lng)
    end
  end

  describe 'self.from_coordinates' do
    let :payload do
      {   
        'usa'=> {
          'uscity' => 'WASHINGTON',
          'usstnumber' => '1',
          'state' => 'PA',
          'zip' => '20500',
          'usstaddress' => 'Pennsylvania AVE'
        }
      }
    end
    
    let(:result) { [ double(data: payload) ] }

    it 'reverse geocodes with Geocoder API' do
      expect(Geocoder).to receive(:address).with([dc.lat, dc.lng]).and_return result
      Location.from_coordinates(dc.lat, dc.lng)
    end

    it 'is reverse geocoded' do
      location = Location.from_coordinates(dc.lat, dc.lng)
      expect(location).to have_attributes(full_address: dc.full_address)
    end
  end

  describe 'get_distance' do
    let(:detroit) { FactoryGirl.build :location, :as_detroit }
    let(:kansas_city) { FactoryGirl.build :location, :as_kansas_city }

    it 'calculates distance with the Geocoder API' do
      expect(Geocoder::Calculations).to receive(:distance_between).with [detroit.lat, detroit.lng], [kansas_city.lat, kansas_city.lng]
      detroit.get_distance(kansas_city)
    end

    it 'returns the distance between two addresses' do
      expect(detroit.get_distance(kansas_city)).to be_between(640, 650)
    end
  end
end