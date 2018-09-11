CREATE TABLE Pacjent
  (
    id_pacjenta     INTEGER NOT NULL DEFAULT AUTOINCREMENT,
    imie            VARCHAR (30) NOT NULL ,
    nazwisko        VARCHAR (40) NOT NULL ,
    plec            VARCHAR (1) NOT NULL ,
    ulica           VARCHAR (40) ,
    budynek         VARCHAR (10) ,
    nr_lokalu       INTEGER ,
    kod_pocztowy    VARCHAR (10) ,
    miejscowosc     VARCHAR (40) ,
    data_dodania    DATE NOT NULL ,
    id_polecajacego INTEGER NOT NULL
  ) ;
ALTER TABLE Pacjent ADD CONSTRAINT Pacjent_PK PRIMARY KEY ( id_pacjenta ) ;


CREATE TABLE Polecajacy
  (
    id_polecajacego INTEGER NOT NULL DEFAULT AUTOINCREMENT,
    imie            VARCHAR (30) NOT NULL ,
    nazwisko        VARCHAR (40) NOT NULL
  ) ;
ALTER TABLE Polecajacy ADD CONSTRAINT Polecajacy_PK PRIMARY KEY ( id_polecajacego ) ;


CREATE TABLE TypUslugi
  (
    id_typuuslugi INTEGER NOT NULL DEFAULT AUTOINCREMENT,
    nazwa         VARCHAR (100) NOT NULL
  ) ;
ALTER TABLE TypUslugi ADD CONSTRAINT TypUslugi_PK PRIMARY KEY ( id_typuuslugi ) ;


CREATE TABLE Usluga
  (
    id_uslugi INTEGER NOT NULL DEFAULT AUTOINCREMENT,
    nazwa     VARCHAR (50) NOT NULL ,
    cena FLOAT (2) NOT NULL ,
    id_typuuslugi INTEGER NOT NULL
  ) ;
ALTER TABLE Usluga ADD CONSTRAINT Usluga_PK PRIMARY KEY ( id_uslugi ) ;


CREATE TABLE Wizyta
  (
    id_wizyty    INTEGER NOT NULL DEFAULT AUTOINCREMENT,
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

CREATE OR REPLACE FUNCTION fn_losuj_liczbe
(v_min INTEGER, v_max INTEGER)
RETURNS INTEGER
BEGIN
	DECLARE v_wylosowana_wartosc INTEGER;

	-- losowanie liczby funkcj¹ rand i zaokr¹glanie funkcj¹ round z przedzia³u od v_min do v_max
	SET v_wylosowana_wartosc = round(v_min + (v_max - v_min) * rand(), 0);

RETURN v_wylosowana_wartosc;
END;

CREATE OR REPLACE FUNCTION fn_losuj_pacjenta()
-- zwracany typ
RETURNS INTEGER
BEGIN
	-- deklaracja zmiennych
    DECLARE v_wylosowane_id_pacjenta INTEGER;
    DECLARE v_min_id_pacjenta INTEGER;
    DECLARE v_max_id_pacjenta INTEGER;
    DECLARE v_flaga INTEGER;
    
	-- pobranie wartosci klucza glownego o minimalnej wartosci z tabeli Pacjent
    SELECT MIN(id_pacjenta) INTO v_min_id_pacjenta FROM Pacjent;
	-- pobranie wartosci klucza glownego o maksymalnej wartosci z tabeli Pacjent
    SELECT MAX(id_pacjenta) INTO v_max_id_pacjenta FROM Pacjent;
    
	-- sprawdzenie czy pobrano wartosci klucza glownego minimalnego i maksymalnego
    IF ((v_min_id_pacjenta IS NOT NULL) AND (v_max_id_pacjenta IS NOT NULL)) THEN
		-- ustawienie flagi odpowiedzialnej za kontynuowanie petli
        SET v_flaga = 0;
    
		-- petla iteruje dopoki wylosowane id pacjenta istnieje
        WHILE (v_flaga = 0) LOOP
			-- losowanie pacjenta
            SET v_wylosowane_id_pacjenta = fn_losuj_liczbe(v_min_id_pacjenta, v_max_id_pacjenta);
    
			-- jezeli pacjent z wylosowanym id_pacjenta istnieje to ustawienie flagi na 1 co spowoduje zakonczenie pêtli
            IF EXISTS (SELECT id_pacjenta FROM Pacjent WHERE id_pacjenta = v_wylosowane_id_pacjenta) THEN
                SET v_flaga = 1;
            END IF;
        END LOOP;
		
		-- zwrocenie wartoœci wylosowanego id
        RETURN v_wylosowane_id_pacjenta;
    ELSE
		-- zwrócenie -1 w przypadku b³êdu
        RETURN -1;
    END IF;
END;

CREATE OR REPLACE FUNCTION fn_losuj_usluge()
RETURNS INTEGER
BEGIN
    DECLARE v_wylosowane_id_uslugi INTEGER;
    DECLARE v_min_id_uslugi INTEGER;
    DECLARE v_max_id_uslugi INTEGER;
    DECLARE v_flaga INTEGER;
    
    SELECT MIN(id_uslugi) INTO v_min_id_uslugi FROM Usluga;
    SELECT MAX(id_uslugi) INTO v_max_id_uslugi FROM Usluga;
    
    IF ((v_min_id_uslugi IS NOT NULL) AND (v_max_id_uslugi IS NOT NULL)) THEN
       
        SET v_flaga = 0;
    
        WHILE (v_flaga = 0) LOOP
            SET v_wylosowane_id_uslugi = fn_losuj_liczbe(v_min_id_uslugi, v_max_id_uslugi);
    
            IF EXISTS (SELECT id_uslugi FROM Usluga WHERE id_uslugi = v_wylosowane_id_uslugi) THEN
                SET v_flaga = 1;
            END IF;
        END LOOP;
        RETURN v_wylosowane_id_uslugi;
    ELSE
        RETURN -1;
    END IF;
END;

CREATE OR REPLACE PROCEDURE pr_dodaj_zabieg_do_wizyty
(v_id_wizyty INTEGER)
BEGIN
	-- zadeklarowanie zmiennych
	DECLARE v_id_uslugi INTEGER;
	DECLARE v_kolejnosc INTEGER;
	
	-- wylosowanie uslugi
	SET v_id_uslugi = fn_losuj_usluge();
	
	-- ustawienie kolejnosci zabiegu
	SET v_kolejnosc = 1;
	
	IF EXISTS (SELECT * FROM Zabieg WHERE id_wizyty = v_id_wizyty) THEN
		SELECT (MAX(kolejnosc) + 1) INTO v_kolejnosc FROM Zabieg WHERE id_wizyty = v_id_wizyty;
	END IF;
	
	-- dodanie zabiegu do wizyty
	INSERT INTO Zabieg (id_wizyty, kolejnosc, id_uslugi, cena_wykonania)
		VALUES (v_id_wizyty, v_kolejnosc, v_id_uslugi, 0);
END;

CREATE OR REPLACE PROCEDURE pr_dodaj_wizyty
(od_dnia DATE, do_dnia DATE, liczba INT)
BEGIN
	DECLARE v_znaleziono_pusty_termin INTEGER;
	DECLARE v_roznica_w_dniach INTEGER;
	DECLARE v_wylosowany_offset_dnia INTEGER;
	DECLARE v_wylosowana_data_godzina TIMESTAMP;
	DECLARE v_wylosowany_offset_godziny INTEGER;
	DECLARE v_bledow_znalezienia INTEGER;
	DECLARE v_flaga INTEGER;
	
	-- liczenie roznicy w dniach, aby wylosowac ktorego dnia dodac wizyte
	SET v_roznica_w_dniach = DATEDIFF(DAY, od_dnia, do_dnia);
	
	-- petla po liczbie wizyt do dodania
	WHILE (liczba > 0) LOOP
		SET v_znaleziono_pusty_termin = 0;
		SET v_bledow_znalezienia = 0;
		SET v_flaga = 1;
		
		-- petla wykonywana dopoki znaleziono pusty termin lub jezeli po 14 iteracjach nie znaleziono pustego termina
		WHILE (v_flaga = 1) LOOP
			-- losowanie liczby, ktora pozwoli na wylosowanie dnia wizyty
			SET v_wylosowany_offset_dnia = fn_losuj_liczbe(0, v_roznica_w_dniach);
			-- ustawienie dnia wizyty
			SET v_wylosowana_data_godzina = DATEADD(DAY, v_wylosowany_offset_dnia, od_dnia);
			
			-- losowanie liczby, ktora pozwoli na wylosowanie godziny wizyty
			SET v_wylosowany_offset_godziny = fn_losuj_liczbe(0, 14);
			-- ustawienie godziny wizyty
			SET v_wylosowana_data_godzina = DATEADD(MINUTE, 9 * 60 + v_wylosowany_offset_godziny * 30, v_wylosowana_data_godzina);
			
			-- sprawdzenie czy w tym terminie nie istnieje juz wizyta
			IF NOT EXISTS (SELECT * FROM Wizyta WHERE data_godzina = v_wylosowana_data_godzina) THEN
				-- nie istnieje, wiec przerwij petle
				SET v_znaleziono_pusty_termin = 1;
				SET v_flaga = 0;
			ELSE
				-- istnieje, wiec dodaj blad znalezienia
				SET v_bledow_znalezienia = v_bledow_znalezienia + 1;
			END IF;
			
			-- jezeli po 14 iteracjach nadal nie znaleziono wolnego terminu to znaczy ze najprawdopodobniej go nie ma - przewij petle
			IF (v_bledow_znalezienia >= 14) THEN
				SET v_flaga = 0;
			END IF;
		END LOOP;
		
		-- jezeli znaleziono pusty termin to wywolaj procedure dodawania wizyty
		IF (v_znaleziono_pusty_termin = 1) THEN
			call pr_dodaj_wizyte(v_wylosowana_data_godzina);
		END IF;
		
		-- zmniejsz liczbe iteracji o jeden
		SET liczba = liczba - 1;
	END LOOP;
END;

CREATE OR REPLACE PROCEDURE pr_dodaj_wizyte
(v_data_godzina TIMESTAMP)
BEGIN
	DECLARE v_id_pacjenta INTEGER;
    DECLARE v_liczba_zabiegow INTEGER;
	DECLARE v_id_wizyty INTEGER;

	-- losowanie pacjenta dla ktorego dodana zostanie wizyta
	SET v_id_pacjenta = fn_losuj_pacjenta();
    
	-- jezeli znaleziono pacjenta to dalszy kod
	IF (v_id_pacjenta != -1) THEN
		-- dodanie wizyty dla wylosowanego pacjenta o podanej w parametrze procedury dacie i czasie
		INSERT INTO Wizyta (id_pacjenta, data_godzina, wartosc)
			VALUES (v_id_pacjenta, v_data_godzina, 0.00);
		
		-- wylosowanie liczby zabiegow jaka dodac do wizyty
		SET v_liczba_zabiegow = fn_losuj_liczbe(1, 3);
		-- pobranie id_wizyty, czyli klucza glownego wczesniej wstawionej wizyty za pomoc¹ wartoœæci zmiennej @@identity, któr¹ ustawia mechanizm autoinkrementacji
		SET v_id_wizyty = @@IDENTITY;
		
		-- pêtla wykonuj¹ca siê tyle razy, ile wynosi wartoœæ zmiennej v_liczba_zabiegow
		WHILE (v_liczba_zabiegow > 0) LOOP
			-- wywo³anie procedury dodaj¹cej zabieg do wizyty o okreœlonym id_wizyty
			CALL pr_dodaj_zabieg_do_wizyty(v_id_wizyty);
			
			-- zmniejszenie zmiennej odpowiedzialnej za odpowiednia liczbe iteracji pêtli
			SET v_liczba_zabiegow = v_liczba_zabiegow - 1;
		END LOOP;
	END IF;
END;

CREATE OR REPLACE PROCEDURE pr_generowanie_transakcji()
BEGIN
	-- wywolanie procedury dodawania 1 wizyty dla obecnego dnia
	CALL pr_dodaj_wizyty(current date, current date, 1);
	
	-- odswiezenie widokow zmaterializowanych
	REFRESH MATERIALIZED VIEW Zyski_ze_stycznia;
	REFRESH MATERIALIZED VIEW Zyski_z_lutego;
	REFRESH MATERIALIZED VIEW Liczba_wykonanych_uslug_w_2016;
END;

-- wyzwalacz wywo³ywany przed dodaniem rekordu do tabeli Zabieg
-- odpowiedzialny za wype³nienie ceny zabiegu cen¹ us³ugi
CREATE OR REPLACE TRIGGER tr_BEF_INS_zabieg
BEFORE INSERT ON Zabieg
REFERENCING NEW AS new_rec
FOR EACH ROW
BEGIN
	DECLARE v_cena_uslugi FLOAT;
	
	-- pobranie ceny tylko jezeli przy dodaniu nie sprecyzowano
	IF NOT (new_rec.cena_wykonania > 0) THEN		
		-- pobranie ceny uslugi do zmiennej v_cena_uslugi dla uslugi o id rownym polu id_uslugi ze struktury new_rec
		SELECT cena INTO v_cena_uslugi FROM Usluga WHERE id_uslugi = new_rec.id_uslugi;
		
		SET new_rec.cena_wykonania = v_cena_uslugi;
	END IF;
END;

-- wyzwalacz wywo³ywany po dodaniu rekordu do tabeli Zabieg
-- odpowiedzialny za zaktualizowanie wartosci Wizyty
CREATE OR REPLACE TRIGGER tr_AFT_INS_zabieg
AFTER INSERT ON Zabieg
REFERENCING NEW AS new_rec
FOR EACH ROW
BEGIN
	UPDATE Wizyta
		SET wartosc = (SELECT SUM(cena_wykonania) FROM Zabieg WHERE id_wizyty = new_rec.id_wizyty)
		WHERE id_wizyty = new_rec.id_wizyty;
END;

-- wyzwalacz wywo³ywany przed zaktualizowaniem rekordu tabeli Zabieg
-- odpowiedzialny za wype³nienie ceny zabiegu cen¹ us³ugi
CREATE OR REPLACE TRIGGER tr_BEF_UPD_zabieg
BEFORE UPDATE ON Zabieg
REFERENCING OLD AS old_rec NEW AS new_rec
FOR EACH ROW
BEGIN
	DECLARE v_cena_uslugi FLOAT;
	
	-- sprawdzenie czy zmienila sie usluga danego zabiegu
	IF (old_rec.id_uslugi != new_rec.id_uslugi) THEN		
		-- jezeli tak to pobranie ceny uslugi do zmiennej v_cena_uslugi dla uslugi o id rownym polu id_uslugi ze struktury new_rec
		SELECT cena INTO v_cena_uslugi FROM Usluga WHERE id_uslugi = new_rec.id_uslugi;
		
		-- zmiana ceny wykonania
		SET new_rec.cena_wykonania = v_cena_uslugi;
	END IF;	
END;

-- wyzwalacz wywo³ywany po zaktualizowaniu rekordu tabeli Zabieg
-- odpowiedzialny za zaktualizowanie wartosci Wizyty
CREATE OR REPLACE TRIGGER tr_AFT_UPD_zabieg
AFTER UPDATE ON Zabieg
REFERENCING OLD AS old_rec NEW AS new_rec
FOR EACH ROW
BEGIN
	-- zaktualizowanie wartosci wizyty jezeli zmienila sie cena
	IF (old_rec.cena_wykonania != new_rec.cena_wykonania) THEN
		UPDATE Wizyta
			SET wartosc = (SELECT SUM(cena_wykonania) FROM Zabieg WHERE id_wizyty = new_rec.id_wizyty)
			WHERE id_wizyty = new_rec.id_wizyty;
	END IF;
END;

-- wyzwalacz wywo³ywany po usuniêciu rekordu z tabeli Zabieg
-- odpowiedzialny za zaktualizowanie wartosci Wizyty
CREATE OR REPLACE TRIGGER tr_AFT_DEL_zabieg
AFTER DELETE ON Zabieg
REFERENCING OLD AS old_rec
FOR EACH ROW
BEGIN
	DECLARE v_wartosc FLOAT;
	
	SET v_wartosc = 0;
	
	-- sprawdzenie czy liczba zabiegow dla danej wizyty jest wieksza od 0
	IF (SELECT COUNT(*) FROM Zabieg WHERE id_wizyty = old_rec.id_wizyty) > 0 THEN
		-- jezeli tak to pobranie sumy cen wykonania zabiegow danej wizyty
		SELECT SUM(cena_wykonania) INTO v_wartosc FROM Zabieg WHERE id_wizyty = old_rec.id_wizyty;
	END IF;
	
	-- zaktualizowanie kolejnosci (wszystko o kolejnosci dalszej niz usuwane wskakuje miejsce wyzej)
	UPDATE Zabieg SET kolejnosc = (kolejnosc - 1) WHERE id_wizyty = old_rec.id_wizyty AND kolejnosc > old_rec.kolejnosc;
	
	-- zaktualizowanie wartosci
	UPDATE Wizyta
		SET wartosc = v_wartosc
		WHERE id_wizyty = old_rec.id_wizyty;
END;

-- wyzwalacz wywo³ywany po usuniêciu rekordu z tabeli Wizyta
-- odpowiedzialny za usuwanie zabiegow danej wizyty jezeli usuwamy wizyte
CREATE OR REPLACE TRIGGER tr_AFT_DEL_wizyta
AFTER DELETE ON Wizyta
REFERENCING OLD AS old_rec
FOR EACH ROW
BEGIN
	DELETE FROM Zabieg WHERE id_wizyty = old_rec.id_wizyty;
END;

-- widok pokazujace zestawienie dzisiejszych wizyt (godzina, imie i nazwisko pacjenta, lista zabiegow, wartosc wizyty)
CREATE OR REPLACE VIEW Wizyty_dzisiaj AS
	SELECT DATEFORMAT(w.data_godzina, 'HH:NN') AS [Godzina], p.imie ||' '|| p.nazwisko AS 'Pacjent', LIST(u.nazwa, ', ') AS [Zabiegi], ROUND(w.wartosc, 2) AS [Wartosc]
	FROM Wizyta AS w
	LEFT JOIN Pacjent AS p ON (p.id_pacjenta = w.id_pacjenta)
	JOIN Zabieg AS z ON (z.id_wizyty = w.id_wizyty)
	JOIN Usluga AS u ON (u.id_uslugi = z.id_uslugi)
	WHERE DATE(w.data_godzina) = DATE(CURRENT DATE)
	GROUP BY [Godzina], [Pacjent], [Wartosc]
	ORDER BY [Godzina] ASC;

-- widok pokazujacy zestawienie dzisiejszych wizyt z podsumowaniem ich wartosci
CREATE OR REPLACE VIEW Wizyty_dzisiaj_z_podsumowaniem AS
	SELECT * FROM Wizyty_dzisiaj
	UNION
	SELECT null, null, 'Razem', (SELECT ROUND(SUM(w2.wartosc), 2) FROM Wizyta AS w2 WHERE DATE(w2.data_godzina) = DATE(CURRENT DATE));

-- widok pokazujacy liczbe zajetych terminow na nastepne 7 dni
CREATE OR REPLACE VIEW Liczba_zajetych_terminow_na_nastepne_7_dni AS
	SELECT DATEFORMAT(data_godzina, 'Mmmmmmmmmmm') AS [Miesiac], DATEFORMAT(data_godzina, 'dd') AS [Dzien], 
    COUNT(*) AS [Liczba zajetych terminow],
    (CASE
        WHEN (15 - COUNT(*) > 0) THEN (15 - COUNT(*))
        ELSE 0
    END) AS [Liczba wolnych terminow]
    FROM Wizyta
    WHERE DATE(data_godzina) > DATE(current date) AND DATE(data_godzina) <= DATE(current date) + 7
    GROUP BY [Miesiac], [Dzien];

-- widok zmaterializowany ukazujacy liczbe uslug wykonanych w 2016r. z podzialem na miesiace
CREATE MATERIALIZED VIEW Liczba_wykonanych_uslug_w_2016 AS
	SELECT DATEFORMAT(w.data_godzina, 'Mmmmmmmmmmm') AS [Miesiac], u.nazwa AS [Nazwa uslugi], COUNT(*) as [Liczba wykonanych zabiegow]
	FROM Zabieg AS z
	LEFT JOIN Wizyta AS w ON (w.id_wizyty = z.id_wizyty)
	LEFT JOIN Usluga AS u ON (u.id_uslugi = z.id_uslugi)
	WHERE DATEFORMAT(w.data_godzina, 'YYYY') = '2016'
	GROUP BY [Miesiac], [Nazwa uslugi]
    ORDER BY DATE([Miesiac]) ASC, [Nazwa uslugi] ASC;
	
-- widok zmaterializowany pokazujacy dzienny zysk dzienny z liczba wizyt ze stycznia
CREATE MATERIALIZED VIEW Zyski_ze_stycznia AS
	SELECT DATEFORMAT(data_godzina, 'Mmmmmmmmmmm') AS [Miesiac], DATEFORMAT(data_godzina, 'dd') AS [Dzien], COUNT(id_wizyty) AS [Liczba wizyt], ROUND(SUM(wartosc), 2) as [Zysk]
	FROM Wizyta
	WHERE DATE(data_godzina) >= DATE('2016-01-01') AND DATE(data_godzina) < DATE('2016-02-01')
	GROUP BY [Miesiac], [Dzien]
	UNION
	SELECT null, 'Razem', null, (SELECT ROUND(SUM(w2.wartosc), 2) FROM Wizyta AS w2)
	ORDER BY [Dzien] ASC;

-- widok zmaterializowany pokazujacy dzienny zysk dzienny z liczba wizyt z lutego
CREATE MATERIALIZED VIEW Zyski_z_lutego AS
	SELECT DATEFORMAT(data_godzina, 'Mmmmmmmmmmm') AS [Miesiac], DATEFORMAT(data_godzina, 'dd') AS [Dzien], COUNT(id_wizyty) AS [Liczba wizyt], ROUND(SUM(wartosc), 2) as [Zysk]
	FROM Wizyta
	WHERE DATE(data_godzina) >= DATE('2016-02-01') AND DATE(data_godzina) < DATE('2016-03-01')
	GROUP BY [Miesiac], [Dzien]
	UNION
	SELECT null, 'Razem', null, (SELECT ROUND(SUM(w2.wartosc), 2) FROM Wizyta AS w2)
	ORDER BY [Dzien] ASC;
	
--- zaimportowanie danych s³ownikowych
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(1,'Jan','Kowalski');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(2,'Adam','Abacki');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(3,'Aldona','Trêtowska');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(4,'Adam','Borewicz');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(5,'Marcin','Mieczkowski');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(6,'Adrian','Kimowicz');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(7,'Jaros³aw','Kaniewski');
INSERT INTO Polecajacy (id_polecajacego,imie,nazwisko) VALUES(8,'Damian','Cichecki');

INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(1,'masa¿');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(2,'ultradŸwiêki');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(3,'laser');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(4,'pr¹dy diadynamiczne');
INSERT INTO TypUslugi (id_typuuslugi,nazwa) VALUES(5,'drena¿');

INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(1,'Daria','Kicaj','K','al. Jana Paw³a III','23a',5,'01-100','Warszawa','2016-01-28',1);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(2,'Alfred','Tragarz','M','pl. Konstytucji','1',NULL,'04-839','Œwinoujœcie','2016-01-28',2);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(3,'Konstantyn','Jeziorny','M','ul. Zambrowska','2',NULL,'64-839','Brzegi dolne','2016-01-28',3);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(4,'Agnieszka','D¹browska','K','ul. Podutopia','9b',2,'23-221','Brok','2016-01-28',4);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(5,'Dominika','Wojcicka','K','ul. Kwiatowa','12',5,'99-999','Ma³kinia Dolna','2016-01-28',5);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(6,'Micha³','Konieczko','M','ul. Stra¿nicza','15',NULL,'89-432','Gdynia','2016-01-28',6);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(7,'Janina','Tvnowska','K','ul. Woronicza','1',NULL,'13-144','Sopot','2016-01-28',7);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(8,'Jaros³awa','Kaczyñska','K','ul. Na wspólnej','15',290,'01-100','Kraków','2016-01-28',8);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(9,'Lila','Hozier','K','al. Youtubea','6p',NULL,'65-064','Nibylandia','2016-01-28',5);
INSERT INTO Pacjent (id_pacjenta,imie,nazwisko,plec,ulica,budynek,nr_lokalu,kod_pocztowy,miejscowosc,data_dodania,id_polecajacego) VALUES(10,'Iwona','Górska','K','pl. Trzech krzy¿y','11',2,'11-233','Miñsk Mazowiecki','2016-01-28',4);



INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(1,'Masa¿ relaksacyjny',19.98,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(2,'Masa¿ leczniczy',29.98,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(3,'Masa¿ limfatyczny',24.98,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(4,'Masa¿ gor¹cymi kamieniami',20.0,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(5,'Masa¿ gor¹c¹ czekol¹d¹',45.0,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(6,'Masa¿ sportowy',15.0,1);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(7,'Rozbijanie z³ogów',80.0,2);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(8,'Jonoforeza z NaCL',30.0,4);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(9,'Leczenie nerwobóli',45.54,3);
INSERT INTO Usluga (id_uslugi,nazwa,cena,id_typuuslugi) VALUES(10,'Drena¿ limfatyczny',65.33,5);
commit;