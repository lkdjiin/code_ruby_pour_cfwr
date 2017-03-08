# ---
cp -r chapter07 chapter08
cd chapter08
rm -rf db/database.sqlite
rm controllers/articles_controller.rb 
rm models/article.rb
rm -rf views/articles/
mkdir views/posts

# ---
curl -is 'http://localhost:9292/posts/delete?id=5'
