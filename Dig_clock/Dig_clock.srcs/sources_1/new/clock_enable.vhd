library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Deklarace entity (rozhraní modulu)
entity clock_enable is
 generic (
        -- MAX 100 000 000 pro 100 MHz → 1Hz)
        MAX : integer := 100000000
    );
 Port ( 
        clk : in STD_LOGIC;            -- Hlavní hodinový signál (100 MHz)
        rst : in STD_LOGIC;            -- reset
        pulse_1hz : out STD_LOGIC      -- Výstupní signál – sekunda
    );
end clock_enable;


architecture Behavioral of clock_enable is

    -- Cítac, který se inkrementuje do hodnoty MAX
    signal sig_count : integer range 0 to MAX := 0;

    -- Interní signál - jeden hodinový impulz
    signal pulse : STD_LOGIC := '0';

begin

    -- Proces, který bezí při kazdém nábezné hraně hlavního hodinového signálu (clk)
    p_clk_enable : process (clk) is
    begin
        if rst='1' then                  -- Pokud je aktivní reset
            sig_count <= 0;              
            pulse <= '0';                
        elsif (rising_edge(clk)) then    -- Jinak pri nábezné hrane hodin
            if sig_count = MAX then      
                sig_count <= 0;          -- Reset cítace
                pulse <= '1';            -- Vygenerujeme impulz – trvá jeden takt
            else
                sig_count <= sig_count + 1; -- Inkrementujeme cítac
                pulse <= '0';               -- Výstupní impulz zustává neaktivní
            end if;
        end if;
    end process p_clk_enable;

    -- Pripojení vnitrního signálu na výstupní port – impulz trvá vzdy jeden takt (10 ns pri 100 MHz)
    pulse_1hz <= pulse;

end Behavioral;
