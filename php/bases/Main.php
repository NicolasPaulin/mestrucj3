<?php
function chargerClasse($classe)
{
  require $classe . '.php'; // On inclut la classe correspondante au paramètre passé.
}
spl_autoload_register('chargerClasse'); // On enregistre la fonction en autoload pour qu'elle soit appelée dès qu'on instanciera une classe non déclarée.

$personnage = new Personnage([
  'id' => 1,
  'nom' => 'Victor',
  'forcePerso' => 5,
  'degats' => 0,
  'niveau' => 1,
  'experience' => 0
]);

$personnage2 = new Personnage([
  'id' => 2,
  'nom' => 'Jacky',
  'forcePerso' => 50,
  'degats' => 50,
  'niveau' => 10,
  'experience' => 50
]);

$db = new PDO('mysql:host=localhost:8889;dbname=test', 'root', 'root');


$manager = new PersonnagesManager($db);

$manager->add($personnage);
$manager->add($personnage2);

echo 'insertion réussis <br/>';

$request = $db->query('SELECT id, nom, forcePerso, degats, niveau, experience FROM personnages');

echo 'requete non planté <br/>';

while ($donnees = $request->fetch(PDO::FETCH_ASSOC)) // Chaque entrée sera récupérée et placée dans un array.
{
  echo 'on rentre dans le while';

  // On passe les données (stockées dans un tableau) concernant le personnage au constructeur de la classe.
  // On admet que le constructeur de la classe appelle chaque setter pour assigner les valeurs qu'on lui a données aux attributs correspondants.
  $perso = new Personnage($donnees);

  echo $perso->nom(), ' a ', $perso->forcePerso(), ' de force, ', $perso->degats(), ' de dégâts, ', $perso->experience(), ' d\'expérience et est au niveau ', $perso->niveau();
}
echo 'fin';

?>
