-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 11 Apr 2025 09:28:54 GMT
-- Request id : cfwk-fed377c2-67f8e0d650d12

library ieee;
use ieee.std_logic_1164.all;

entity tb_alarm is
end tb_alarm;

architecture tb of tb_alarm is

    component alarm
        port (clk       : in std_logic;
              rst       : in std_logic;
              set       : in std_logic;
              sw_h      : in std_logic_vector (4 downto 0);
              sw_m      : in std_logic_vector (5 downto 0);
              sw_s      : in std_logic_vector (5 downto 0);
              current_h : in std_logic_vector (4 downto 0);
              current_m : in std_logic_vector (5 downto 0);
              current_s : in std_logic_vector (5 downto 0);
              alarm_on  : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal set       : std_logic;
    signal sw_h      : std_logic_vector (4 downto 0);
    signal sw_m      : std_logic_vector (5 downto 0);
    signal sw_s      : std_logic_vector (5 downto 0);
    signal current_h : std_logic_vector (4 downto 0);
    signal current_m : std_logic_vector (5 downto 0);
    signal current_s : std_logic_vector (5 downto 0);
    signal alarm_on  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : alarm
    port map (clk       => clk,
              rst       => rst,
              set       => set,
              sw_h      => sw_h,
              sw_m      => sw_m,
              sw_s      => sw_s,
              current_h => current_h,
              current_m => current_m,
              current_s => current_s,
              alarm_on  => alarm_on);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        rst <= '1';
        set <= '0';
        sw_h <= (others => '0');
        sw_m <= (others => '0');
        sw_s <= (others => '0');
        current_h <= (others => '0');
        current_m <= (others => '0');
        current_s <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        
        wait for 100 ns;
        
        rst <= '0';
        
        wait for 10 ns;
        current_h <= "00001";
        current_m <= "000001";
        current_s <= "000001";
        
        wait for 10 ns;
        
        sw_h <= "00001";
        sw_m <= "000001";
        sw_s <= "000001";
        
        wait for 10 ns;
        set <= '1';
        
        
        wait for 10 ns;
        current_h <= "00001";
        current_m <= "000001";
        current_s <= "000001";
        
        
     
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_alarm of tb_alarm is
    for tb
    end for;
end cfg_tb_alarm;