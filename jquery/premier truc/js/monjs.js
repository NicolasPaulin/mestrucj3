$("ol > li")
$("li#premier ~ li")
$("p:first")
$("p:eq(1)")
$("p:last")
$("ul:gt(0)")
$("li:lt(1)")
$("li:not('.legume')")
//:hidden :visible :contains("texte") :has("élément") [attribut] [attribut="valeur"]
//:input :password :text :checkbox :radio :submit <-- pour les formulaires

//les méthodes : https://openclassrooms.com/courses/introduction-a-jquery-4/utilisez-des-methodes-jquery

$('li').on( 'click', function () {
    alert("Les tomates ne sont pas des légumes! enfin si un peu... mais c'est surtout des fruits !")
});

var $p = $('p');
$p.on('click', function(event) {
  var date = new Date(event.timeStamp);
  alert("Quelqu'un a cliqué sur un paragraphe le" + date)
    $p.text("You clicked on: " + date)
});
