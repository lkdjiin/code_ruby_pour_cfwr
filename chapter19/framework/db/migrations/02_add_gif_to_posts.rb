Sequel.migration do
  change do
    add_column :posts, :gif, String, :text=>true
  end
end
