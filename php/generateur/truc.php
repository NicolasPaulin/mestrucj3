<<?php
function generator()
{
  for ($i = 0; $i < 10; $i++)
  {
    yield 'Itération n°'.$i;
  }
}

foreach (generator() as $key => $val)
{
  echo $key, ' => ', $val, '<br />';
}

function generator()
{
  // On retourne ici des chaines de caractères assignées à des clés
  yield 'a' => 'Itération 1';
  yield 'b' => 'Itération 2';
  yield 'c' => 'Itération 3';
  yield 'd' => 'Itération 4';
}

class SomeClass
{
  protected $attr;

  public function __construct()
  {
    $this->attr = ['Un', 'Deux', 'Trois', 'Quatre'];
  }

  // Le & avant le nom du générateur indique que les valeurs retournées sont des références
  public function &generator()
  {
    // On cherche ici à obtenir les références des valeurs du tableau pour les retourner
    foreach ($this->attr as &$val)
    {
      yield $val;
    }
  }

  public function attr()
  {
    return $this->attr;
  }
}

$obj = new SomeClass;

// On parcourt notre générateur en récupérant les entrées par référence
foreach ($obj->generator() as &$val)
{
  // On effectue une opération quelconque sur notre valeur
  $val = strrev($val);
}

echo '<pre>';
var_dump($obj->attr());
echo '</pre>';

?>
