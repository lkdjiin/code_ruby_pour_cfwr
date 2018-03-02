class Gif < Sequel::Model
  many_to_one :collection

  dataset_module do
    def random(collection_id:)
      RandomGif.new(collection_id: collection_id).get
    end
  end
end
