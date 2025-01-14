class Curator
  attr_reader :photographs, :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(artist_id)
    @artists.find { |artist| artist.id == artist_id }
  end

  def find_photograph_by_id(photo_id)
    @photographs.find { |photo| photo.id == photo_id }
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all { |photo| photo.artist_id == artist.id }
  end

  def artists_with_multiple_photographs
    @artists.find_all { |artist| find_photographs_by_artist(artist).length > 1 }
  end

  def artists_from_country(country)
    @artists.find_all { |artist| artist.country == country }
  end

  def photographs_taken_by_artist_from(country)
    artists_from_country(country).flat_map do |artist|
      find_photographs_by_artist(artist)
    end
  end

  def load_photographs(csv_path)
    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
      @photographs << Photograph.new(row)
    end
  end

  def load_artists(csv_path)
    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
      @artists << Artist.new(row)
    end
  end

  def photographs_taken_between(year_range)
    @photographs.find_all { |photo| year_range.include?(photo.year.to_i) }
  end

  def artists_photographs_by_age(artist)
    find_photographs_by_artist(artist).reduce({}) do |hash, photo|
      hash.merge({(photo.year.to_i - artist.born.to_i) => photo.name})
    end
  end
end
