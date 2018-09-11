/**************************************
* Kasowanie widokow klasycznych i zmaterializowanych
**************************************/
drop view Wizyty_dzisiaj;

drop view Wizyty_dzisiaj_z_podsumowaniem;

drop view Liczba_zajetych_terminow_na_nastepne_7_dni;

drop materialized view Zyski_ze_stycznia;

drop materialized view Zyski_z_lutego;

drop materialized view Liczba_wykonanych_uslug_w_2016;

/**************************************
* Kasowanie wiêzów integralnoœci
**************************************/
alter table Pacjent
	delete constraint Pacjent_Polecajacy_FK;
	
alter table Usluga
	delete constraint Usluga_TypUslugi_FK;
	
alter table Wizyta
	delete constraint Wizyta_Pacjent_FK;
	
alter table Zabieg
	delete constraint Zabieg_Usluga_FK;
	
alter table Zabieg
	delete constraint Zabieg_Wizyta_FK;
	
/**************************************
* Kasowanie tabel i perspektyw
**************************************/
drop table Pacjent;

drop table Polecajacy;

drop table TypUslugi;

drop table Usluga;

drop table Wizyta;

drop table Zabieg;

/**************************************
* Kasowanie funkcji i procedury w³asnej
**************************************/
drop function fn_losuj_liczbe;

drop function fn_losuj_pacjenta;

drop function fn_losuj_usluge;

drop procedure pr_dodaj_zabieg_do_wizyty;

drop procedure pr_dodaj_wizyty;

drop procedure pr_dodaj_wizyte;