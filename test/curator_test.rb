require 'minitest/autorun'
require 'minitest/pride'
require './lib/photograph'
require './lib/artist'
require './lib/curator'
require 'csv'

class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new
    @photo_1 = Photograph.new({
                                 id: "1",
                                 name: "Rue Mouffetard, Paris (Boy with Bottles)",
                                 artist_id: "1",
                                 year: "1954"
                              })
    @photo_2 = Photograph.new({
                                 id: "2",
                                 name: "Moonrise, Hernandez",
                                 artist_id: "2",
                                 year: "1941"
                              })
    @photo_3 = Photograph.new({
         id: "3",
         name: "Identical Twins, Roselle, New Jersey",
         artist_id: "3",
         year: "1967"
    })
    @photo_4 = Photograph.new({
         id: "4",
         name: "Monolith, The Face of Half Dome",
         artist_id: "3",
         year: "1927"
    })
    @photo_5 = Photograph.new ({
      id: "4",
      name: "Child with Toy Hand Grenade in Central Park",
      artist_id: "3",
      year: "1962"
      })
    @artist_1 = Artist.new({
        id: "1",
        name: "Henri Cartier-Bresson",
        born: "1908",
        died: "2004",
        country: "France"
    })
    @artist_2 = Artist.new({
        id: "2",
        name: "Ansel Adams",
        born: "1902",
        died: "1984",
        country: "United States"
    })
    @artist_3 = Artist.new({
         id: "3",
         name: "Diane Arbus",
         born: "1923",
         died: "1971",
         country: "United States"
    })
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_initializes_with_attributes
    assert_equal [], @curator.photographs
    assert_equal [], @curator.artists
  end

  def test_it_can_add_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    assert_equal [@photo_1, @photo_2], @curator.photographs
  end

  def test_it_can_add_artist
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
  end

  def test_it_can_find_artist_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    assert_equal @artist_1, @curator.find_artist_by_id("1")
  end

  def test_it_can_find_photograph_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    assert_equal @photo_2, @curator.find_photograph_by_id("2")
  end

  def test_it_can_find_photographs_by_artist
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    assert_equal [@photo_3, @photo_4], @curator.find_photographs_by_artist(@artist_3)
  end

  def test_it_can_find_artists_with_multiple_photographs
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    assert_equal [@artist_3], @curator.artists_with_multiple_photographs
  end

  def test_it_can_find_all_artists_from_given_country
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    assert_equal [@artist_2, @artist_3], @curator.artists_from_country("United States")
    assert_equal [@artist_1], @curator.artists_from_country("France")
  end

  def test_it_can_find_photographs_taken_by_artists_from_given_country
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    assert_equal [@photo_2, @photo_3, @photo_4], @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_it_can_load_photographs_from_file
    @curator.load_photographs('./data/photographs.csv')
    assert_equal "1", @curator.photographs[0].id
    assert_equal "2", @curator.photographs[1].id
    assert_equal "3", @curator.photographs[2].id
    assert_equal "4", @curator.photographs[3].id
  end

  def test_it_can_load_artists_from_file
    @curator.load_artists('./data/artists.csv')
    assert_equal "Henri Cartier-Bresson", @curator.find_artist_by_id("1").name
    assert_equal "Ansel Adams", @curator.find_artist_by_id("2").name
    assert_equal "Diane Arbus", @curator.find_artist_by_id("3").name
    assert_equal "Walker Evans", @curator.find_artist_by_id("4").name
    assert_equal "Manuel Alvarez Bravo", @curator.find_artist_by_id("5").name
    assert_equal "Bill Cunningham", @curator.find_artist_by_id("6").name
  end

  def test_it_can_find_photographs_taken_between_two_years
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')
    assert_equal "Rue Mouffetard, Paris (Boy with Bottles)", @curator.photographs_taken_between(1950..1965)[0].name
    assert_equal "Child with Toy Hand Grenade in Central Park", @curator.photographs_taken_between(1950..1965)[1].name
  end
end
