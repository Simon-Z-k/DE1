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
use IEEE.NUMERIC_STD.ALL;

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
           SW : out STD_LOGIC_VECTOR (15 downto 0);
           BTNC : in STD_LOGIC; --rst
           BTNL : in STD_LOGIC; --start
           BTNR : in STD_LOGIC; --reset pro stopwatch
           BTND : in STD_LOGIC --set
           );
end top_level;

architecture Behavioral of top_level is

    -- Komponenty
    component clock_enable
        generic (
            MAX : integer := 100000000
        );
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pulse_1hz : out STD_LOGIC
        );
    end component;

    component dig_clk
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pulse_1hz : in STD_LOGIC; 
            hours : out STD_LOGIC_VECTOR (4 downto 0);
            minutes : out STD_LOGIC_VECTOR (5 downto 0);
            seconds : out STD_LOGIC_VECTOR (5 downto 0)
        );
    end component;

    component alarm
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            set : in STD_LOGIC;
            sw_h : in STD_LOGIC_VECTOR (4 downto 0);
            sw_m : in STD_LOGIC_VECTOR (5 downto 0);
            sw_s : in STD_LOGIC_VECTOR (5 downto 0);
            current_h : in STD_LOGIC_VECTOR (4 downto 0);
            current_m : in STD_LOGIC_VECTOR (5 downto 0);
            current_s : in STD_LOGIC_VECTOR (5 downto 0);
            alarm_on : out STD_LOGIC
        );
    end component;

    component stopwatch
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pulse_1hz : in STD_LOGIC;
            start_stop : in STD_LOGIC;
            zero : in STD_LOGIC;
            hours : out STD_LOGIC_VECTOR (4 downto 0);
            minutes : out STD_LOGIC_VECTOR (5 downto 0);
            seconds : out STD_LOGIC_VECTOR (5 downto 0)
        );
    end component;

    -- Signály pro propojení
    signal sig_en_1s : std_logic;
    signal h_bin, sw_h, sw_h_stop : std_logic_vector(4 downto 0);
    signal m_bin, sw_m, sw_m_stop : std_logic_vector(5 downto 0);
    signal s_bin, sw_s, sw_s_stop : std_logic_vector(5 downto 0);
    signal alarm_set : std_logic := '0';
    signal alarm_on : std_logic;

begin

    -- Instance
    CLKEN : clock_enable
        generic map (
            MAX => 100000000
        )
        port map (
            clk => CLK100MHZ,
            rst => BTNC,
            pulse_1hz => sig_en_1s
        );

    -- Instance dig_clk (hodiny)
    DGCLK : dig_clk
        port map (
            clk => CLK100MHZ,
            rst => BTNC,
            pulse_1hz => sig_en_1s,
            hours => h_bin,
            minutes => m_bin,
            seconds => s_bin
        );

    -- Instance alarmu
    ALM : alarm
        port map (
            clk => CLK100MHZ,
            rst => BTNC,
            set => alarm_set,
            sw_h => sw_h,
            sw_m => sw_m,
            sw_s => sw_s,
            current_h => h_bin,
            current_m => m_bin,
            current_s => s_bin,
            alarm_on => alarm_on
        );

    -- Instance stopek
    STPWTCH : stopwatch
        port map (
            clk => CLK100MHZ,
            rst => BTNC,
            pulse_1hz => sig_en_1s,
            start_stop => '0', -- doplnit z tlačítka
            zero => '0',       -- doplnit z tlačítka
            hours => sw_h_stop,
            minutes => sw_m_stop,
            seconds => sw_s_stop
        );

    -- Výstupy displeje (zatím statické)
    DP <= '1';
    AN <= "01111111";

end Behavioral;
