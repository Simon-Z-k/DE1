-- Top-level VHDL for Nexys A7-50T: Digital Clock with Alarm and Stopwatch -- Integrates clock, alarm, stopwatch, and 7-segment display driver with BCD mapping library IEEE; use IEEE.STD_LOGIC_1164.ALL; use IEEE.NUMERIC_STD.ALL;

entity top_level is Port ( CLK100MHZ  : in  STD_LOGIC;                -- 100 MHz onboard clock BTNC       : in  STD_LOGIC;                -- Center pushbutton (active high reset) BTNL       : in  STD_LOGIC;                -- Left pushbutton (stopwatch start/stop) BTNR       : in  STD_LOGIC;                -- Right pushbutton (stopwatch reset) BTND       : in  STD_LOGIC;                -- Down pushbutton (alarm set) SW         : in  STD_LOGIC_VECTOR(15 downto 0); -- Slide switches for alarm time (HH:MM:00) CA, CB, CC, CD, CE, CF, CG, DP : out STD_LOGIC; -- 7-seg segment outputs (a..g, dp) AN         : out STD_LOGIC_VECTOR(7 downto 0)   -- 7-seg digit enables (active low) ); end top_level;

architecture Behavioral of top_level is -- Clock divider parameter (100 MHz -> 1 Hz) constant C_1HZ_DIV : integer := 100_000_000;

-- Internal reset and tick signal
signal rst       : STD_LOGIC := '0';
signal pulse_1hz : STD_LOGIC;

-- Raw time outputs (binary)
signal clk_h_bin, clk_m_bin, clk_s_bin : unsigned(5 downto 0);
signal swatch_h_bin, swatch_m_bin, swatch_s_bin : unsigned(5 downto 0);
signal alarm_on : STD_LOGIC;

-- BCD digits for display (6 digits: H tens, H units, M tens, M units, S tens, S units)
signal h10, h1, m10, m1, s10, s1 : unsigned(3 downto 0);
signal disp_data : STD_LOGIC_VECTOR(47 downto 0);

begin -- Reset sync rst <= BTNC;

-- Clock divider: produce 1 Hz pulse
u_clk_en_1hz: entity work.clock_enable
    generic map ( MAX => C_1HZ_DIV )
    port map (
        clk       => CLK100MHZ,
        rst       => rst,
        pulse_1hz => pulse_1hz
    );

-- Digital clock: updates binary time
u_dig_clk: entity work.dig_clk
    port map (
        clk       => CLK100MHZ,
        rst       => rst,
        pulse_1hz => pulse_1hz,
        hours     => std_logic_vector(clk_h_bin(5 downto 1)),
        minutes   => std_logic_vector(clk_m_bin),
        seconds   => std_logic_vector(clk_s_bin)
    );

-- Alarm set via switches
u_alarm: entity work.alarm
    port map (
        clk       => CLK100MHZ,
        rst       => rst,
        set       => BTND,
        sw_h      => std_logic_vector("00" & SW(15 downto 11)),
        sw_m      => SW(10 downto 5),
        sw_s      => std_logic_vector("000" & SW(4 downto 0)),
        current_h => std_logic_vector(clk_h_bin(5 downto 1)),
        current_m => std_logic_vector(clk_m_bin),
        current_s => std_logic_vector(clk_s_bin),
        alarm_on  => alarm_on
    );

-- Stopwatch
u_stopwatch: entity work.stopwatch
    port map (
        clk         => CLK100MHZ,
        rst         => rst,
        pulse_1hz   => pulse_1hz,
        start_stop  => BTNL,
        zero        => BTNR,
        hours       => std_logic_vector(swatch_h_bin(5 downto 1)),
        minutes     => std_logic_vector(swatch_m_bin),
        seconds     => std_logic_vector(swatch_s_bin)
    );

-- Binary to BCD conversion for each time element
conv_proc: process(clk100mhz)
begin
    if rising_edge(CLK100MHZ) then
        if rst = '1' then
            h10 <= (others => '0'); h1 <= (others => '0');
            m10 <= (others => '0'); m1 <= (others => '0');
            s10 <= (others => '0'); s1 <= (others => '0');
        else
            -- Hours
            h10 <= to_unsigned(to_integer(clk_h_bin) / 10, 4);
            h1  <= to_unsigned(to_integer(clk_h_bin) mod 10, 4);
            -- Minutes
            m10 <= to_unsigned(to_integer(clk_m_bin) / 10, 4);
            m1  <= to_unsigned(to_integer(clk_m_bin) mod 10, 4);
            -- Seconds
            s10 <= to_unsigned(to_integer(clk_s_bin) / 10, 4);
            s1  <= to_unsigned(to_integer(clk_s_bin) mod 10, 4);
        end if;
    end if;
end process;

-- Pack BCD digits into disp_data: [H10,H1,M10,M1,S10,S1] each 4 bits
disp_data <= std_logic_vector(h10) & std_logic_vector(h1)
           & std_logic_vector(m10) & std_logic_vector(m1)
           & std_logic_vector(s10) & std_logic_vector(s1);

-- 7-segment display driver
u_seg7: seg7_driver
    port map (
        clk    => CLK100MHZ,
        rst    => rst,
        digits => disp_data,
        seg    => (CA, CB, CC, CD, CE, CF, CG),
        anode  => AN(5 downto 0),
        dp     => DP
    );

-- Disable unused upper two digits (active low)
AN(7 downto 6) <= "11";

end Behavioral;

