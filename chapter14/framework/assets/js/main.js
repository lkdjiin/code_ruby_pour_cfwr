function validateNewPost() {
  var title = document.getElementById("title");
  var content = document.getElementById("content");

  if(title.value === "" || content.value === "") {
    alert("Veuillez remplir le formulaire");
    return false;
  } else {
    return true;
  }
}
