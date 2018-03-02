class Collection < Sequel::Model
  one_to_many :gifs
  many_to_one :user
end
