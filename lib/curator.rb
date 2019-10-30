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
    @artists.find do |artist|
      artist.id == artist_id
    end
  end

  def find_photograph_by_id(photo_id)
    @photographs.find do |photo|
      photo.id == photo_id
    end
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all do |photo|
      photo.artist_id == artist.id
    end
  end

  def artists_with_multiple_photographs
    @artists.find_all do |artist|
      find_photographs_by_artist(artist).length > 1
    end
  end

  def artists_from_country(country)
    @artists.find_all do |artist|
      artist.country == country
    end
  end

  def photographs_taken_by_artist_from(country)
    artists_from_country(country).collect_concat do |artist|
      find_photographs_by_artist(artist)
    end
  end

  def load_photographs(csv_path)
    csv_file = File.open(csv_path)
    csv_file.readlines.each_with_index do |line, index|
        next if index == 0
        split_line = line.split(',')
        @photographs << Photograph.new({
             id: split_line[0],
             name: split_line[1],
             artist_id: split_line[2],
             year: split_line[3]
          })
    end
    csv_file.close
  end

  def load_artists(csv_path)
    csv_file = File.open(csv_path)
    csv_file.readlines.each_with_index do |line, index|
        next if index == 0
        split_line = line.split(',')
        @artists << Artist.new({
             id: split_line[0],
             name: split_line[1],
             born: split_line[2],
             died: split_line[3],
             country: split_line[4]
          })
    end
    csv_file.close
  end
end
