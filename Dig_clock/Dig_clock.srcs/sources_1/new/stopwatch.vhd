library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stopwatch is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse_1hz : in STD_LOGIC;
           start : in STD_LOGIC;
           stop : in STD_LOGIC;
           zero : in STD_LOGIC; -- nulovani
           hours : out STD_LOGIC_VECTOR (4 downto 0);
           minutes : out STD_LOGIC_VECTOR (5 downto 0);
           seconds : out STD_LOGIC_VECTOR (5 downto 0));
end stopwatch;

architecture Behavioral of stopwatch is

    signal h, m, s : integer := 0;
    signal running : std_logic := '0'; --pocitani

begin
    process (clk) --vyreseni start-stop tlacitka
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    running <= '0';
                elsif start = '1' then   
                    running <= '1';
                elsif stop = '1' then   
                    running <= '0';
                end if;
            end if;
            
    end process;          
    
    process (clk)
        begin
            if rising_edge(clk) then
            if rst = '1' or zero = '1' then
                h <= 0;
                m <= 0;
                s <= 0;
            elsif pulse_1hz = '1' and running = '1' then
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
    
    hours   <= std_logic_vector (TO_UNSIGNED (h, 5));
    minutes <= std_logic_vector (TO_UNSIGNED (m, 6));
    seconds <= std_logic_vector (TO_UNSIGNED (s, 6));

end Behavioral;
