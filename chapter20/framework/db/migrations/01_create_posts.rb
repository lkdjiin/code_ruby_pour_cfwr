Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      String :title, :text=>true
      String :content, :text=>true
      DateTime :date
    end
  end
end
