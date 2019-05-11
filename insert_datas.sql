--Insertion dans les tables

SELECT newUtilisateurs('Chose':: VARCHAR, 'Jean' :: VARCHAR, 32, '26 rue de Patrak':: VARCHAR,'beneficiares':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Darc':: VARCHAR, 'Jeanne' :: VARCHAR, 18, '78 place vendome':: VARCHAR,'herb@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);

SELECT newUtilisateurs('Gregory':: VARCHAR, 'George' :: VARCHAR, 25, '88 rue du Paket':: VARCHAR,'ge@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Juan':: VARCHAR, 'Etienne' :: VARCHAR, 42, '4 rue des Lyonnais':: VARCHAR,'etiju@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Jonck':: VARCHAR, 'Emilie' :: VARCHAR, 27, '2 rue du plankton':: VARCHAR,'milyjonck@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'Jacques':: VARCHAR,29, '36 rue du sae':: VARCHAR,'jako@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Morel' :: VARCHAR,'Francis':: VARCHAR, 56, '56 rue du plankton':: VARCHAR,'framo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Coltrane' :: VARCHAR,'John':: VARCHAR,56, '5 downtown street':: VARCHAR,'jc@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'blu@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'k@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jjo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'j0jo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'koku@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jiji@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisasdasdous' :: VARCHAR,'dsde':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kilo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jfasd' :: VARCHAR,'cocaso':: VARCHAR,56, '70 rue du plankton':: VARCHAR,'jo@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'codco':: VARCHAR,78, '2 rue du plankton':: VARCHAR,'jiko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kula@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajou@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'j0j9@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kudla@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jajouju@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kokiku@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'kokoko@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisasdasdous' :: VARCHAR,'dsde':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kiloka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jfasd' :: VARCHAR,'cocaso':: VARCHAR,56, '70 rue du plankton':: VARCHAR,'joka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'codco':: VARCHAR,78, '2 rue du plankton':: VARCHAR,'jikoka@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'bludabedibaduba@gmail.com':: VARCHAR,1, FALSE, CURRENT_TIMESTAMP :: DATE);
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,25, '2 rue du sae':: VARCHAR,'kikiki@gmail.com':: VARCHAR,1, FALSE, TO_DATE('2018/07/09', 'yyyy/mm/dd') :: DATE);
SELECT newUtilisateurs('jf' :: VARCHAR,'coco':: VARCHAR,56, '2 rue du plankton':: VARCHAR,'jaaaajo@gmail.com':: VARCHAR,1, FALSE, TO_DATE('2018/11/09', 'yyyy/mm/dd') :: DATE);	
SELECT newUtilisateurs('Bisous' :: VARCHAR,'e':: VARCHAR,32, '2 rue du sae':: VARCHAR,'bludabediba@gmail.com':: VARCHAR,1, FALSE, TO_DATE('2018/11/09', 'yyyy/mm/dd') :: DATE);


DO $$
DECLARE 
   i INTEGER := 0; 
BEGIN
i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'etiju@gmail.com');
	PERFORM InitierProjet(i, 'ma tournée internationale', 8000, 10000, 'Projet de tournée internationale pour mon groupe', TO_DATE('2020/07/09', 'yyyy/mm/dd') :: DATE);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'joka@gmail.com'), (SELECT MAX(id_projet) from projets), 2000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'herb@gmail.com'), (SELECT MAX(id_projet) from projets), 2000);
	PERFORM don ((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'milyjonck@gmail.com'), (SELECT MAX(id_projet) from projets), 3000);
	PERFORM newBeneficiaire((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'jc@gmail.com'),  (SELECT MAX(id_projet) from projets), 3);
	PERFORM newBeneficiaire((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'herb@gmail.com'),  (SELECT MAX(id_projet) from projets), 3);


i = (SELECT id_utilisateur FROM utilisateurs WHERE utilisateurs.mail = 'milyjonck@gmail.com');
	PERFORM InitierProjet(i, 'mon disque', 3000, 10000, 'Mon disque', TO_DATE('2021/05/09', 'yyyy/mm/dd') :: DATE);
	PERFORM newBeneficiaire((SELECT id_utilisateur FROM utilisateurs WHERE mail = 'etiju@gmail.com'),  (SELECT MAX(id_projet) from projets), 3);
END; 
$$