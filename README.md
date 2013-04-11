CAPGEMINI_KEYNECTIS_Integration
===============================

Intégration du kit de développement KWebSign 2013


 
Sommaire
INTRODUCTION  3
GUIDE DE LECTURE DU DOCUMENT :	3
ETAPES DE LA SIGNATURE NUMERIQUE PAR K WEBSIGN	3
SCHEMA GLOBAL DE L’ARCHITECTURE DE COMMUNICATION DU KIT DE DEVELOPPEMENT KWEBSIGN	5
TABLEAU RECAPITULATIF DES VARIABLES UTILISEES	6
INFORMATIONS SUR LE REQUESTTRANSID	7
INFORMATIONS SUR LE RESPONSETRANSID	7
INFORMATIONS SUR LE TAG	8
DATA_METIER	8
CUF_ORG	9
AUTH	9
TYPE	10
VISU	14
WITHDRAWAL_PERIOD	14
PDF_FLATTENING	15
METHODE D’APPEL KWEBSIGN	16
SIMULATION ET LOGS RESULTANTS	18


 
INTRODUCTION
Les descriptions du fonctionnement de l’API KEYNECTIS faites dans la suite de ce document sont à contextualiser par rapport à une approche web, c’est-à-dire que l’utilisateur du service est un internaute et le client mettant à disposition ce service est une société désirant faire signer des documents à ses propres clients.
Par recontextualisation par rapport à notre sujet qui se trouve être une approche mobile, et en particulier une utilisation sur tablette, et en accord avec les scénarios de cas d’utilisations fait de notre logiciel AUTOSIGN, l’utilisateur se trouvera devant sa tablette et, la plupart du temps, n’aura d’actions à effectuer que son authentification, la sélection et la validation des documents qu’il désire signer, documents préalablement préparés par la société métier. Ces derniers seront par la suite envoyés au serveur de ladite société, dans une requête contenant toutes les informations sur l’opération dont le serveur devra demander l’exécution au portail KEYNECTIS : informations utilisateur, document à signer, type de signature, et informations complémentaires.
Il est donc sous-entendu que les documents sauvegardés en base de données côté serveur seront associés à toutes les informations utiles à la réalisation de la requête au portail, sans aucune autre forme d’intervention extérieure. Les informations qui suivent sont donc à considérer en tenant compte de ces réserves.
GUIDE DE LECTURE DU DOCUMENT :
•	Dans la suite de ce document, les textes surlignés en bleu sont importants à connaître pour implémenter une correspondance réussie avec le portail KWebSign.
•	En jaune sont les interrogations et ambigüité qui persistent à l’instant de la rédaction
•	Le kit de développement K.WebSign qui nous a été fourni utilise le type de signature 38. Par contre notre implémentation quant à elle teste également le type 36. Pour un aperçu rapide des spécificités de ce test, se rendre directement dans le paragraphe TYPE pour y lire ces informations.
LEXIQUE

ETAPES DE LA SIGNATURE NUMERIQUE PAR K.WEBSIGN
L’application métier demande au module TRANSID de créer un blob chiffré et signé, contenant :
•	L’identifiant de l’application métier (8 caractères max) (Les deux premiers caractères sont fournis et imposés par KEYNECTIS). Cette information est obligatoire.
•	L’identifiant du serveur de l’application métier (8 caractères max), par défaut sa valeur est à SERVID, à remplacer par l’identifiant du serveur d’application métier. Cette information est obligatoire.
•	L’identifiant de l’organisme de l’application métier (14 caractères max) par défaut sa valeur est à SPAREID, à remplacer par un identifiant pour l’organisme métier. Cette information est obligatoire ???
•	Le nom de l’utilisateur (sans accent ni apostrophe ni caractères spéciaux) ; Cette information est obligatoire.
•	L’adresse mail de l’utilisateur (sans accent ni apostrophe en respectant le format d’adressage email XX@YY.zz);
•	Le code de contrôle de la présence de l'utilisateur (CUF) ; 
•	L’autorité d’enregistrement émettrice du certificat temporaire (Information fourni par KEYNECTIS), celle-ci correspond généralement au nom du client. Ce champ sera présent dans le certificat de signature à la volée émis pour réaliser la signature client final (internaute) ;
•	L’adresse Url de retour en fin de processus de signature, à modifier comme indiqué lors de l’installation de TransID ;
•	Le document signé par l’application métier et à faire signé par l’utilisateur avec le certificat temporaire (original métier) et son nom de fichier associé ;
•	Des données techniques (Tag) libres et/ou formatées (XSLT : insérées dans un document de configuration fournis en paramètre de la méthode de création de la requête au portail KWebSign).
A partir de ces informations, le module TRANSID génère un objet RequestTransID (RTI), contenant toutes ces informations insérées dans un blob signé et chiffré, ainsi qu’un numéro de transaction. Le RTI est la forme sous laquelle le portail KWebSign reçoit les requêtes de signatures. L’application métier a néanmoins besoin de plusieurs certificats afin de générer ce blob chiffré et signé. Ces certificats sont fournis par KEYNECTIS et propres à l’application métier. Il s’agit :
•	D’un certificat de signature de l’original métier (.p12) et le mot de passe protégeant sa clé privée
•	D’un certificat de chiffrement du blob (.cer) ;
•	D’un certificat de signature du blob (.p12) et le mot de passe protégeant sa clé privée.
Sur le portail (https://keynectis.kwebsign.net/QS/Page1V2), le blob, identifié par le numéro de transaction, est déchiffré et vérifié. Ses signatures sont ensuite validées et il est certifié, signé, horodaté et stocké. Le certificat généré, un accusé de réception est créé et envoyé à l’utilisateur, ainsi que le fichier de preuve (hash en base 64 du blob chiffré signé) et l’original métier signé par KEYNECTIS. Ce blob* (blob contenant les informations à retourner) est ensuite renvoyé au serveur d’application via l’url de retour fourni dans le blob de la requête. C’est sur cet url que le serveur effectuera la réponse à l’internaute.
En réponse, l’application métier demande au module TRANSID de déchiffrer le blob reçu et de lui retourner :
•	Le document original signé par l’application métier et signé par l’internaute (original) sous le nom de fichier choisi lors de la requête ;
•	Le document XML Accusé de réception contenant les informations nécessaires (Statuts, référence, données métier (TAG)) référencé « transnum.xml ».
Pour exploiter le blob de réponse, l’application métier a besoin d’un certificat fourni par KEYNECTIS :
•	Certificat de déchiffrement du blob (.p12) et le mot de passe protégeant sa clé privée.
Le blob de réponse, une fois déchiffré, donne donc accès au fichier métier signé.
 
SCHEMA GLOBAL DE L’ARCHITECTURE DE COMMUNICATION DU KIT DE DEVELOPPEMENT KWEBSIGN




























 
TABLEAU RECAPITULATIF DES PARAMETRES UTILISES
Paramètre	Utilité (I/O)	Obligatoire ?	Remarque	Démo
RequêteTransID	Requête de certification fournie au portail KWebSign	O	Contient toutes les informations nécessaires à la certification côté KEYNECTIS
Le module TRANSID doit être intégré dans l’application métier	RequestTransId 
rti = new RequestTransId(
"ZZDEMAV1",
"DEMO",
"PDFSMS");
Identifiant de l’application métier (APPID)	Fourni au module TRANSID pour créer le blob signé et chiffré	O	8 caractères : les 2 premiers fournis et imposés par KEYNECTIS	ZZDEMAV1
Identifiant du serveur d’application métier (SERVID)		O	8 caractères maximum	DEMO 
Identifiant de l’organisme de l’application métier (SPAREID)		O	14 caractères maximum	PDFSMS 
Nom Utilisateur		O	Sans accent, apostrophe ou caractères spéciaux	rti.setName(prenom + " " + nom);
Email Utilisateur		O		rti.setEmail(email);
Code CUF		N	les caractères acceptés dans le cuf sont lettre minuscule, majuscule, chiffre, ‘& -=+-/*.{[(_\)]}, ;:!?§<>$£μ%éèçàùêûîë, le caractère € est refusé	rti.setCuf(cuf);
String cuf = String.valueOf(1000 + (new java.util.Random()).nextInt(8999));
Autorité d’enregistrement émettrice du certificat temporaire		O	correspond généralement au nom du client. Ce champ sera présent dans
le certificat de signature à la volée émis pour réaliser la signature client final (internaute)	rti.setAuthority(authority);
String authority = "KWS_INTEGRATION_CDS";
Url de retour		O	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+request.getServletPath();	rti.setReturnUrl(returnUrl);
String returnUrl = basePath.substring(0,basePath.lastIndexOf("/")) + "/demo6p4.jsp";
Original métier		O		rti.setFilePath(origMetierSign);
Données techniques (Tag)		???	Cf. Info sur le tag	rti.setTag(tag);
Certificat de signature de l’original métier 	Il permet de signer l’original métier avant qu’il ne soit transformé en blob	O	Certificat propre à l’APPID, donc à l’organisme métier, au format .p12, utilisé avec un mot de passe protégeant sa clé privée.
Il est fourni par KEYNECTIS et sera validé par la suite sur le portail	String origMetierSign = 
com.dictao.keynectis.
quicksign.transid.Util.
signXmlFileDsig(
PDF_FILE_NAME+
".xml",
this.getServletContext().
getRealPath((String)session.
getAttribute("CERT"))+ "/demoqs_s.p12", "DemoQS");
Certificat de chiffrement du blob	Il permet de chiffrer le blob avant de l’envoyer au portail KWebSign	O	Certificat propre à l’APPID, donc à l’organisme métier, au format .cer
Il est fourni par KEYNECTIS et sera validé par la suite sur le portail	rti.setCipherCertFilePath(this.getServletContext().getRealPath((String)session.getAttribute("CERT"))+ "/certQSkeyncryp.cer");
Certificat de signature du blob	Il permet de signer le blob avant de l’envoyer au portail KWebSign	O	Certificat propre à l’APPID, donc à l’organisme métier, au format .p12, utilisé avec un mot de passe protégeant sa clé privée
Il est fourni par KEYNECTIS et sera validé par la suite sur le portail	rti.setSignCertFilePath(this.getServletContext().getRealPath((String)session.getAttribute("CERT"))+ "/demoqs_i.p12", "DemoQS");
TransNUM	Numéro de transaction généré par le module TRANSID et envoyé au portail KebSign	O		transNum = rti.getTransNum();
blob	Blob signé et chiffré généré par le module TRANSID et envoyé au portail KWebSign	O	Il s’agit de l’original métier converti en base 64, signé et certifié avec les certificats fournis par KEYNECTIS à la société métier	blob = rti.getB64Blob();
Image de signature	Pour effectuer des signatures graphiques	N	Image au format GIF, JPEG, … Encodée en base 64
Paramètre dépendant du type de signature : Cf. paragraphe TYPE

ResponseTransID	Récupéré du portail sur l’url de réponse
Contient le hash base 64 du blob signé chiffré, créé sur le portail	O	Le RTI* est créé sur le serveur d’app mais ses informations sont récupérées du portail après que ce dernier les aie envoyées par le biais de l’url de réponse	ResponseTransId rti = new ResponseTransId();
Certificat de déchiffrement réponse	Il permet de déchiffrer le blob récupéré du portail KWebSign	O	Certificat propre à l’APPID, donc à l’organisme métier, au format .p12, utilisé avec un mot de passe protégeant sa clé privée
Il est fourni par KEYNECTIS 	rti.setCipherCertFilePath(this.getServletContext().getRealPath((String)session.getAttribute("CERT"))+ "/demoqs_c.p12", "DemoQS");
INFORMATIONS SUR LE REQUESTTRANSID

INFORMATIONS SUR LE RESPONSETRANSID

 
INFORMATIONS SUR LE TAG
Description	chaine de caractères correspondant à un fichier de propriétés devant contenir des paramètres dont les valeurs associées peuvent utiliser l’ensemble des caractères UTF-8 (en environnement Java uniquement). L’usage de ces différents paramètres impacte la définition de la page présentée à l’internaute
Rôle	permet de passer des informations à la plateforme KWebSign pour générer de façon dynamique la page de protocole de consentement associée à une APPID et depuis la version 2.0 de donner des instructions complémentaires pour créer des signatures au sein des Documents PDF qui lui sont soumis (Signature Embarquée (visualisable et vérifiable par l’internaute).
Paramètres	Utilité	Obligatoire ?	Remarque	Démo
DATA_METIER	permet de renseigner le fichier de preuve du contexte de la transaction, ainsi que l’AR	O	Chaîne de caractères libre (seuls les caractères < et > sont interdits)	tag += "DATA_METIER=contrat\n";
CUF_ORG	Indique si l’utilisateur doit saisir des données qui ne seront pas contrôlées par le portail mais seront écrites dans le fichier de preuve et retournées avec l’accusé réception	N	ce paramètre permet de demander des informations complémentaires au signataire et qui seront remontées à l’application pour Vérification à postériori
La zone de saisie utilisée dans la page1 est libre d’usage	tag += "CUF_ORG=no\n";
DIVERSIFIANT	crypter le CUF 
Cela permet de travailler sur des cryptogrammes de données et d’éviter la diffusion des textes en clair (Validation d’un mot de passe);	N	Chaîne de caractères libre qui est donnée à la page1.jsp	
AUTH	permet de réaliser une authentification complémentaire de l’internaute (OTP, Certificat etc.) au moment de la signature	N	Chaine de caractères
Nécessite l’usage de
sous-paramètres particuliers	
OU3	valeur d’un Ou ajouté dans le DN du certificat à la volée	N	Chaine de caractères (format UTF8
uniquement en environnement JAVA)	
OU4				
OU5				
TYPE	caractérise le format de l’original métier, (XML, PDF, PDF avec signature embarquée etc.…) le type de signature internaute associé à chaque document;	O	(01), (11, 12, 14) ; (31 32 34 35 36 37 38 39) ; (43), (51)	tag += "TYPE=38\n";
VISU	contient le PDF en base 64 (Type 11 12 14)	O	feuille de style en base 64 de l’original métier (Type 01) ou nœud du XML	tag += "VISU=docPDFb64\n";
EXTRA_PARAM	permet de passer des informations au navigateur de l’utilisateur (via la page1 (Exécution d’applet etc.…), et de retourner des informations à la plateforme qui les stockera dans le fichier de preuve	N	Chaine de caractères libre	tag += "EXTRA_PARAM=demo=demoPDFSMS;numTelSMS="+(String) session.getAttribute("tel")+";smsBody=Bonjour. Voici votre code de signature : "+cuf+". "+ " Keynectis vous remercie de votre confiance.\n";
Remarques	Traité comme un fichier de propriété => l’ordre des paramètres n’a pas d’importance
paramètre non renseigné | mal syntaxé = null = valeur par défaut
DATA_METIER
C’est une chaîne de caractère libre à l’application métier qui sera mise dans l’accusé de réception et dans le fichier de preuve sous le nom de « Informations contextuelles » Cette zone peut permettre de gérer un contexte pour l’internaute ou une relation entre deux transactions (Cf. double signature d’un document) ainsi que toutes les informations jugées nécessaires à incorporer dans le fichier de preuve
CUF_ORG
Paramètres	Valeurs	Utilité	Remarques
CUF_ORG	yes	activation de la zone de saisie appelée CUFORG dans la page 1	l’utilisateur devra remplir obligatoirement ce champ
son contenu :
• ne sera pas vérifié par le portail K.Websign ;
• sera enregistré dans le fichier de preuve ;
• sera retourné à l’application métier via l’accusé de réception
	No ou Null	l’utilisateur n’aura pas de deuxième champ à remplir	
CUF_ORG2	yes ou no ou Null	Indique si l’utilisateur doit saisir une troisième information dans la page1 qui ne sera pas contrôlée par le portail mais sera écrite dans le fichier de preuve et retournée avec l’accusé réception	permet de demander des informations complémentaires au signataire et qui seront remontées à l’application pour Vérification à postériori) ; L’utilisation de ce paramètre doit être prise en compte au niveau de la création de la Page 1

AUTH
Valeurs	Sous-paramètres
X509	L’authentification de l’utilisateur est réalisée par présentation d’un certificat d’authentification valide qui sera stocké dans le fichier de preuve. La plateforme utilise les informations extraites de ce certificat pour créer le DN du certificat à la volée (Transitivité).
	Nom	Valeur	Utilité	Remarque	Obligatoire ?
	ONF_CERT_CN_ORIGIN	TRANSID : 	valeur positionnée dans le blob de requête par la fonction setName() de TransID 	Origine du CN du
certificat à la volée
(On The Fly)	O
		liste de RDN (éléments du DN du certificat présenté).	o Ex 1 : CN
o Ex 2 : GN SN	Origine de l'email
du certificat à la
volée (On The Fly)	
	ONF_CERT_EMAIL_ORIGIN	TRANSID	valeur positionnée dans le blob de requête par la fonction setEmail() de transid	Origine de l'email
du certificat à la
volée (On The Fly)	O
		E	email du DN du certificat présenté.		
		SUBALTNAME 	autre nom du sujet du certificat présenté		
	SSL_CLIENT_CERT	Certificat que l'internaute est supposé présenter	Certificat que l'internaute est supposé présenter	Certificat encodé en base64,
sans entête, sans retour chariot	Conseillé
OTP	L’authentification de l’utilisateur est réalisée par présentation d’un challenge de type One time Passcode. Cette valeur sera alors transmise vers le serveur de contrôle du client.

 
TYPE
Utilité	ajouter des informations dans le fichier de preuve pour la visualisation ultérieure de l’original métier et de forcer un mode de signature au niveau du portail
Visibilité	Les signatures apposées sont vérifiables et visualisables par tous les produits du marché susceptibles de vérifier les signatures incorporées au PDF. Dans le cas de l’utilisation des produits de la société Adobe (Reader, Acrobat) voir le paramètre d’appel setAuthority
Valeur	TYPE = 01	TYPE = 11	TYPE = 12	TYPE = 14
Description	Signature XML	Signature PDF	Signature PDF double-signé	Resignature PDF
Entrée	original métier := XML signé 
VISU := sa feuille de style en base 64 (xslt)	original métier := XML signé contenant un PDF encodé en base 64
VISU :=nœud du XML contenant le PDF en base 64 « exemple<monpdf64>	original métier := PDF en base 64 signé successivement par deux organismes. VISU := nœud du XML contenant le PDF en base 64 « exemple<monpdf64>	original métier := Sortie de type 11, qui va être sursigné par un deuxième utilisateur. 
Utiliser le champ DATA_Metier pour indiquer dans le fichier de preuve la relation avec la première signature.
Visu=idem type 11 utilisé pour la première signature pour pouvoir être interprété par le proofviewer
Sortie	Original électronique final retourné :=fichier XML contenant la signature de l’organisme client (Xmldsig) et la Signature de l’internaute (XADES avec horodatage et OCSP inclus)	Original électronique final retourné := fichier XML (Incluant le PDF en B64) contenant la signature de l’organisme client (Xmldsig) et la Signature de l’internaute (XADES avec horodatage et OCSP inclus)	Original électronique final retourné := fichier XML (incluant le PDF en B64) contenant les 2 signatures de l’organisme client (Xmldsig) et la Signature de l’internaute (XADES avec horodatage et OCSP inclus)	Original électronique final retourné :=fichier XML (Incluant un XML signé, incluant le PDF en B64 entre les balises « visu ») contenant les 2 signatures de l’organisme client (Xmldsig) et la Signature de l’internaute (XADES avec horodatage et OCSP inclus)

 
Champs Tag complétant le type
Champ	Description	Valeur Exemple
PDF_VERIFY_FIELDS 	nom du champ contenant la signature organisme que le portail doit vérifier 	Signature1
PDF_SIGN_FIELD 	nom des champs vides qui contiendront la signature utilisateur calculée par le portail	Signature2 :signature3 : ….
PDF_REASON 	motif de la signature	ceci est un test
PDF_LOCATION 	lieu de la signature	Issy les Moulineaux
PDF_CONTACT 	coordonnées du signataire	01.55.64.22.00
PDF_SIGNATURE_LAYER2_TEXT 	texte du champ de signature 	Signé Electroniquement par :
PDF_SIGNATURE_GRAPHIC	Image du champ de signature. Elle peut-être de type GIF, JPEG, …. Encodée en Base64.	image représentant une signature manuscrite
PDF_SIGNATURE_BACKGROUND_IMAGE	Image de fond du champ de signature. Elle peut-être de type GIF, JPEG, …. Encodée en Base64.	image
PDF_SIGNATURE_BACKGROUND_IMAGE_SCALE 	Echelle de l’image de fond du champ de signature 
0 : l’image remplit le champ, ses proportions ne sont pas conservées 
< 0 : l’image remplit le champ, ses proportions sont conservées 
> 0 : multiplie la taille de l’image 
L’image est toujours centrée.	-1

 
Signature d’un fichier PDF avec signature Incorporée ou embarquée
	Type
Valeur	31	32	34	35	36
Exemple d’utilisation	Signature électronique par l’internaute d’un document préalablement signé par l’organisme client (mutuelle, assurance, banque)	Signature électronique par l’internaute d’un document préalablement signé par 2 organismes dont l’organisme client (mutuelle, assurance, banque)	(Re)Signature d’un document par le (la) conjoint(e) d’un utilisateur, à la suite de ce dernier.	Signature en présentielle d’un document par l’organisme client (banque, assurance) et par un utilisateur	Signature en présentielle d’un document par un utilisateur
Entrée	Original métier =XML signé contenant un PDF encodé en base 64
VISU = nœud du XML contenant le PDF en base 64 « exemple<monpdf64>	Original métier = PDF en base 64 signé successivement par deux organismes.
VISU = idem 31	Original métier = Sortie type 31 pour signature par un deuxième utilisateur. Utiliser le champ DATA_Metier pour indiquer dans le fichier de preuve la relation avec la première signature.
VISU = idem 31	idem 31
Sortie	Original électronique final = fichier PDF autoportant (Horodatage et OCSP) contenant la signature initiale de certification de l’organisme client et la Signature de l’internaute.	Original électronique final = fichier PDF autoportant (Horodatage et OCSP) contenant les 2 signatures de l’organisme client et la Signature de l’internaute. 	Original électronique final retourné est donc un fichier PDF autoportant (Horodatage et OCSP) contenant la signature de l’organisme client et les 2 Signatures des internautes.	Original électronique final retourné = fichier PDF autoportant (Horodatage et OCSP) contenant la signature de l’organisme client et la Signature de l’internaute	Original électronique final = fichier PDF autoportant (Horodatage et OCSP) contenant uniquement la signature de l’internaute (graphique ???)
Description	Nombre champs de signature >=2 référencés PDF_SIGN_FIELD et PDF_VERIFY_FIELDS. PDF_VERIFY_FIELDS contient obligatoirement une signature embarquée. Le portail K.Websign appliquera une signature d’approbation avec un certificat « à la volée » dans les champs référencés PDF_SIGN_FIELD (Signature multi champs chaque nom est séparé par un : (Deux-points)).	Nombre champs de signature >2 référencés PDF_SIGN_FIELD et PDF_VERIFY_FIELDS. PDF_VERIFY_FIELDS contient obligatoirement une signature embarquée. Le portail K.Websign appliquera une signature d’approbation avec un certificat « à la volée » dans les champs référencés PDF_SIGN_FIELD (Signature multi champs chaque nom est séparé par un : (Deux-points)).	Nombre champs de signature >2 référencés PDF_SIGN_FIELD et PDF_VERIFY_FIELDS. Le portail K.Websign appliquera une signature d’approbation avec un certificat « à la volée » dans les champs référencés PDF_SIGN_FIELD (Signature multi champs chaque nom est séparé par un : (Deux-points) ).	Le document PDF contient un champ de signature référencé PDF_VERIFY_FIELDS. Le portail K.Websign appliquera une signature d’approbation avec un certificat « à la volée » de manière invisible au document PDF.	Le document PDF contient au moins un champ de signature référencé PDF_SIGN_FIELD. SI d’autres champs de signature sont présents et remplis ils ne seront pas vérifiés mais ces signatures doivent permettre de modifier le formulaire. Le portail K.Websign appliquera une signature d’approbation avec un certificat « à la volée » au document PDF dans le champ référencé. (Signature multi champs chaque nom est séparé par un : ).
Champs et présence dans le TAG	PDF_VERIFY_FIELDS (O)
PDF_SIGN_FIELD (O)
PDF_REASON (C)
PDF_LOCATION (C)
PDF_CONTACT (C)
PDF_SIGNATURE_LAYER2_TEXT (N)
PDF_SIGNATURE_GRAPHIC (N)
PDF_SIGNATURE_BACKGROUND_IMAGE (N)
PDF_SIGNATURE_BACKGROUND_IMAGE_SCALE (N)	PDF_VERIFY_FIELDS (O)
PDF_REASON (C)
PDF_LOCATION (C)
PDF_CONTACT (C)	PDF_SIGN_FIELD (O)
PDF_REASON (C)
PDF_LOCATION (C)
PDF_CONTACT (C)
PDF_SIGNATURE_LAYER2_TEXT (N)
PDF_SIGNATURE_GRAPHIC (N)
PDF_SIGNATURE_BACKGROUND_IMAGE (N)
PDF_SIGNATURE_BACKGROUND_IMAGE_SCALE (N)
Remarque	Signatures vérifiables et visualisables par tous les produits du marché susceptibles de vérifier les signatures incorporées au PDF	signature de l’organisme client vérifiable et visualisable et signature de l’internaute uniquement vérifiable par tous les produits du marché susceptibles de vérifier les signatures incorporées au PDF.	signature vérifiable et visualisable par tous les produits du marché susceptibles de vérifier les signatures incorporées au PDF

 
	Type
Valeur	37	38	39
Exemple d’utilisation	Demande de signature d’approbation d’une nouvelle norme ou d’un nouveau type de contrat, au PDG de la compagnie	Signature d’un contrat par un internaute	Idem 38 mais signature invisible obligatoire
Entrée	Idem 31
Sortie	Original électronique final = fichier PDF autoportant (Horodatage et OCSP) contenant la Signature d’approbation invisible de l’internaute	Original électronique final = fichier PDF autoportant (Horodatage et OCSP) contenant uniquement la signature de certification de l’internaute	Original électronique final = fichier PDF autoportant (Horodatage et OCSP) contenant uniquement la Signature invisible de certification de l’internaute
Description	Le document PDF peut ou pas contenir de champ de signature. Si le document PDF contient une première signature elle doit permettre l’apposition d’autres signatures et elle ne sera pas vérifiée. Le portail K.Websign appliquera une signature d’approbation invisible avec un certificat « à la volée » au document PDF.	Le document PDF contient au moins un champ de signature référencé PDF_SIGN_FIELD. Le document PDF ne contient pas de première signature. Le portail K.Websign appliquera une signature de certification avec droit de modification du formulaire au moyen d’un certificat « à la volée » au document PDF.	Le document PDF peut ou pas contenir de champ de signature. Le PDF ne doit pas être déjà signé. Le portail K.Websign appliquera une signature de certification avec droit de modification du formulaire invisible avec un certificat « à la volée » au document PDF.
Champs et présence dans le TAG	PDF_REASON (C)
PDF_LOCATION (C)
PDF_CONTACT (C)	PDF_SIGN_FIELD (O)
PDF_REASON (N)
PDF_LOCATION (N)
PDF_CONTACT (N)
PDF_SIGNATURE_LAYER2_TEXT (N)
PDF_SIGNATURE_GRAPHIC (N)
PDF_SIGNATURE_BACKGROUND_IMAGE (N)
PDF_SIGNATURE_BACKGROUND_IMAGE_SCALE (N)	PDF_REASON (C)
PDF_LOCATION (C)
PDF_CONTACT (C)
Remarque	Signature vérifiable et non visualisable par tous les produits du marché susceptibles de vérifier les signatures incorporées au PDF


 
VISU
Caractéristiques	Chaine de caractères en Base 64
Contenu	Type 11	nom du nœud XML contenant le PDF en base 64 « exemple<monpdf64>
	Type 12	
	Type 14	
	Type1	feuille de style XSLT converti en Base 64 permettant de visualiser le document de données XML qui sera signé par l’internaute
Remarques	Le contenu de VISU (si non null) ainsi que le contenu de TYPE, sont sauvegardés dans le fichier de preuve afin de permettre la visualisation ultérieure de l’original métier par le Proof Viewer. La feuille de style n’est donc pas obligatoire mais fortement conseillée lors de la mise en œuvre de signature de document XML (Type 01) pour réaliser le WysiWys.

WITHDRAWAL_PERIOD
Utilité 	Valeur	Remarques
précise la durée en jours pendant laquelle le fichier de preuve sera
conservé sur le serveur avant d’être archivé	0 à 30 (0 représente la valeur par défaut)	Sa valeur doit être strictement positive. S’il est absent ou si sa valeur est incorrecte : erreur 43 BAD_REQUEST
L’archivage se fait par batch nocturne une fois le délai de rétractation écoulé.
Pour l’organisme client, le traitement de la réponse TransID est identique au traitement habituel :
obtention d’un AR et du document signé.
Un fichier de preuve en attente d’archivage peut être annulé par une transaction de rétractation (Voir le Type=43)

 
PDF_FLATTENING
Utilité	Paramètres	Valeurs	Obligatoire ?	Description	Remarques
Visualisation en WYSIWYS de la ou des signatures déjà présentes (typiquement la signature organisme réalisée précédemment). Le document PDF ainsi obtenu peut également être ajouté au fichier de preuve (FP).
	PDFflattening	'y' / 'n'	N	Activation de la mise à plat du PDF affiché lors du WYSIWYS	fonction de présentation WysiWys « à plat » en cas de signature sur des terminaux ne faisant pas appel à Adobe Reader pour la visualisation des e-signatures
	flattenedPDFinProof	'y' / 'n'	N	Activation de l’ajout au FP du PDF mis à plat lors du WYSIWYS	
Envoi de la réponse au site organisme afin que ce dernier puisse disposer du document PDF dans lequel toutes les signatures ont été mises à plat. Ce document est alors ajouté à l'accusé réception (AR) d'où il peut être extrait par le site organisme	flattenedPDFinAR	'y' / 'n'	N	Activation de l’ajout à l’AR du PDF signé renvoyé dans la réponse et mis à plat	


 
A
Relire

METHODE D’APPEL KWEBSIGN
Préalablement à la mise en production de vos transactions avec Appel à K.Websign vous devrez choisir les valeurs à donner aux paramètres APPID, Servi, Sparidé qui composeront le TransNUM.
Les critères à prendre en compte sont explicités dans le chapitre § 11.1.2.
Vous pouvez implémenter autant de APPID que vous le désirez en vous souvenant que les différentes pages et protocoles de consentement sont associés à un seul APPID.
0)	Déterminer le nombre de signature le nombre de signatures que vous désirez apporter au document :
•	Vous pouvez choisir les processus de signature suivants :
o	Signature du document par l’organisme Métier puis par l’internaute ;
o	Double signature par l’organisme client puis par l’internaute ;
o	Double signature par les internautes.
1)	Déterminer le mode d’authentification du signataire que vous désirez mettre en œuvre ;
2)	Déterminer le mode d’archivage de vos documents :
•	Vous pouvez choisir les processus d’archivage suivants :
o	Archivage instantané (Défaut) ;
o	Archivage différé avec possibilité d’annulation (Rétractation). Dans ce cas vous devez gérer une transaction de rétractation de type= 43. (Cf. § 5.3.2.5 ).
Paramètres à vérifier
WITHDRAWAL_PERIOD=0 à 30 Durée de latence en jours avant archivage
3)	Déterminer le type de fichier que vous désirez mettre en signature dans votre serveur.
•	Fichier XML (Aller au 4) ;
•	Ficher PDF (Aller au 5).
4)	SI vous avez choisi un format XML vous devez vous assurer que les paramètres du tableau ci-dessous sont renseignés :
Paramètres à vérifier
Type = 01 Format de fichier de type XML
Visu = Feuille de style XSLT en Base 64 associée aux données présentées s
5)	Si vous avez choisi d’utiliser le format de fichier PDF, déterminer le modèle de signature que vous désirez apporter au document :
•	Signature Enveloppante du document PDF (La signature ne sera vérifiable que par le backoffice en utilisant l’outil de vérification de preuve de Keynectis) (Aller au 6) ;
•	Signature Embarquée dans le Document PDF (La signature est vérifiable par tous les logiciels ADOBE Reader automatiquement) (Aller au 7).
6)	Vous avez choisi de signer le document PDF de manière Enveloppante :
•	Vous pouvez choisir les processus de signature suivants :
o	Signature du document par l’organisme Métier puis par l’internaute ;
o	Double signature par l’organisme client puis par l’internaute ;
o	Double signature par les internautes :
Paramètres à vérifier
Type = 11,12 ,14 Format de fichier de type XML
Visu = Document PDF en format B64 inséré entre deux balises XML.
7)	vous avez choisi de signer le document PDF avec des signatures électroniques embarquées dans le Document et produire ainsi un original Electronique autoportant qui sera détenu par les 3 acteurs de cette transaction : (Le signataire, l’organisme Client, le tiers archiveur).
•	Vous pouvez choisir les processus de signature embarquée suivants.
7.1)	Signature embarquée par l’organisme client et l’internaute (Contrat) :
Vous devez choisir le mode de validation du Fichier PDF ;
•	Standard AATL validation avec Reader 9 et supérieur avec risque de manipulation pour l’internaute ;
•	Option CDS transparence complète pour l’internaute (Reader 7 8 9) ;
•	Vous devez choisir quel mode d’appel mettre en œuvre (cf. § 2.4 ).
7.2)	Signature embarquée avec 2 signatures Organisme et l’internaute (Contrat avec deux entités
Organismes) : 
Vous devez respecter le mode d’apposition des signatures de certification et d’approbation définis par
ADOBE.
7.3)	Signature embarquée avec signature organisme signature d’un premier internaute et signature d’un deuxième internaute (Document à co-signature) :
•	Vous devez respecter le mode d’apposition des signatures de certification et d’approbation définis par ADOBE.
7.4)	Signature Embarquée avec signature de l’internaute (Certification ou Approbation) (Visible ou
Invisible) :
Paramètres à vérifier
Type = 31 à 39 Format de fichier de type PDF avec signature Embarquée
Le document PDF doit contenir les champs de signatures
Visu = Document PDF en format B64 inséré entre deux balises XML.
Si vous désirez enchainer des signatures il suffit de soumettre le document signé à un autre des processus ci-dessous (Nous vous conseillons de changer d’APPID) pour réaliser un document à signature multiples :
Type	contrôles effectués par le portail	signatures effectuées par le portail
31	vérification de la signature organisme dans un champ nommé	ajout de la signature Internaute dans un champ nommé
32	vérification de plusieurs signatures organisme dans des champs nommés	ajout de la signature Internaute dans un champ nommé
34	idem 31	ajout d’une seconde signature Internaute dans un second champ nommé
35	idem 31	ajout de la signature Internaute invisible
36	Vérification de la signature Enveloppante des données métier	ajout de la signature d’approbation Internaute dans un champ nommé (idem 31)
37	Vérification de la signature Enveloppante des données métier	ajout de la signature d’approbation Internaute invisible (idem 35)
38	Vérification de la signature Enveloppante des données métier	ajout de la signature de certification Internaute invisible (idem 35)
39	Vérification de la signature Enveloppante des données métier	ajout de la signature de certification Internaute invisible (idem 35)
51	Vérification de la signature Enveloppante des données métier,	Signature de certification organisme par délégation dans champ nommé (visible ou invisible) et signature internaute dans un à 10 champs nommés (visibles).




