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

Faire marcher le projet : 

    \i creation_tables.sql
    \i triggers.sql
    \i tests.sql (batterie de tests)

Le fichier rapport contient : 

    _ Un rapport étendant celui de la présoutenance. Il contient la description sql de notre schéma dans la base, et des considérations générales sur le développement.
    – Une liste commentée des fonctions, des triggers, des règles de gestion ;
    – La liste et la nature des index qui seront éventuellement ajoutés ainsi qu’une jus-tification des bénéfices attendus ;
    – Une liste des tests réalisés ainsi qu'une explication sur leur but.