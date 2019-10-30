class Artist
  attr_reader :id, :name, :born, :died, :country
  
  def initialize(artist_attributes)
    @id = artist_attributes[:id]
    @name = artist_attributes[:name]
    @born = artist_attributes[:born]
    @died = artist_attributes[:died]
    @country = artist_attributes[:country]
  end
end
