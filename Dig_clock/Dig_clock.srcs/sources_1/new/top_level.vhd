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
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           BTNC : in STD_LOGIC; --rst
           BTNL : in STD_LOGIC; --start
           BTNR : in STD_LOGIC; --nulovani pro stopwatch
           BTND : in STD_LOGIC; --set
           LED16_R : out STD_LOGIC --alarm
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
    
    
    component seg7_driver
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            SEG : out STD_LOGIC_VECTOR (6 downto 0);
            AN : out STD_LOGIC_VECTOR (7 downto 0);
            h_bin : in STD_LOGIC_VECTOR (4 downto 0);
            m_bin : in STD_LOGIC_VECTOR (5 downto 0);
            s_bin : in STD_LOGIC_VECTOR (5 downto 0)
        );
    end component;
    

    -- Signály pro propojení
    signal sig_en_1s : std_logic;
    signal h_bin, sw_h, sw_h_stop, disp_h : std_logic_vector(4 downto 0);
    signal m_bin, sw_m, sw_m_stop, disp_m : std_logic_vector(5 downto 0);
    signal s_bin, sw_s, sw_s_stop, disp_s : std_logic_vector(5 downto 0);
    signal alarm_set : std_logic := '0';
    signal alarm_on : std_logic;
    
    --signal sec_units : std_logic_vector(3 downto 0);
    signal SEG_out : std_logic_vector(6 downto 0);


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
            set => BTND,
            sw_h => sw_h,
            sw_m => sw_m,
            sw_s => sw_s,
            current_h => h_bin,
            current_m => m_bin,
            current_s => s_bin,
            alarm_on => LED16_R
        );

    -- Instance stopek
    STPWTCH : stopwatch
        port map (
            clk => CLK100MHZ,
            rst => BTNC,
            pulse_1hz => sig_en_1s,
            start_stop => BTNL, 
            zero => BTNR,       
            hours => sw_h_stop,
            minutes => sw_m_stop,
            seconds => sw_s_stop
        );
        
    
    DISP : seg7_driver
        port map (
            clk => CLK100MHZ,
            rst => BTNC,
            h_bin => disp_h,
            m_bin => disp_m, 
            s_bin => disp_s,      
            SEG => SEG_out,
            an => AN
        );     

    
    process(SW, h_bin, sw_h, sw_h_stop, m_bin, sw_m, sw_m_stop, s_bin, sw_s, sw_s_stop)
    begin
        case SW (15 downto 14) is
            when "00" => 
                disp_h <= h_bin;
                disp_m <= m_bin;
                disp_s <= s_bin;
            when "01" => 
                disp_h <= sw_h;
                disp_m <= sw_m;
                disp_s <= sw_s;
            when "10" => 
                disp_h <= sw_h_stop;
                disp_m <= sw_m_stop;
                disp_s <= sw_s_stop;
            when others =>
                disp_h <= (others => '0');
                disp_m <= (others => '0');
                disp_s <= (others => '0');
        end case;
    end process;       
                    
    -- Výstupy displeje (zatím statické)
    DP <= '1';
    --AN <= "01111111";
    
    --sec_units <= std_logic_vector(TO_UNSIGNED(TO_INTEGER(unsigned(disp_s)) mod 10, 4));
    --seg_out <= decode_digit(sec_units);
    
    CA <= SEG_out(6);
    CB <= SEG_out(5);
    CC <= SEG_out(4);
    CD <= SEG_out(3);
    CE <= SEG_out(2);
    CF <= SEG_out(1);
    CG <= SEG_out(0);

end Behavioral;
