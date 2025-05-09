# DE1 - Digitální hodiny pomocí Nexys A7
## Členové týmu:
Veronika Válková (implementace hlavních procesů)

Šimon Zvončák (simulace, testování a readme)

## Úvod:
Projekt implementuje funkční digitální hodiny na vývojové desce Nexys A7 pomocí jazyka VHDL. Cílem bylo vytvořit systém, který zobrazuje čas v hodinách, minutách a sekundách na 7segmentovém displeji s možností nastavování času pomocí tlačítek.

Jádrem systému je několik modulů, které zahrnují generování hodinového pulzu, řízení multiplexního zobrazení, a úpravy hodinového signálu. Doplňkově byly vytvořeny i moduly pro stopky a alarm, které však kvůli problémům s integrací nefungují správně. 

Projekt byl rozdělen do několika komponent, které byly jednotlivě navrženy, otestovány a simulovány. Výsledná aplikace ukazuje plynulý běh času v reálném čase, přičemž podporuje změnu hodin a minut.

### Hlavní přínosy projektu:

-Generování sekundové signálu

-Implementace digitálních hodin v jazyce VHDL.

-Řízení 8místného 7segmentového displeje pomocí multiplexingu.

-Uživatelské rozhraní pro nastavování času pomocí tlačítek.




# Popis zdrojových souborů
## clock_enable.vhd
Modul slouží jako dělič frekvence, který z hlavního systémového hodinového signálu (100 MHz) generuje přesný 1Hz impulz. Využívá čítač, který po dosažení určité hodnoty vygeneruje logickou „1“ na jeden takt – výsledkem je signál __enable_1hz__, používaný pro sekvenční jednotky v projektu jako spouštěcí impulz každou sekundu.

## dig_clk.vhd
Modul digitálních hodin, který přebírá sekundové impulzy z clock_enable. Obsahuje čítače pro sekundy, minuty a hodiny. Počítání se děje při náběžné hraně __clk__. Také je zde možnost resetu (__rst__) nebo manuálního nastavení hodin a minut pomocí vstupů __new_m, new_h__ a tlačítka __set__.

## alarm.vhd (WIP)
Modul budíku, který umožňuje nastavit čas na buzení pomocí vstupů __*sw__ a __current__. Porovnává aktuální čas s nastaveným a aktivuje výstup __alarm_on__ při shodě.

*Původně se měl budík nastavovat binární kombinací switchů. Při řešení __top_level__ strukturu pak z toho sešlo, ale názvy zůstaly.

## stopwatch.vhd (WIP)
Obsahuje čítače sekund, minut a hodin, které se spouští signálem __start__, zastavují __stop__(rst tlačítko) a vynulují __zero__. Na rozdíl od __dig_clk.vhd__ se tento modul používá pro měření časových intervalů a nikoliv pro kontinuální čas.

(Fun fact: Původně jsme implementovali to, že start-stop proces bude jedno tlačítko. Naše ošetření toho, jestli další náběžná hrana bude start nebo stop ale vůbec nefungovalo, tak jsme od toho opustili.)

## seg7_driver.vhd
Multiplexní ovladač 7segmentového displeje. Pomocí vnitřního čítače (clock divider) přepíná jednotlivé anody (__AN__) a zobrazuje správné číslice hodin, minut a sekund na základě vstupů __h_bin, m_bin, s_bin__. Používá kódování pro společnou anodu.

## top_level.vhd
Zajišťuje propojení všech podsystémů – generuje hodinový impulz, počítá čas, zobrazuje ho na 7segmentovém displeji, a navíc připojuje stopky (__stopwatch.vhd__) a budík (__alarm.vhd__), které sice nejsou funkčně propojené, ale jsou připravené pro budoucí rozšíření. 


## Popis hardwarové implementace

![dig](https://github.com/user-attachments/assets/99275c0d-4656-4c4e-a16c-0a627c42846e)

Tlačítka na desce slouží pro ovládání stopek, inkrementaci času a reset:

DIP přepínače vybírají mode, nebo vybírají hodiny či minuty pro inkrementaci:

__sw[15,14]:__ 

"00" - normální hodiny

"01" - alarm

"10" - stopky

__sw[1,0]:__

"10" - inkrementace hodin

"11" - inkrementace minut

7segmentový displej je řízen multiplexně, každé číslo je zobrazeno postupně.

__RTL Analysis:__

![image](https://github.com/user-attachments/assets/4923ebaa-359b-483a-989d-7eebfa757fbe)

## Popis softwarového chování
Velmi hrubý náčrt schématu:

![final](https://github.com/user-attachments/assets/d5a7756d-7215-4bec-b9f1-c3130a99065f)

Ukázka __dig_clk__ kódu:

https://github.com/Simon-Z-k/DE1/blob/54196997aa7305548211da789c06215ad0468fcb/Dig_clock/Dig_clock.srcs/sources_1/new/dig_clk.vhd#L43

Pokus o debounce a inkrementace času v top_levelu:

https://github.com/Simon-Z-k/DE1/blob/54196997aa7305548211da789c06215ad0468fcb/Dig_clock/Dig_clock.srcs/sources_1/new/top_level.vhd#L186

vybírání režimů:

https://github.com/Simon-Z-k/DE1/blob/54196997aa7305548211da789c06215ad0468fcb/Dig_clock/Dig_clock.srcs/sources_1/new/top_level.vhd#L207

## Demonstrace komponent
### clock_enable
Generování 1 Hz pulzu z hlavního hodinového signálu:

https://github.com/user-attachments/assets/760020b1-2dba-4d91-a01e-1b701b613dd6

### dig_clk a seg7_driver
Ukázka ruční inkrementace času a správné multiplexného zobrazení číslic:

https://github.com/user-attachments/assets/04fd1368-b4a0-4bbd-996c-902be9fbe8d6

## Reference

-Digilent Nexys A7 Reference Manual: https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual

-VHDL Guide by Vhdlwhiz

-Online generátory testbenchů: https://vhdl.lapinoo.net

-Počítačové cvičení 5 - counter - https://github.com/tomas-fryza/vhdl-labs/tree/master/lab5-counter

-Schéma: https://www.drawio.com/

-ChatGPT

-https://vhdlguru.blogspot.com/2022/04/digital-clock-with-ability-to-set-time.html




