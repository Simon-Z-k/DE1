-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 11 Apr 2025 09:08:43 GMT
-- Request id : cfwk-fed377c2-67f8dc1bc4cf1

library ieee;
use ieee.std_logic_1164.all;

entity tb_clock_enable is
end tb_clock_enable;

architecture tb of tb_clock_enable is

    component clock_enable
        port (clk       : in std_logic;
              rst       : in std_logic;
              pulse_1hz : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal pulse_1hz : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : clock_enable
    port map (clk       => clk,
              rst       => rst,
              pulse_1hz => pulse_1hz);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        
        rst <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_clock_enable of tb_clock_enable is
    for tb
    end for;
end cfg_tb_clock_enable;