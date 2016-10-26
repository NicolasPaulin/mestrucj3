<?php
abstract class Personnage
{
  abstract public function frapper(Personnage $perso);
  public function recevoirDegats()
  {
  }
}

class Magicien
{
  private $_magie; // Indique la puissance du magicien sur 100, sa capacité à produire de la magie.
  public function lancerUnSort($perso)
  {
    $perso->recevoirDegats($this->_magie); // On va dire que la magie du magicien représente sa force.
  }
  public function gagnerExperience()
  {
    // On appelle la méthode gagnerExperience() de la classe parente
    parent::gagnerExperience();
    if ($this->_magie < 100)
    {
      $this->_magie += 10;
    }
  }
}

$classeMagicien = new ReflectionClass('Magicien'); // Le nom de la classe doit être entre apostrophes ou guillemets.
$magicien = new Magicien(['nom' => 'vyk12', 'type' => 'magicien']);
$classeMagicien = new ReflectionObject($magicien);

$classePersonnage = new ReflectionClass('Personnage');

if ($classeMagicien->hasProperty('magie'))
{
  echo 'La classe Magicien possède un attribut $magie';
}
else
{
  echo 'La classe Magicien ne possède pas d\'attribut $magie';
}

if ($classeMagicien->hasMethod('lancerUnSort'))
{
  echo 'La classe Magicien implémente une méthode lancerUnSort()';
}
else
{
  echo 'La classe Magicien n\'implémente pas de méthode lancerUnSort()';
}

if ($classePersonnage->hasConstant('NOUVEAU'))
{
  echo 'La classe Personnage possède une constante NOUVEAU';
}
else
{
  echo 'La classe Personnage ne possède pas de constante NOUVEAU';
}

echo '<pre>', print_r($classePersonnage->getConstants(), true), '</pre>';
//affiche la liste des constantes

if ($parent = $classeMagicien->getParentClass())
{
  echo 'La classe Magicien a un parent : il s\'agit de la classe ', $parent->getName();
}
else
{
  echo 'La classe Magicien n\'a pas de parent';
}

if ($classeMagicien->isSubclassOf('Personnage'))
{
  echo 'La classe Magicien a pour parent la classe Personnage';
}
else
{
  echo 'La classe Magicien n\'a la classe Personnage pour parent';
}

if ($classePersonnage->isAbstract())
{
  echo 'La classe Personnage est abstraite';
}
else
{
  echo 'La classe Personnage n\'est pas abstraite';
}

// Est-elle finale ?
if ($classePersonnage->isFinal())
{
  echo 'La classe Personnage est finale';
}
else
{
  echo 'La classe Personnage n\'est pas finale';
}

if ($classePersonnage->isInstantiable())
{
  echo 'La classe Personnage est instanciable';
}
else
{
  echo 'La classe personnage n\'est pas instanciable';
}
//a peu pret toutes les propriétés et attribus d'une classes sont verifiables

class A
{
  public function hello($arg1, $arg2, $arg3 = 1, $arg4 = 'Hello world !')
  {
    echo 'Hello world !';
  }
}

$methode = new ReflectionMethod('A', 'hello');
//est équivalent à
$classeA = new ReflectionClass('A');
$methode = $classeA->getMethod('hello');

if ($methode->isPublic())
{
  echo 'publique';
}
elseif ($methode->isProtected())
{
  echo 'protégée';
}
else
{
  echo 'privée';
}

if ($methode->isStatic())
{
  echo ' (en plus elle est statique)';
}
?>
