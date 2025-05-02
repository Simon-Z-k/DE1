-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 11 Apr 2025 10:08:52 GMT
-- Request id : cfwk-fed377c2-67f8ea3433e49

library ieee;
use ieee.std_logic_1164.all;

entity tb_stopwatch is
end tb_stopwatch;

architecture tb of tb_stopwatch is

    component stopwatch
        port (clk        : in std_logic;
              rst        : in std_logic;
              pulse_1hz  : in std_logic;
              start      : in std_logic;
              stop       : in std_logic;
              zero       : in std_logic;
              hours      : out std_logic_vector (4 downto 0);
              minutes    : out std_logic_vector (5 downto 0);
              seconds    : out std_logic_vector (5 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal pulse_1hz  : std_logic;
    signal start      : std_logic;
    signal stop       : std_logic;
    signal zero       : std_logic;
    signal hours      : std_logic_vector (4 downto 0);
    signal minutes    : std_logic_vector (5 downto 0);
    signal seconds    : std_logic_vector (5 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : stopwatch
    port map (clk        => clk,
              rst        => rst,
              pulse_1hz  => pulse_1hz,
              start      => start,
              stop       => stop,
              zero       => zero,
              hours      => hours,
              minutes    => minutes,
              seconds    => seconds);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
begin
    -- Po?áte?ní reset a nulování
    rst <= '1';
    pulse_1hz <= '0';
    start <= '0';
    stop <= '1';
    zero <= '1';
    wait for 20 ns;

    rst <= '0';
    zero <= '0';
    stop <= '0';

    -- Spušt?ní stopek
    wait for 20 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';

    -- Simulace 5 sekund stopek
    for i in 1 to 5 loop
        pulse_1hz <= '1';
        wait for 10 ns;
        pulse_1hz <= '0';
        wait for 90 ns;
    end loop;

    -- Zastavení
    stop <= '1';
    wait for 50 ns;
    stop <= '0'; -- p?ipraveno na nové spušt?ní

    -- Druhé spušt?ní
    start <= '1';
    wait for 10 ns;
    start <= '0';

    -- Simulace dalších 3 sekund
    for i in 1 to 3 loop
        pulse_1hz <= '1';
        wait for 10 ns;
        pulse_1hz <= '0';
        wait for 90 ns;
    end loop;

    -- Druhé zastavení
    stop <= '1';
    wait for 50 ns;

    -- Konec simulace
    TbSimEnded <= '1';
    wait;
end process;

end tb;

configuration cfg_tb_stopwatch of tb_stopwatch is
    for tb
    end for;
end cfg_tb_stopwatch;