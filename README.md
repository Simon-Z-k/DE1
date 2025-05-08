# DE1 - Digitální hodiny pomocí Nexys A7
Členové týmu

Veronika Válková (implementace hlavních procesů)

Šimon Zvončák (simulace, testování a správa displeje)

Úvod
Tento projekt implementuje funkční digitální hodiny na vývojové desce Nexys A7 pomocí jazyka VHDL. Cílem bylo vytvořit systém, který zobrazuje čas v hodinách, minutách a sekundách na 7-segmentovém displeji s možností nastavování času pomocí tlačítek. Jádrem systému je několik modulů, které zahrnují generování hodinového pulzu, řízení multiplexního zobrazení, a nastavení času přes uživatelský vstup. Doplňkově byly vytvořeny i moduly pro stopky a alarm, které však nebyly kvůli problémům s integrací použity ve finální implementaci. Projekt byl rozdělen do několika komponent, které byly jednotlivě navrženy, otestovány a simulovány. Výsledná aplikace ukazuje plynulý běh času v reálném čase, přičemž podporuje změnu hodin a minut.

Hlavní přínosy projektu:

Generování sekundové signálu

Implementace digitálních hodin v jazyce VHDL.

Řízení 8místného 7segmentového displeje pomocí multiplexingu.

Uživatelské rozhraní pro nastavování času pomocí tlačítek.




Popis zdrojových souborů
clock_enable.vhd
Tento modul slouží jako dělič frekvence, který z hlavního systémového hodinového signálu (typicky 100 MHz) generuje přesný 1Hz impulz. Využívá čítač, který po dosažení určité hodnoty vygeneruje logickou „1“ na jeden takt – výsledkem je signál enable_1hz, používaný pro sekvenční jednotky v projektu jako spouštěcí impulz každou sekundu.

dig_clk.vhd
Digitální hodinový modul, který přebírá sekundové impulzy ze clock_enable. Obsahuje čítače pro sekundy, minuty a hodiny. Počítání se děje jen pokud je aktivní signál run_time. Také je zde možnost resetu (rst) nebo manuálního nastavení hodin a minut pomocí vstupů set_min, set_hour a přepínačů sw.

alarm.vhd
Modul budíku, který umožňuje nastavit čas buzení pomocí vstupů set_alarm_min a set_alarm_hour. Porovnává aktuální čas s nastaveným a aktivuje výstup alarm_on při shodě.

stopwatch.vhd
Obsahuje čítače sekund, minut a hodin, které se spouští signálem start, zastavují stop a vynulují zero. Na rozdíl od dig_clk.vhd se tento modul používá pro měření časových intervalů (stopky) a nikoliv pro kontinuální čas.

seg7_driver.vhd
Multiplexní ovladač 7segmentového displeje. Pomocí vnitřního čítače (clock divider) přepíná jednotlivé anody (AN) a zobrazuje správné číslice hodin, minut a sekund na základě vstupů h_bin, m_bin, s_bin. Používá kódování pro společnou anodu.

top_level.vhd
Vrcholová entita celého návrhu. Zajišťuje propojení všech podsystémů – generuje hodinový impulz, počítá čas, zobrazuje ho na 7segmentovém displeji, a navíc připojuje stopky (stopwatch.vhd) a budík (alarm.vhd), které sice nejsou funkčně propojené, ale jsou připravené pro budoucí rozšíření.


Popis hardwarové implementace
Top-level návrh systému:

Tlačítka na desce Nexys A7 slouží pro reset a nastavení času.

DIP přepínače vybírají, zda nastavujeme hodiny nebo minuty.

Ovládání zajišťuje FSM (jednoduchý řízení) – při stisknutí BTNU dojde k navýšení příslušné hodnoty.

7-segmentový displej je řízen multiplexně, každé číslo je zobrazeno postupně.

(Schématický obrázek doplníte zde, např. v PDF/A3)

Popis softwarového chování
Flow diagram pro nastavování času
SW[1:0] = "01": nastavování minut

SW[1:0] = "10": nastavování hodin

Tlačítko BTNU: zvýšení hodnoty dané složky času

V jiném režimu: běžný běh hodin, řízený pulzem 1 Hz

(Doplnit FSM/flowchart jako obrázek sem)

Simulace komponent
clock_enable – simulace
Simuluje generování 1 Hz pulzu z hlavního hodinového signálu.

dig_clk – simulace
Ukazuje inkrementaci času každou sekundu.

seg7_driver – simulace
Kontrola správného multiplexního zobrazení číslic.

Reference
Digilent Nexys A7 Reference Manual: https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual

VHDL Guide by Vhdlwhiz

Online generátory testbenchů: https://vhdl.lapinoo.net

Počítačové cvičení 5 - counter

Schéma: https://www.drawio.com/

ChatGPT

https://vhdlguru.blogspot.com/2022/04/digital-clock-with-ability-to-set-time.html




