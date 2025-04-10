----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2025 11:49:15 AM
-- Design Name: 
-- Module Name: clock_enable - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_enable is
 generic (
        MAX : integer := 100000000
    );
 Port ( clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pulse_1hz : out STD_LOGIC);
end clock_enable;

architecture Behavioral of clock_enable is
    signal sig_count : integer range 0 to MAX := 0;
    signal pulse : STD_LOGIC := '0';
begin
    --! Count the number of clock pulses from zero to MAX.
    p_clk_enable : process (clk) is
    begin
    
        if rst='1' then
                sig_count <= 0;
                pulse <='0';
        -- Synchronous proces
        elsif (rising_edge(clk)) then
            -- if high-active reset then
                -- Clear integer counter
            if sig_count = MAX then
                sig_count <= 0;
                pulse <='1';

            -- elsif sig_count is less than MAX then
                -- Counting  
            else
                sig_count <= sig_count +1;
                pulse <='0';
            end if;
        end if;

    end process p_clk_enable;

    -- Generated pulse is always one clock long
    -- when sig_count = N_PERIODS-1
    pulse_1hz <= pulse;

end Behavioral;