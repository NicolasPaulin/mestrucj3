<<?php

class DBFactory
{
  public static function load($sgbdr)
  {
    $classe = 'SGBDR_' . $sgbdr;

    if (file_exists($chemin = $classe . '.class.php'))
    {
      require $chemin;
      return new $classe;
    }
    else
    {
      throw new RuntimeException('La classe <strong>' . $classe . '</strong> n\'a pu être trouvée !');
    }
  }
}

try
{
  $mysql = DBFactory::load('MySQL');
}
catch (RuntimeException $e)
{
  echo $e->getMessage();
}

class Observee implements SplSubject
{
  // Ceci est le tableau qui va contenir tous les objets qui nous observent.
  protected $observers = [];

  // Dès que cet attribut changera on notifiera les classes observatrices.
  protected $nom;

  public function attach(SplObserver $observer)
  {
    $this->observers[] = $observer;
  }

  public function detach(SplObserver $observer)
  {
    if (is_int($key = array_search($observer, $this->observers, true)))
    {
      unset($this->observers[$key]);
    }
  }

  public function notify()
  {
    foreach ($this->observers as $observer)
    {
      $observer->update($this);
    }
  }

  public function getNom()
  {
    return $this->nom;
  }

  public function setNom($nom)
  {
    $this->nom = $nom;
    $this->notify();
  }
}

class MonSingleton
{
  protected static $instance; // Contiendra l'instance de notre classe.

  protected function __construct() { } // Constructeur en privé.
  protected function __clone() { } // Méthode de clonage en privé aussi.

  public static function getInstance()
  {
    if (!isset(self::$instance)) // Si on n'a pas encore instancié notre classe.
    {
      self::$instance = new self; // On s'instancie nous-mêmes. :)
    }

    return self::$instance;
  }
}
