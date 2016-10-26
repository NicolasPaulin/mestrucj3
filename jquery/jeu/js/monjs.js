var $carre = $('#carre');
$carre.on('click', function() {
  $carre.width($carre.width()*0.95+'px');
  $carre.height($carre.height()*0.95+'px');
  // $carre.css('background-color,rgb(' +
  //                 (Math.floor(Math.random() * 256)) +','+
  //                 (Math.floor(Math.random() * 256)) +','+
  //                 (Math.floor(Math.random() * 256)) +')');
  $carre.offset({left : + (Math.floor(Math.random() * $( window ).width()-$carre.width()/2))
    ,top : + (Math.floor(Math.random() * $( window ).height()-$carre.width()/2))});
});
