<?php
trait MonTrait
{
  public function speak()
  {
    echo 'Je suis un trait !';
  }
}

class Mere
{
  public function speak()
  {
    echo 'Je suis une classe mère !';
  }
}

class Fille extends Mere
{
  use MonTrait;
}

$fille = new Fille;
$fille->speak(); // Affiche « Je suis un trait ! »

trait A
{
  public function saySomething()
  {
    echo 'Je suis le trait A !';
  }
}

class MaClasse
{
  use A
  {
    saySomething as sayWhoYouAre;
  }
}

$o = new MaClasse;
$o->sayWhoYouAre(); // Affichera « Je suis le trait A ! »
$o->saySomething(); // Affichera « Je suis le trait A ! »


?>
