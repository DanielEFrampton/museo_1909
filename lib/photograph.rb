class Photograph
  attr_reader :id, :name, :artist_id, :year
  
  def initialize(photo_info)
    @id = photo_info[:id]
    @name = photo_info[:name]
    @artist_id = photo_info[:artist_id]
    @year = photo_info[:year]
  end
end
