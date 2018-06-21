function deleteGif(id) {
  setFeedback("");
  softDelete(id);
  hardDelete(id);
}

function setFeedback(message) {
  document.getElementById("js-feedback").innerHTML = message;
}

function softDelete(id) {
  document.getElementById("js-gif-id-" + id).remove();
}

function hardDelete(id) {
  let xmlhttp = new XMLHttpRequest();

  xmlhttp.onreadystatechange = function() {
    if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
      setFeedback("Gif " + id + " deleted");
    } else if(xmlhttp.readyState == 4 && xmlhttp.status != 200) {
      setFeedback("Something went wrong. Gif isn't deleted");
    }
  };

  let url = "/gifs/delete?format=json&id=" + id;
  xmlhttp.open("GET", url, true);
  xmlhttp.send();
}

function newGif(id) {
  setFeedback("Looking for a new gif…");
  displayPlaceholder();
  getGif(id);
}

function displayPlaceholder() {
  let template = document.getElementById("placeholder-template");
  let clone = document.importNode(template.content, true);
  let gifsNode = document.getElementById("js-gifs");
  gifsNode.prepend(clone);
}

function getGif(id) {
  let xmlhttp = new XMLHttpRequest();

  xmlhttp.onreadystatechange = function() {
    if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {
      displayNewGif(JSON.parse(xmlhttp.responseText));
    } else if(xmlhttp.readyState == 4 && xmlhttp.status != 200) {
      gifError(JSON.parse(xmlhttp.responseText));
    }
  };

  let url = "/gifs/new?format=json&wall_id=" + id;
  xmlhttp.open("GET", url, true);
  xmlhttp.send();
}

function displayNewGif(data) {
  let template = document.getElementById("gif-template");
  let root = template.content.querySelector(".gif");
  root.id = "js-gif-id-" + data.id;
  let image = new Image();
  image.setAttribute("height", "200");
  let a = template.content.querySelector("a");
  a.setAttribute("onclick", "deleteGif("+ data.id + ");return false;");
  a.href = "/gifs/delete?id=" + data.id + "&wall_id=" + data.wall_id;

  image.onload = function() {
    createGif(root.id, template, image);
    removeFirstPlaceholder();
    setFeedback("Enjoy your new gif!");
  };

  image.src = data.url;
}

function createGif(id, template, gif) {
  let clone = document.importNode(template.content, true);
  let gifsNode = document.getElementById("js-gifs");
  gifsNode.prepend(clone);
  let divNode = document.getElementById(id).querySelector(".gif-image");
  divNode.prepend(gif);
}

function gifError(data) {
  removeFirstPlaceholder();
  setFeedback(data.meta.message);
}

function removeFirstPlaceholder() {
  let placeholder =
    document.getElementById('js-gifs').getElementsByClassName('placeholder')[0]
  placeholder.remove();
}
