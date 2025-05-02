
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
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           BTNC : in STD_LOGIC; --rst
           BTNL : in STD_LOGIC; --start
           BTNR : in STD_LOGIC; --nulovani pro stopwatch
           BTND : in STD_LOGIC; --set
           BTNU : in STD_LOGIC; --navysovani casu
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
            set : in STD_LOGIC;         
            new_h : in STD_LOGIC_VECTOR (4 downto 0);
            new_m : in STD_LOGIC_VECTOR (5 downto 0);
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
            start : in STD_LOGIC;
            stop : in STD_LOGIC;
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
    signal h_bin, sw_h, sw_h_stop, disp_h, set_h : std_logic_vector(4 downto 0);
    signal m_bin, sw_m, sw_m_stop, disp_m, set_m : std_logic_vector(5 downto 0);
    signal s_bin, sw_s, sw_s_stop, disp_s : std_logic_vector(5 downto 0);
    signal alarm_set : std_logic := '0';
    signal alarm_on : std_logic;
    
    signal SEG : std_logic_vector(6 downto 0);
     
    signal inc_btn_prev : std_logic := '0';


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
            set => BTND,
            new_h => set_h,
            new_m => set_m,
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
            start => BTNL,
            stop => BTNR,
            zero => BTND,       
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
            SEG => SEG,
            AN => AN
        );     


    process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        -- Detekce náb?né hrany tla?ítka BTNU
        if (inc_btn_prev = '0') and (BTNU = '1') then
            case SW(1 downto 0) is
                when "10" =>  -- hodiny
                    if unsigned(set_h) = 23 then
                        set_h <= (others => '0');
                    else
                        set_h <= std_logic_vector(unsigned(set_h) + 1);
                    end if;
                    when "11" =>  -- minuty
                    if unsigned(set_m) = 59 then
                        set_m <= (others => '0');
                    else
                        set_m <= std_logic_vector(unsigned(set_m) + 1);
                    end if;
                when others => null;
            end case;
        end if;
        inc_btn_prev <= BTNU;
    end if;
end process;

    
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
                    
    -- Vıstupy displeje 
    
    CA <= SEG(0);
    CB <= SEG(1);
    CC <= SEG(2);
    CD <= SEG(3);
    CE <= SEG(4);
    CF <= SEG(5);
    CG <= SEG(6);

end Behavioral;
