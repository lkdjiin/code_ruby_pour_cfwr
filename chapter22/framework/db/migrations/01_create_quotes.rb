Sequel.migration do
  change do
    create_table(:quotes) do
      primary_key :id
      String :character, :text=>true
      String :quote, :text=>true
      Integer :likes
      Integer :dislikes
    end
  end
end
