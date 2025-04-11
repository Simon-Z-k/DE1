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
              start_stop : in std_logic;
              zero       : in std_logic;
              hours      : out std_logic_vector (4 downto 0);
              minutes    : out std_logic_vector (5 downto 0);
              seconds    : out std_logic_vector (5 downto 0));
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal pulse_1hz  : std_logic;
    signal start_stop : std_logic;
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
              start_stop => start_stop,
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
        -- ***EDIT*** Adapt initialization as needed
        rst <= '1';
        pulse_1hz <= '0';
        start_stop <= '0';
        zero <= '1';
        wait for 10 ns;
        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        zero <= '0';
        rst <= '0';
        
        wait for 10 ns;
        
        pulse_1hz <= '1';
        wait for 10 ns;
        start_stop <= '1';
        wait for 10 ns;
        start_stop <= '0';
        wait for 5 ns;
        
        pulse_1hz <= '0';
        wait for 10 ns;
        pulse_1hz <= '1';
        wait for 10 ns;
        
        start_stop <= '0';
        wait for 100 ns;
        zero <= '1';
        
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_stopwatch of tb_stopwatch is
    for tb
    end for;
end cfg_tb_stopwatch;