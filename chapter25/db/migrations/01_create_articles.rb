# This is an example.
Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      String :name, :text=>true
      Integer :quantity
    end
  end
end
