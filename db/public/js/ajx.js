function loadDoc() {
    var xhttp = newXMLHttpRequest();
    xhttp.onreadystatechange= function() {
    if (this.readyState == 4 && this.status == 200) {
    document.getElementsByClassName("info").innerHTML = this.responseText;
    }
    };
    xhttp.open("GET", "ajax_info.txt", true);
    xhttp.send();
  }