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