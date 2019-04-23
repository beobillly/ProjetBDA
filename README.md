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

    Rajouter des triggers :

        -sur les dons
        -sur la fiabilité
        -sur les niveaux
        -sur la date de derniere connexion de lutilisateur
        -sur la date du dernier don
        -...


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
    