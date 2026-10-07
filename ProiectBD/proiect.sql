--Crearea de tabele
CREATE TABLE ANGAJAT (
    cod_angajat NUMBER PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    cnp VARCHAR2(13) UNIQUE NOT NULL,
    data_angajare DATE DEFAULT SYSDATE NOT NULL,
    salariu NUMBER(8,2) CHECK (salariu > 0),
    telefon VARCHAR2(15) UNIQUE NOT NULL
);

CREATE TABLE CLIENT (
    cod_client NUMBER PRIMARY KEY,
    nume VARCHAR2(50) NOT NULL,
    prenume VARCHAR2(50) NOT NULL,
    telefon VARCHAR2(15) UNIQUE NOT NULL,
    email VARCHAR2(100) UNIQUE,
    data_inregistrare DATE DEFAULT SYSDATE,
    adresa VARCHAR2(200)
);

CREATE TABLE LOCATIE (
    cod_locatie NUMBER PRIMARY KEY,
    nume VARCHAR2(100) NOT NULL,
    tara VARCHAR2(50) NOT NULL,
    tip VARCHAR2(30) CHECK (tip IN ('oras', 'statiune', 'obiectiv'))
);

CREATE TABLE AUTOCAR (
    cod_autocar NUMBER PRIMARY KEY,
    nr_inmatriculare VARCHAR2(10) UNIQUE NOT NULL,
    producator VARCHAR2(50),
    capacitate NUMBER(3) CHECK (capacitate BETWEEN 10 AND 80),
    an_fabricatie NUMBER(4) CHECK (an_fabricatie BETWEEN 1990 AND 2026)
);

CREATE TABLE PACHET_TURISTIC (
    cod_pachet NUMBER PRIMARY KEY,
    denumire VARCHAR2(100) UNIQUE NOT NULL,
    pret NUMBER(10,2) CHECK (pret > 0),
    durata_zile NUMBER(3) CHECK (durata_zile BETWEEN 1 AND 30),
    descriere VARCHAR2(500),
    disponibil CHAR(1) DEFAULT 'D' CHECK (disponibil IN ('D','N'))
);

-- Subtabele
CREATE TABLE AGENT_VANZARI (
    cod_angajat NUMBER PRIMARY KEY,
    comision NUMBER(5,2) DEFAULT 0 CHECK (comision >= 0),
    cota_vanzari NUMBER(3) CHECK (cota_vanzari BETWEEN 0 AND 100),
    FOREIGN KEY (cod_angajat) REFERENCES ANGAJAT(cod_angajat) ON DELETE CASCADE
);

CREATE TABLE GHID (
    cod_angajat NUMBER PRIMARY KEY,
    vechime_ani NUMBER(2) CHECK (vechime_ani BETWEEN 0 AND 50),
    limbi_straine VARCHAR2(100) NOT NULL,
    certificari VARCHAR2(200),
    FOREIGN KEY (cod_angajat) REFERENCES ANGAJAT(cod_angajat) ON DELETE CASCADE
);

CREATE TABLE SOFER (
    cod_angajat NUMBER PRIMARY KEY,
    permis_categorii VARCHAR2(10) NOT NULL,
    ani_experienta NUMBER(2) CHECK (ani_experienta >= 0),
    FOREIGN KEY (cod_angajat) REFERENCES ANGAJAT(cod_angajat) ON DELETE CASCADE
);

CREATE TABLE EXCURSIE (
    cod_pachet NUMBER PRIMARY KEY,
    traseu VARCHAR2(200) NOT NULL,
    nr_locatii NUMBER(2) CHECK (nr_locatii >= 1),
    FOREIGN KEY (cod_pachet) REFERENCES PACHET_TURISTIC(cod_pachet) ON DELETE CASCADE
);

CREATE TABLE SEJUR (
    cod_pachet NUMBER PRIMARY KEY,
    cod_locatie NUMBER NOT NULL,
    hotel VARCHAR2(100) NOT NULL,
    tip_camera VARCHAR2(30) NOT NULL,
    masa_inclusa VARCHAR2(20) DEFAULT 'fara masa' CHECK (masa_inclusa IN ('fara masa', 'mic dejun', 'all inclusive')),
    FOREIGN KEY (cod_pachet) REFERENCES PACHET_TURISTIC(cod_pachet) ON DELETE CASCADE,
    FOREIGN KEY (cod_locatie) REFERENCES LOCATIE(cod_locatie)
);

-- Tabela REZERVARE (dependenta)
CREATE TABLE REZERVARE (
    cod_rezervare NUMBER PRIMARY KEY,
    cod_client NUMBER NOT NULL,
    cod_pachet NUMBER NOT NULL,
    cod_agent NUMBER NOT NULL,
    data_rezervare DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'noua' CHECK (status IN ('noua', 'confirmata', 'anulata', 'finalizata')),
    data_inceput DATE NOT NULL,
    data_sfarsit DATE NOT NULL,
    FOREIGN KEY (cod_client) REFERENCES CLIENT(cod_client),
    FOREIGN KEY (cod_pachet) REFERENCES PACHET_TURISTIC(cod_pachet),
    FOREIGN KEY (cod_agent) REFERENCES AGENT_VANZARI(cod_angajat),
    CHECK (data_sfarsit > data_inceput)
);

CREATE TABLE PLATA (
    cod_plata NUMBER PRIMARY KEY,
    cod_rezervare NUMBER NOT NULL,
    suma NUMBER(10,2) CHECK (suma > 0),
    data_plata DATE DEFAULT SYSDATE NOT NULL,
    mod_plata VARCHAR2(20) CHECK (mod_plata IN ('cash', 'card', 'transfer')),
    FOREIGN KEY (cod_rezervare) REFERENCES REZERVARE(cod_rezervare)
);

-- Tabele asociative (M:N)
CREATE TABLE INCLUDERE_EXCURSIE_LOCATIE (
    cod_pachet NUMBER,
    cod_locatie NUMBER,
    PRIMARY KEY (cod_pachet, cod_locatie),
    FOREIGN KEY (cod_pachet) REFERENCES EXCURSIE(cod_pachet) ON DELETE CASCADE,
    FOREIGN KEY (cod_locatie) REFERENCES LOCATIE(cod_locatie) ON DELETE CASCADE
);

CREATE TABLE ASIGNARE_GHID_EXCURSIE (
    cod_angajat NUMBER,
    cod_pachet NUMBER,
    PRIMARY KEY (cod_angajat, cod_pachet),
    FOREIGN KEY (cod_angajat) REFERENCES GHID(cod_angajat) ON DELETE CASCADE,
    FOREIGN KEY (cod_pachet) REFERENCES EXCURSIE(cod_pachet) ON DELETE CASCADE
);

CREATE TABLE ASIGNARE_AUTOCAR_EXCURSIE (
    cod_autocar NUMBER,
    cod_pachet NUMBER,
    PRIMARY KEY (cod_autocar, cod_pachet),
    FOREIGN KEY (cod_autocar) REFERENCES AUTOCAR(cod_autocar) ON DELETE CASCADE,
    FOREIGN KEY (cod_pachet) REFERENCES EXCURSIE(cod_pachet) ON DELETE CASCADE
);

CREATE TABLE CONDUCERE (
    cod_angajat NUMBER,
    cod_autocar NUMBER,
    PRIMARY KEY (cod_angajat, cod_autocar),
    FOREIGN KEY (cod_angajat) REFERENCES SOFER(cod_angajat) ON DELETE CASCADE,
    FOREIGN KEY (cod_autocar) REFERENCES AUTOCAR(cod_autocar) ON DELETE CASCADE
);

--Crearea de secvente
CREATE SEQUENCE seq_client START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_angajat START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pachet START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_locatie START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_autocar START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_rezervare START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_plata START WITH 1 INCREMENT BY 1;

--Inserare date

--LOCATIE
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Paris', 'Franta', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Mamaia', 'Romania', 'statiune');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Bran', 'Romania', 'obiectiv');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Roma', 'Italia', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Poiana Brasov', 'Romania', 'statiune');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Bucuresti', 'Romania', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Heraklion', 'Grecia', 'statiune');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Nisipurile de aur', 'Bulgaria', 'statiune');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Sibiu', 'Romania', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Venus', 'Romania', 'statiune');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Florenta', 'Italia', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Venetia', 'Italia', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Budapesta', 'Ungaria', 'oras');
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Delta Dunarii', 'Romania', 'obiectiv');


--AUTOCAR
INSERT INTO AUTOCAR VALUES (seq_autocar.NEXTVAL, 'CJ01ABC', 'Mercedes', 55, 2021);
INSERT INTO AUTOCAR VALUES (seq_autocar.NEXTVAL, 'TM02XYZ', 'Volvo', 48, 2023);
INSERT INTO AUTOCAR VALUES (seq_autocar.NEXTVAL, 'IS03LMN', 'Scania', 62, 2018);
INSERT INTO AUTOCAR VALUES (seq_autocar.NEXTVAL, 'B123ABC', 'Mercedes', 50, 2020);
INSERT INTO AUTOCAR VALUES (seq_autocar.NEXTVAL, 'B456DEF', 'Volvo', 60, 2022);
INSERT INTO AUTOCAR VALUES (seq_autocar.NEXTVAL, 'B789GHI', 'MAN', 55, 2019);

--ANGAJAT
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Popescu', 'Ion', '1234567890123', DATE '2015-06-01', 3500, '0711111111');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Ionescu', 'Maria', '2345678901234', DATE '2018-09-15', 3200, '0722222222');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Vasilescu', 'George', '3456789012345', DATE '2020-01-20', 2800, '0733333333');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Stoica', 'Elena', '4567890123456', DATE '2017-04-10', 4000, '0744444444');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Constantin', 'Andrei', '5678901234567', DATE '2021-07-05', 3100, '0755555555');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Linda', 'Denisa', '6666666666666', DATE '2026-05-09', 3200, '0766666666');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Olteanu', 'Luca', '7777777777777', DATE '2026-05-09', 3200, '0777777777');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Diaconu', 'Laura', '8888888888888', DATE '2022-03-10', 3000, '0788888888');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Marin', 'Catalin', '9999999999999', DATE '2023-07-21', 2900, '0799999999');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Barbu', 'Alina', '1111111111111', DATE '2024-01-15', 3100, '0711111112');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Nedelcu', 'Roxana', '1212121212121', DATE '2019-08-01', 3600, '0722222223');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Tudor', 'Silviu', '1313131313131', DATE '2020-11-11', 3300, '0733333334');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Petrescu', 'Ionut', '1414141414141', DATE '2021-05-09', 3200, '0744444445');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Radu', 'Marius', '1515151515151', DATE '2022-12-20', 3000, '0755555556');
INSERT INTO ANGAJAT VALUES (seq_angajat.NEXTVAL, 'Serban', 'Andreea', '1616161616161', DATE '2023-09-30', 3100, '0766666667');

INSERT INTO AGENT_VANZARI VALUES (1, 5.5, 80);
INSERT INTO AGENT_VANZARI VALUES (2, 4.0, 65);
INSERT INTO AGENT_VANZARI VALUES (21, 6.0, 90);  
INSERT INTO AGENT_VANZARI VALUES (22, 3.5, 60);  
INSERT INTO AGENT_VANZARI VALUES (23, 5.0, 75);

INSERT INTO GHID VALUES (3, 3, 'Engleza, Franceza', 'Ghid montan');
INSERT INTO GHID VALUES (4, 6, 'Engleza, Italiana', 'Ghid urban');
INSERT INTO GHID VALUES (24, 5, 'Engleza, Spaniola', 'Ghid montan');
INSERT INTO GHID VALUES (25, 2, 'Franceza', 'Ghid oras');
INSERT INTO GHID VALUES (6, 2, 'Engleza, Portugheza', 'Ghid urban');

INSERT INTO SOFER VALUES (5, 'B,C,D', 8);
INSERT INTO SOFER VALUES (7, 'B,C,D', 2);
INSERT INTO SOFER VALUES (26, 'B,C', 6);
INSERT INTO SOFER VALUES (27, 'C,E', 4);
INSERT INTO SOFER VALUES (28, 'B', 2);


--pachete
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Paris city break', 550, 3, 'Zbor + cazare + ghid local', 'D');--excursie1
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Italia clasica', 1200, 7, 'Roma, Florenta, Venetia', 'D');--excursie2
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Vacanta la mare Mamaia', 400, 7, 'Cazare la hotel 3 stele, all inclusive', 'D');--sejur3
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Brasov montan', 300, 4, 'Pensiune la poalele Tampa', 'D');--sejur4
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'City break Budapesta', 450, 3, 'Transport cu autocarul', 'D');--excursie5
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Grecia insulara', 950, 7, 'Creta, Heraklion, plaje', 'N');--sejur6
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Turul Transilvaniei', 700, 5, 'Brasov, Sibiu, Sighisoara', 'D');--excursie7
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Litoral bulgaresc', 280, 5, 'Nisipurile de aur, all inclusive', 'D');--excursie8
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Delta Dunarii', 350, 2, 'Observare pasari, barca', 'D');--excursie9
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Sibiu medieval', 420, 3, 'Cazare in centrul vechi', 'D');--sejur21
INSERT INTO PACHET_TURISTIC VALUES (seq_pachet.NEXTVAL, 'Statiunea Venus', 380, 5, 'Hotel 3 stele, pensiune completa', 'D');--sejur22

INSERT INTO EXCURSIE VALUES (1, 'Paris - Turnul Eiffel - Luvru', 2);
INSERT INTO EXCURSIE VALUES (2, 'Roma - Florenta - Venetia', 3);
INSERT INTO EXCURSIE VALUES (5, 'Budapesta - Castelul Buda - Terme', 2);
INSERT INTO EXCURSIE VALUES (7, 'Brasov - Sibiu - Sighisoara', 3);
INSERT INTO EXCURSIE VALUES (8, 'Varna - Nisipurile de aur', 2);
INSERT INTO EXCURSIE VALUES (9, 'Tulcea - Sulina - Mila 23', 4);

INSERT INTO SEJUR VALUES (3, 2, 'Hotel Rex', 'dubla', 'all inclusive');
INSERT INTO SEJUR VALUES (4, 5, 'Pensiunea Ana', 'tripla', 'mic dejun');
INSERT INTO SEJUR VALUES (6, 7, 'Creta Maris', 'single', 'all inclusive');
INSERT INTO SEJUR VALUES (21, 21, 'Hotel Imparatul Romanilor', 'dubla', 'fara masa');
INSERT INTO SEJUR VALUES (22, 22, 'Hotel Del Mar', 'tripla', 'all inclusive');

--CLIENT
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Pop', 'Adrian', '0766666666', 'adrian@gmail.com', SYSDATE, 'Str Libertatii 5');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Munteanu', 'Cristina', '0777777777', 'cristina@gmail.com', SYSDATE, 'Bd Unirii 10');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Dumitrescu', 'Andrei', '0788888888', 'andrei@gmail.com', SYSDATE, 'Calea Victoriei 20');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Gheorghe', 'Elena', '0799999999', 'elena@gmail.com', SYSDATE, 'Str Dorobanti 15');
INSERT INTO CLIENT VALUES (seq_client.NEXTVAL, 'Stan', 'Mihai', '0700000000', 'mihai@mail.com', SYSDATE, 'Bd Carol 30');

--REZERVARI
INSERT INTO REZERVARE VALUES (seq_rezervare.NEXTVAL, 1, 1, 1, SYSDATE, 'confirmata', DATE '2026-07-10', DATE '2026-07-13');
INSERT INTO REZERVARE VALUES (seq_rezervare.NEXTVAL, 1, 3, 2, SYSDATE, 'noua', DATE '2026-08-01', DATE '2026-08-08');
INSERT INTO REZERVARE VALUES (seq_rezervare.NEXTVAL, 2, 2, 1, SYSDATE, 'finalizata', DATE '2025-06-15', DATE '2025-06-22');
INSERT INTO REZERVARE VALUES (seq_rezervare.NEXTVAL, 3, 5, 2, SYSDATE, 'anulata', DATE '2026-09-20', DATE '2026-09-23');
INSERT INTO REZERVARE VALUES (seq_rezervare.NEXTVAL, 4, 7, 21, SYSDATE, 'confirmata', DATE '2026-10-05', DATE '2026-10-10');

--plati
INSERT INTO PLATA VALUES (seq_plata.NEXTVAL, 1, 550, SYSDATE, 'card');
INSERT INTO PLATA VALUES (seq_plata.NEXTVAL, 2, 200, SYSDATE, 'cash');
INSERT INTO PLATA VALUES (seq_plata.NEXTVAL, 2, 200, SYSDATE, 'transfer');
INSERT INTO PLATA VALUES (seq_plata.NEXTVAL, 3, 1200, SYSDATE, 'card');
INSERT INTO PLATA VALUES (seq_plata.NEXTVAL, 4, 450, SYSDATE, 'cash');

--tabele asociative
--locatii excursii
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (1, 1);  
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (2, 4);  
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (2, 23);
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (2, 25);
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (5, 26);
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (7, 3); 
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (7, 5); 
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (7, 21); 
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (8, 8); 
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (9, 27);

--ghid excursie
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (3, 1);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (4, 2);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (6, 5);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (24, 7);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (25, 8);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (3, 2);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (4, 5);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (6, 7);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (24, 8);
INSERT INTO ASIGNARE_GHID_EXCURSIE VALUES (25, 9);

--autocar - excursie
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (1, 1);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (2, 2);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (3, 5);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (4, 7);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (5, 8);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (6, 9);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (1, 2);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (2, 5);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (3, 7);
INSERT INTO ASIGNARE_AUTOCAR_EXCURSIE VALUES (4, 8);

--conduce
INSERT INTO CONDUCERE VALUES (5, 1);
INSERT INTO CONDUCERE VALUES (7, 2);
INSERT INTO CONDUCERE VALUES (26, 3);
INSERT INTO CONDUCERE VALUES (27, 4);
INSERT INTO CONDUCERE VALUES (28, 5);
INSERT INTO CONDUCERE VALUES (5, 2);
INSERT INTO CONDUCERE VALUES (7, 3);
INSERT INTO CONDUCERE VALUES (26, 4);
INSERT INTO CONDUCERE VALUES (27, 5);
INSERT INTO CONDUCERE VALUES (28, 6);


--12
--cereri

--Cererea 1
--a) subcereri sincronizate in care intervin cel putin 3 tabele ()

--Listez clientii (nume, prenume) care au facut rezervari pentru pachete turistice disponibile (disponibil = 'D') si care au plati efectuate cu cardul + suma totala platita de fiecare client.

SELECT DISTINCT c.nume, c.prenume, 
       (SELECT SUM(p.suma) 
        FROM PLATA p 
        WHERE p.cod_rezervare = r.cod_rezervare) AS total_plata
FROM CLIENT c, REZERVARE r, PACHET_TURISTIC pt
WHERE c.cod_client = r.cod_client AND r.cod_pachet = pt.cod_pachet AND pt.disponibil = 'D' AND EXISTS 
(
SELECT 1 
FROM PLATA p2 
WHERE p2.cod_rezervare = r.cod_rezervare 
AND p2.mod_plata = 'card'
);


--Cererea 2
--b) subcereri nesincronizate in clauza FROM 

--Pentru fiecare agent de vanzari, afisam numele, prenumele si valoarea totala a rezervarilor confirmate.


SELECT av.cod_angajat, a.nume, a.prenume, total_rezervari.valoare_totala
FROM AGENT_VANZARI av
JOIN ANGAJAT a ON av.cod_angajat = a.cod_angajat
JOIN (
        SELECT r.cod_agent, SUM(pt.pret) AS valoare_totala
        FROM REZERVARE r
        JOIN PACHET_TURISTIC pt ON r.cod_pachet = pt.cod_pachet
        WHERE r.status = 'confirmata'
        GROUP BY r.cod_agent
      ) total_rezervari ON av.cod_angajat = total_rezervari.cod_agent;
      
--Cererea 3
--c) grupari de date, functii grup, filtrare la nivel de grupuri cu subcereri nesincronizate 
--(in clauza de HAVING) in care intervin cel putin 3 tabele (in cadrul aceleiasi cereri) 

--Gasim destinatiile (nume locatie) care au fost incluse in cel putin 2 excursii diferite si pentru care 
--numarul total de rezervari ale excursiilor respective depaseste media generala a rezervarilor pe locatie.

--am adaugat locatia Bucuresti la 3 excursii(presupunem ca se pleaca de acolo si se pune si ea ca locatie) ca sa avem un rezultat la cerere
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (1, 6);
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (2, 6); 
INSERT INTO INCLUDERE_EXCURSIE_LOCATIE VALUES (7, 6); 




SELECT l.nume, COUNT(DISTINCT ie.cod_pachet) AS nr_excursii,
       (SELECT COUNT(*) FROM REZERVARE r WHERE r.cod_pachet IN 
            (SELECT ie2.cod_pachet FROM INCLUDERE_EXCURSIE_LOCATIE ie2 WHERE ie2.cod_locatie = l.cod_locatie)) AS total_rezervari
FROM LOCATIE l
JOIN INCLUDERE_EXCURSIE_LOCATIE ie ON l.cod_locatie = ie.cod_locatie GROUP BY l.cod_locatie, l.nume
HAVING COUNT(DISTINCT ie.cod_pachet) >= 2
    AND (SELECT COUNT(*) FROM REZERVARE r WHERE r.cod_pachet IN 
        (SELECT ie2.cod_pachet FROM INCLUDERE_EXCURSIE_LOCATIE ie2 WHERE ie2.cod_locatie = l.cod_locatie))
        >
        (SELECT AVG(total) FROM (SELECT COUNT(*) AS total FROM REZERVARE r2 GROUP BY r2.cod_pachet));
        
--Cererea 4
--d) ordonari si utilizarea functiilor NVL si DECODE (in cadrul aceleiasi cereri) 

--Listam toate platile (cod_plata, suma, mod_plata), afisand in loc de NULL la mod_plata textul 'necunoscut', 
--iar pentru suma afisam o categorie (MICA, MEDIE, MARE) folosind DECODE. Ordonate descrescator dupa suma.


SELECT cod_plata, suma, NVL(mod_plata, 'necunoscut') AS mod_plata_corect,
DECODE(TRUNC(suma/100), 0, 'MICA', 1, 'MICA', 2, 'MEDIE', 3, 'MEDIE', 4, 'MARE', 'MARE') AS categorie_suma
FROM PLATA
ORDER BY suma DESC;

--Cererea 5
--e) utilizarea a cel putin 2 functii pe siruri de caractere, 2 functii pe date calendaristice, a cel putin unei expresii CASE
--f) utilizarea a cel putin 1 bloc de cerere (clauza WITH) 

--Pentru fiecare client, afisami primele 3 litere din nume si lungimea prenumelui, data inregistrarii sub forma 'DD-MM-YYYY', 
--precum si un calcul al vechimii in zile. Adaugam o coloana care sa clasifice clientul (VECHI, NOU) folosind CASE. 
--Folosim WITH pentru a ne defini tabelul cu vechimea clientului pentru JOIN mai incolo.


WITH vechime_client AS 
(
    SELECT cod_client, 
    TRUNC(SYSDATE - data_inregistrare) AS zile_vechime
    FROM CLIENT
)
SELECT c.cod_client,
       SUBSTR(c.nume, 1, 3) AS prefix_nume,
       LENGTH(c.prenume) AS lungime_prenume,
       TO_CHAR(c.data_inregistrare, 'DD-MM-YYYY') AS data_inreg_format,
       vc.zile_vechime,
       CASE WHEN vc.zile_vechime > 365 THEN 'VECHI' ELSE 'NOU' END AS tip_client
FROM CLIENT c
JOIN vechime_client vc ON c.cod_client = vc.cod_client;


--13

-- Crestem comisionul cu 2 puncte pentru agentii care au rezervari finalizate 
-- cu pachete cu pret peste 1000 de lei.

UPDATE AGENT_VANZARI av
SET av.comision = av.comision + 2
WHERE av.cod_angajat IN (
    SELECT DISTINCT r.cod_agent
    FROM REZERVARE r
    JOIN PACHET_TURISTIC pt ON r.cod_pachet = pt.cod_pachet
    WHERE pt.pret > 1000 AND r.status = 'finalizata'
);

-- Stergem locatiile care nu sunt folosite in nicio asociere cu excursii sau sejururi(nu le folosim la vreun pachet)
--(inseram o locatie doar pentru a arata ca functioneaza cererea)
INSERT INTO LOCATIE VALUES (seq_locatie.NEXTVAL, 'Ploiesti', 'Romania', 'oras');


DELETE FROM LOCATIE l
WHERE l.cod_locatie NOT IN (SELECT DISTINCT cod_locatie FROM INCLUDERE_EXCURSIE_LOCATIE)
  AND l.cod_locatie NOT IN (SELECT DISTINCT cod_locatie FROM SEJUR);


-- Sterge rezervarile care nu au niciun rand in PLATA
DELETE FROM REZERVARE r
WHERE NOT EXISTS (
    SELECT 1
    FROM PLATA p
    WHERE p.cod_rezervare = r.cod_rezervare
);
  

--14
--Sa aratam pentru fiecare client numele, prenumele, numarul total de rezervari facute, 
--suma totala platita (din toate platile aferente rezervarilor) si valoarea medie a platilor.

CREATE OR REPLACE VIEW raport_clienti AS
SELECT c.cod_client,
       c.nume,
       c.prenume,
       COUNT(DISTINCT r.cod_rezervare) AS nr_rezervari,
       NVL(SUM(p.suma), 0) AS total_platit,
       NVL(ROUND(AVG(p.suma), 2), 0) AS media_plata
FROM CLIENT c
LEFT JOIN REZERVARE r ON c.cod_client = r.cod_client
LEFT JOIN PLATA p ON r.cod_rezervare = p.cod_rezervare
GROUP BY c.cod_client, c.nume, c.prenume;

--functie lmd permisa(doar SELECT pentru ca este complexa)
SELECT * FROM raport_clienti WHERE nr_rezervari > 0;

--functie nepermisa(UPDATE sau DELET sau INSERT)
UPDATE raport_clienti SET total_platit = 2000 WHERE cod_client = 1;


--


SELECT av.cod_angajat, a.nume, a.prenume, total_rezervari.valoare_totala
FROM AGENT_VANZARI av
JOIN ANGAJAT a ON av.cod_angajat = a.cod_angajat
JOIN (
        SELECT r.cod_agent, SUM(pt.pret) AS valoare_totala, COUNT (r.cod_agent) as numar_rez
        FROM REZERVARE r
        JOIN PACHET_TURISTIC pt ON r.cod_pachet = pt.cod_pachet
        WHERE r.status = 'confirmata'
        GROUP BY r.cod_agent
) total_rezervari ON av.cod_angajat = total_rezervari.cod_agent
WHERE total_rezervari.numar_rez <=2;


UPDATE AGENT_VANZARI av
SET av.comision = av.comision - 1
WHERE av.cod_angajat IN (
    SELECT DISTINCT r.cod_agent
    FROM REZERVARE r
    JOIN PACHET_TURISTIC pt ON r.cod_pachet = pt.cod_pachet
    WHERE SUBSTR(INITCAP(pt.denumire), 1, 1) IN ('A', 'B', 'C')
);