----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 12:04:52 PM
-- Design Name: 
-- Module Name: alarm - Behavioral
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

entity alarm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           set : in STD_LOGIC;
           sw_h : in STD_LOGIC_VECTOR (4 downto 0);
           sw_m : in STD_LOGIC_VECTOR (5 downto 0);
           sw_s : in STD_LOGIC_VECTOR (5 downto 0);
           current_h : in STD_LOGIC_VECTOR (4 downto 0);
           current_m : in STD_LOGIC_VECTOR (5 downto 0);
           current_s : in STD_LOGIC_VECTOR (5 downto 0);
           alarm : out STD_LOGIC);
end alarm;

architecture Behavioral of alarm is

    signal alarm_h : std_logic_vector(4 downto 0) := (others => '0');
    signal alarm_m : std_logic_vector(5 downto 0) := (others => '0');
    signal alarm_s : std_logic_vector(5 downto 0) := (others => '0');

begin

    process(clk,rst)
        begin
            if rst = '1' then
                alarm_h <= (others => '0');
                alarm_m <= (others => '0');
                alarm_s <= (others => '0');
            elsif rising_edge (clk) then
                if set = '1' then
                    alarm_h <= sw_h;
                    alarm_m <= sw_m;
                    alarm_s <= sw_s;
                end if;
            end if;
    end process;          
    
    process (current_h,current_m,current_s,alarm_h,alarm_m,alarm_s)
        begin
            if (current_h = alarm_h AND current_m = alarm_m AND current_s = alarm_s) then
                alarm <= '1';
            else
                alarm <= '0';
            end if;
    end process;
    
end Behavioral;
