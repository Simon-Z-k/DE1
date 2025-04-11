----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 12:31:25 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

component  clock_enable is
    generic (
        N_PERIODS : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;

component dig_clk is
    Port ( clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pulse_1hz : in STD_LOGIC; 
        hours : out STD_LOGIC_VECTOR (4 downto 0);
        minutes : out STD_LOGIC_VECTOR (5 downto 0);
        seconds : out STD_LOGIC_VECTOR (5 downto 0));
end component;

component alarm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           set : in STD_LOGIC;
           sw_h : in STD_LOGIC_VECTOR (4 downto 0);
           sw_m : in STD_LOGIC_VECTOR (5 downto 0);
           sw_s : in STD_LOGIC_VECTOR (5 downto 0);
           current_h : in STD_LOGIC_VECTOR (4 downto 0);
           current_m : in STD_LOGIC_VECTOR (5 downto 0);
           current_s : in STD_LOGIC_VECTOR (5 downto 0);
           alarm_on : out STD_LOGIC := '0');
end component;

component stopwatch is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse_1hz : in STD_LOGIC;
           start_stop : in STD_LOGIC;
           zero : in STD_LOGIC; 
           hours : out STD_LOGIC_VECTOR (4 downto 0);
           minutes : out STD_LOGIC_VECTOR (5 downto 0);
           seconds : out STD_LOGIC_VECTOR (5 downto 0));
end component;

constant C_NBITS : integer := 4;
constant C_NPERIODS : integer := 100000000;

signal sig_en_1s : std_logic;
signal sig_count : std_logic_vector(C_NBITS-1 downto 0);

begin

CLKEN : clock_enable
    generic map(
    N_PERIODS=>C_NPERIODS
    )
    port map(
        clk => CLK100MHZ,
        rst => BTNC,
        pulse => sig_en_1s
    );
    
DGCLK : dig_clk

    generic map(
        N_BITS=>C_NBITS
        )
        port map(
            clk => CLK100MHZ,
            rst => BTNC,
            en => sig_en_250ms,
            count => sig_count
        );
        
        DP <='1';
        AN <= b"01111111";
end Behavioral;