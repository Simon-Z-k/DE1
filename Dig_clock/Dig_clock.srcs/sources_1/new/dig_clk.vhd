----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 11:10:12 AM
-- Design Name: 
-- Module Name: dig_clk - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dig_clk is
 Port ( clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pulse_1hz : in STD_LOGIC; 
        hours : out STD_LOGIC_VECTOR (4 downto 0);
        minutes : out STD_LOGIC_VECTOR (5 downto 0);
        seconds : out STD_LOGIC_VECTOR (5 downto 0));
end dig_clk;

architecture Behavioral of dig_clk is
    signal h : integer range 0 to 23 := 0;
    signal m : integer range 0 to 59 := 0;
    signal s : integer range 0 to 59 := 0;
begin

    process (clk,rst)
    begin
        if rst='1' then
            h <= 0;
            m <= 0;
            s <= 0;
            
        elsif (rising_edge(clk)) then
        
            if pulse_1hz = '1' then
                if s <= 59 then
                    s <= 0;
                    if m <= 59 then
                        m <= 0;
                        if h <= 23 then
                            h <= 0;
                        else h <= h + 1;
                        end if;
                    else m <= m + 1;
                    end if;
                else s <= s + 1;
                end if;
            end if;
        end if;                    

    end process;

    hours <= std_logic_vector (TO_UNSIGNED (h, 5));
    minutes <= std_logic_vector (TO_UNSIGNED (m, 6));
    seconds <= std_logic_vector (TO_UNSIGNED (s, 6));

end Behavioral;