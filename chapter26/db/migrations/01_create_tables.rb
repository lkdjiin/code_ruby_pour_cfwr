Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :name
    end

    create_table(:collections) do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade
      String :name
      String :tags
    end

    create_table(:gifs) do
      primary_key :id
      foreign_key :collection_id, :collections, on_delete: :cascade
      String :url
    end
  end
end
