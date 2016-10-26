<?php
class A
{
  public function test()
  {
    return 'test';
  }
}

class B extends A
{
  public function test()
  {
    $retour = parent::test();

    echo $retour;
  }
}

$b = new B;
$b->test(); // Affiche "test"

class ClasseMere
{
  protected $attributProtege;
  private $_attributPrive;

  public function __construct()
  {
    $this->attributProtege = 'Hello world !';
    $this->_attributPrive = 'Bonjour tout le monde !';
  }
}

class ClasseFille extends ClasseMere
{
  public function afficherAttributs()
  {
    echo $this->attributProtege; // L'attribut est protégé, on a donc accès à celui-ci.
    echo $this->_attributPrive; // L'attribut est privé, on n'a pas accès celui-ci, donc rien ne s'affichera (mis à part une notice si vous les avez activées).
  }
}

$obj = new ClasseFille;

echo $obj->attributProtege; // Erreur fatale.
echo $obj->_attributPrive; // Rien ne s'affiche (ou une notice si vous les avez activées).

$obj->afficherAttributs(); // Affiche « Hello world ! » suivi de rien du tout ou d'une notice si vous les avez activées.

class Mere
{
  public function lancerLeTest()
  {
    static::quiEstCe();
  }

  public function quiEstCe()
  {
    echo 'Je suis la classe « Mere » !';
  }
}

class Enfant extends Mere
{
  public function quiEstCe()
  {
    echo 'Je suis la classe « Enfant » !';
  }
}

$e = new Enfant;
$e->lancerLeTest();

?>
