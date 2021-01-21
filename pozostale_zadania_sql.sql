
create table kontakty (
    kontakt_id int,
    klient_id int,
    pracownik_id int,
    status varchar2(100),
    kontakt_ts timestamp
);
------------------------------------------------------------------------------------------------------------------------------------------------------------

--zad.2. Zaproponuj zapytanie SQL zwracaj¹ce ostatni status ka¿dego klienta, z którym by³y co najmniej 3 próby kontaktu. Potraktuj podes³any plik jako tabelê.

with
ranking as (
    select 
        klient_id,
        status,
        kontakt_ts,
        row_number() over (partition by klient_id order by kontakt_ts desc) as rankk
    from kontakty
)
select 
    KLIENT_ID,
    status 
from ranking 
where rankk=1
and KLIENT_ID in (select KLIENT_ID from ranking where rankk=3);

--Komentarz: Do sprawdzenia ostatniego statusu klienta zastosowalam funckje row_number(), ustalajac, ze partycja jest klient, natomiast polem po ktorym sortujemy jest kontakt_ts. 
--Funkcja ta jest odpowiednia do tego typu zadañ, gdyz zachowuja ciaglosc w numeracji rekordow. 
--Dodatkowo zastosowalam sortowanie malejace, aby nie bylo potrzeby wybierania "maksa" z liczb w obrebie jednego klienta.
--W zapytaniu skorzystalam z CTE aby nie bylo koniecznosci tworzenia tabeli tymczasowej.


-----------------------------------------------------------------------------------------------------------------------------------------------------------
--zad. 3. Zaproponuj zapytanie SQL, które zwróci dane do faktu f_docieralnosc pokazuj¹cego globaln¹ docieralnoœæ do klientów. Ma byæ on pogrupowany po dacie. Jego struktura wygl¹da nastêpuj¹co: 
--data | sukcesy | utraty | do_ponowienia | zainteresowani_utraty | niezainteresowani_sukcesy
--Fakt zawiera 1 wymiar:
--data (nie timestamp!)
--	oraz miary:
--sukcesy - liczba klientów, których ostatnim statusem jest “zainteresowany”
--utraty - liczba klientów, których ostatnim statusem jest “niezainteresowany”
--do_ponowienia - liczba klientów, których ostatni status to “poczta_g³osowa” lub “nie_ma_w_domu”
--(Bonus) zainteresowani_utraty - liczba klientów, których ostatnim statusem jest “niezainteresowany”, a poprzednio wyst¹pi³ status “zainteresowany”
--(Bonus) niezainteresowani_sukcesy - liczba klientów, których ostatnim statusem jest “zainteresowany”, a poprzednio wyst¹pi³ status “niezainteresowany”


with
ranking as (
    select 
        klient_id,
        status,
        kontakt_ts,
        row_number() over (partition by klient_id order by kontakt_ts desc) as rankk
    from kontakty
),
poprzednie_statusy as (
    select 
        klient_id,
        status,
        rankk,
        kontakt_ts,
        cast(kontakt_ts as DATE) as kontakt,
        lead(status) over (partition by klient_id order by kontakt_ts desc) as poprzedni_status
    from ranking
)
select 
    kontakt,
    sum(case when rankk=1 and status='zainteresowany' then 1 else 0 end) as sukcesy,
    sum(case when rankk=1 and status='niezainteresowany' then 1 else 0 end) as utraty,
    sum(case when rankk=1 and (status='poczta_glosowa' or status='nie_ma_w_domu') then 1 else 0 end) as do_ponowienia,
    sum(case when rankk=1 and status='niezainteresowany' and poprzedni_status='zainteresowany' then 1 else 0 end) as zainteresowani_utraty,
    sum(case when rankk=1 and (status='zainteresowany' and poprzedni_status='niezainteresowany') then 1 else 0 end) as niezainteresowani_sukcesy
from poprzednie_statusy   --jeœli nie ma potrzeby aby byly widoczne dni bez jakichkolwiek zmian w docieralnoœci to nale¿aoby "wyciagnac" warunek z case'a "rankk=1" do WHERE 
group by kontakt
order by kontakt
;

--Komentarz: Podobnie jak powyzej zastosowalam WITH, dla tak malej ilosci danych pamiec podreczna poradzi sobie z przeliczeniami. 
--W CTE ranking analogicznie jak w porzednim zadaniu numeruje w kolejnosci wszystkie kontakty do klienta w kolejnosci malejacej.
--Nastepnie do kazdego rekordu dopisuje kolumne z nazwa statusu nastepujacego (partycja jest klient) oraz zamieniam timestampy na daty bez czasu.
--Majac tak przygotowane w latwy sposob jestem w stanie wykonac przeliczenia docieralnosci poprzez zastosowanie funkcji agregujacych wraz z polaczeniem instrukcji CASE.
--Nie znalam dokladnych zalozen jak powinna wygladac tabela koncowa wiec zalozylam ze dni bez zmian w statusach docieralnosci powinny rowniez sie w niej znalezc, mozna w ten sposob dodatkowo 
--zauwazyc w ktorych dniach dzialalo call center


