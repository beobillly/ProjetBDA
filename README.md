Tips : 
    ouvrir deux terminaux : un pour le ssh et un pour le scp

    Se connecter à nivose : 

        ssh login@nivose.informatique.univ-paris-diderot.fr

    se connecter à psql :

        psql base
        --taper mdp


    Executer un script depuis psql :
        \i script.sql


    Transfert de scripts :

        scp *.sql login@nivose.informatique.univ-paris-diderot.fr:~

    En local :

        sudo service postresql start
        psql postgres


    SQL : 

        Concatenation = 'toto' :: VARCHAR, TIMESTAMP :: DATE
        ne pas oublier le DROP CASCADE avant la creation d'une fonction 


A Faire :

    Rajouter des fonctions :

        -pour gerer les droits des utilisateurs
        -pour ajouter des projets + initateurs + donateurs + beneficiaires
        -pour faire toute opération utile, ex : consulter tous les logs d'insertion, modifier le niveau d'un utilisateur
        -pour faire les tests

    Remplir les tables (en utilisant des fonctions créées au préalable)

    Faire pleins de tests :
        -pour gerer les opérations interdites
        -pour creer plusieurs projets, gerer leur developpement ainsi que leur achevement
        -pour tester les fonctions
        -pour gerer un maximum de cas possibles

    Rajouter des index secondaires
    
    Gerer la fiabilité
    Gerer les niveaux 

Tests :
    1/ Fonctionnement normal d'un projet : 
       Un utilisateur créé un projet, d'autres utilisateurs font des dons, le montant de base est dépassé et l'utilisateur met fin au projet
    
    2/ Fonctionnement normal d'un projet avec petites restrictions:
       Un utilisateur créé un projet, il a quelques dons puis décide de créer un autre projet avant que son premier projet soit fini.
       Il constate qu'il ne peut pas et attend que son premier projet se termine puis fini par créer son deuxieme projet.
    
    3/ Fonctionnement normal d'un projet avec petites restrictions bis:
       Un utilisateur créé un projet, il a quelques dons puis décide de créer un autre projet avant que son premier projet soit fini.
       Il constate qu'il ne peut pas et n'attend pas que son premier projet se termine. Il force la suppression de son premier projet puis créé son 
       deuxieme projet.

     
    