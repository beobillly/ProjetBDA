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

    4/ Fonctionnement normal d'un projet avec limite de temps:
       Un utilisateur créé un projet, il a quelques dons puis le projet tombe dans l'oubli.
       Le projet est supprimé quand le temps limite est dépassé.
    
    5/ Fonctionnement normal d'un projet plusieurs donateurs:
       Un utilisateur fait des dons à un projet, son rang augmente, le temps passe, son rang diminue, il fait des dons conséquents à 3 projets et son rang augmente beaucoup.

    6/ Fonctionnement normal d'un projet avec petites restrictions:
       Un utilisateur créé un compte puis tente d'en créer un deuxieme avec la meme adresse mail, il constate qu'il ne peut pas puis se supprime son premier compte.
    
    7/ Fonctionnement normal d'un projet avec petites restrictions:
       Un utilisateur de moins de 18 ans tente de s'inscrire, cela ne marche pas, fin.

    8-9/ Un utilisateur tente de créer un projet avec un solde(montant_base ou monatant max) negatif, cela ne marche pas.

    10/ un utlisateur tente de creer un projet et tente un don plus haut      que le max du projet autorisé

    11/ un utlisateur tente de faire un don negatif

    12/ un utlisateur tente de creer un projet avec la date de limite         inférieur à la date courante

    13/ un administrateur veut obtenir tous les projets créé en novembre

    14/ un administrateur veut obtenir tous les utilisateurs dernierement connecté en novembre

    15/ un administrateur veut obetnir les 10 meilleurs donnateurs

    16/ un administrateur veut obtenir tous les donnateurs ayant donné plus de 10000€ (tout don confondu)

    17/ un administrateur veut savoir le nombre de fois que les adresses mail contiennent la lettre 'e'

    18/ un administrateur veut obtenir les 10 pires donateurs

    19/ un beneficiaire veut savoir le nombre de batteur qui sont beneficiaires de son projet

    20/ La platforme veut savoir cb elle a gagné depuis le debut

Faire marcher le projet : 

    \i creation_tables.sql
    \i triggers.sql
    \i tests.sql (batterie de tests)

    Executer les tests un par un 