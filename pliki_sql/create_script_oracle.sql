CREATE TABLE Pacjent
  (
    id_pacjenta     INTEGER NOT NULL ,
    imie            VARCHAR2 (30) NOT NULL ,
    nazwisko        VARCHAR2 (40) NOT NULL ,
    plec            VARCHAR2 (1) NOT NULL ,
    ulica           VARCHAR2 (40) ,
    budynek         VARCHAR2 (10) ,
    nr_lokalu       INTEGER ,
    kod_pocztowy    VARCHAR2 (10) ,
    miejscowosc     VARCHAR2 (40) ,
    data_dodania    DATE NOT NULL ,
    id_polecajacego INTEGER NOT NULL
  ) ;
ALTER TABLE Pacjent ADD CONSTRAINT Pacjent_PK PRIMARY KEY ( id_pacjenta ) ;


CREATE TABLE Polecajacy
  (
    id_polecajacego INTEGER NOT NULL ,
    imie            VARCHAR2 (30) NOT NULL ,
    nazwisko        VARCHAR2 (40) NOT NULL
  ) ;
ALTER TABLE Polecajacy ADD CONSTRAINT Polecajacy_PK PRIMARY KEY ( id_polecajacego ) ;


CREATE TABLE TypUslugi
  (
    id_typuuslugi INTEGER NOT NULL ,
    nazwa         VARCHAR2 (100) NOT NULL
  ) ;
ALTER TABLE TypUslugi ADD CONSTRAINT TypUslugi_PK PRIMARY KEY ( id_typuuslugi ) ;


CREATE TABLE Usluga
  (
    id_uslugi INTEGER NOT NULL ,
    nazwa     VARCHAR2 (50) NOT NULL ,
    cena FLOAT (2) NOT NULL ,
    id_typuuslugi INTEGER NOT NULL
  ) ;
ALTER TABLE Usluga ADD CONSTRAINT Usluga_PK PRIMARY KEY ( id_uslugi ) ;


CREATE TABLE Wizyta
  (
    id_wizyty    INTEGER NOT NULL ,
    id_pacjenta  INTEGER NOT NULL ,
    data_godzina TIMESTAMP NOT NULL ,
    wartosc FLOAT (2) NOT NULL
  ) ;
ALTER TABLE Wizyta ADD CONSTRAINT Wizyta_PK PRIMARY KEY ( id_wizyty ) ;


CREATE TABLE Zabieg
  (
    id_wizyty INTEGER NOT NULL ,
    kolejnosc INTEGER NOT NULL ,
    id_uslugi INTEGER NOT NULL ,
    cena_wykonania FLOAT (2) NOT NULL
  ) ;
ALTER TABLE Zabieg ADD CONSTRAINT Zabieg_PK PRIMARY KEY ( kolejnosc, id_wizyty ) ;


ALTER TABLE Pacjent ADD CONSTRAINT Pacjent_Polecajacy_FK FOREIGN KEY ( id_polecajacego ) REFERENCES Polecajacy ( id_polecajacego ) ;

ALTER TABLE Usluga ADD CONSTRAINT Usluga_TypUslugi_FK FOREIGN KEY ( id_typuuslugi ) REFERENCES TypUslugi ( id_typuuslugi ) ;

ALTER TABLE Wizyta ADD CONSTRAINT Wizyta_Pacjent_FK FOREIGN KEY ( id_pacjenta ) REFERENCES Pacjent ( id_pacjenta ) ;

ALTER TABLE Zabieg ADD CONSTRAINT Zabieg_Usluga_FK FOREIGN KEY ( id_uslugi ) REFERENCES Usluga ( id_uslugi ) ;

ALTER TABLE Zabieg ADD CONSTRAINT Zabieg_Wizyta_FK FOREIGN KEY ( id_wizyty ) REFERENCES Wizyta ( id_wizyty ) ;

INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(1,'Jan','Kowalski');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(2,'Adam','Abacki');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(3,'Aldona','Trętowska');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(4,'Adam','Borewicz');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(5,'Marcin','Mieczkowski');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(6,'Adrian','Kimowicz');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(7,'Jarosław','Kaniewski');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(8,'Damian','Cichecki');

INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(1,'masaż');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(2,'ultradźwięki');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(3,'laser');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(4,'prądy diadynamiczne');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(5,'drenaż');

INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(1,'Daria','Kicaj','K','al. Jana Pawła III','23a',5,'01-100','Warszawa','2016-01-28',1);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(2,'Alfred','Tragarz','M','pl. Konstytucji','1',NULL,'04-839','Świnoujście','2016-01-28',2);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(3,'Konstantyn','Jeziorny','M','ul. Zambrowska','2',NULL,'64-839','Brzegi dolne','2016-01-28',3);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(4,'Agnieszka','Dąbrowska','K','ul. Podutopia','9b',2,'23-221','Brok','2016-01-28',4);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(5,'Dominika','Wojcicka','K','ul. Kwiatowa','12',5,'99-999','Małkinia Dolna','2016-01-28',5);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(6,'Michał','Konieczko','M','ul. Strażnicza','15',NULL,'89-432','Gdynia','2016-01-28',6);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(7,'Janina','Tvnowska','K','ul. Woronicza','1',NULL,'13-144','Sopot','2016-01-28',7);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(8,'Jarosława','Kaczyńska','K','ul. Na wspólnej','15',290,'01-100','Kraków','2016-01-28',8);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(9,'Lila','Hozier','K','al. Youtubea','6p',NULL,'65-064','Nibylandia','2016-01-28',5);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(10,'Iwona','Górska','K','pl. Trzech krzyży','11',2,'11-233','Mińsk Mazowiecki','2016-01-28',4);



INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(1,'Masaż relaksacyjny',19.98,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(2,'Masaż leczniczy',29.98,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(3,'Masaż limfatyczny',24.98,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(4,'Masaż gorącymi kamieniami',20.0,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(5,'Masaż gorącą czekolądą',45.0,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(6,'Masaż sportowy',15.0,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(7,'Rozbijanie złogów',80.0,2);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(8,'Jonoforeza z NaCL',30.0,4);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(9,'Leczenie nerwobóli',45.54,3);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(10,'Drenaż limfatyczny',65.33,5);

INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(1,4,'2016-01-30 15:00',59.96);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(2,3,'2016-01-29 10:00',65.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(3,5,'2016-01-30 13:00',95.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(4,5,'2016-01-30 09:00',95.33);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(5,8,'2016-01-30 14:00',24.98);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(6,6,'2016-01-30 12:00',74.979996);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(7,10,'2016-01-29 10:30',74.979996);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(8,2,'2016-01-29 13:00',80.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(9,9,'2016-01-29 14:00',125.87);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(10,7,'2016-01-30 10:30',80.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(11,2,'2016-01-30 10:00',75.54);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(12,2,'2016-01-30 15:30',89.979996);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(13,6,'2016-01-29 15:30',110.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(14,7,'2016-01-30 11:30',29.98);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(15,7,'2016-01-29 11:30',15.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(16,4,'2016-01-30 11:00',64.96);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(17,9,'2016-01-29 12:30',40.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(18,6,'2016-01-29 13:30',59.98);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(19,3,'2016-01-29 15:00',45.0);
INSERT INTO Wizyta (id_wizyty,id_pacjenta,data_godzina,wartosc) VALUES(20,8,'2016-01-30 13:30',29.98);

INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(1,1,2,29.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(1,2,2,29.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(2,3,4,20.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(2,4,5,45.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(3,5,6,15.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(3,6,7,80.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(4,7,10,65.33);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(4,8,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(5,9,3,24.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(6,10,3,24.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(6,11,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(6,12,4,20.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(7,13,2,29.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(7,14,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(7,15,6,15.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(8,16,4,20.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(8,17,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(8,18,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(9,19,10,65.33);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(9,20,9,45.54);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(9,21,6,15.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(10,22,7,80.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(11,23,9,45.54);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(11,24,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(12,25,6,15.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(12,26,5,45.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(12,27,2,29.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(13,28,7,80.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(13,29,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(14,30,2,29.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(15,31,6,15.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(16,32,4,20.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(16,33,3,24.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(16,34,1,19.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(17,35,4,20.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(17,36,4,20.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(18,37,2,29.98);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(18,38,8,30.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(19,39,5,45.0);
INSERT INTO Zabieg (id_wizyty,kolejnosc,id_uslugi,cena_wykonania) VALUES(20,40,2,29.98);
commit;