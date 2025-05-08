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

    -- Čítač, který se inkrementuje až do hodnoty MAX
    signal sig_count : integer range 0 to MAX := 0;

    -- Interní signál - jeden hodinový impulz
    signal pulse : STD_LOGIC := '0';

begin

    -- Proces, který běží při každém náběžné hraně hlavního hodinového signálu (clk)
    p_clk_enable : process (clk) is
    begin
        if rst='1' then                  -- Pokud je aktivní reset
            sig_count <= 0;              
            pulse <= '0';                
        elsif (rising_edge(clk)) then    -- Jinak při náběžné hraně hodin
            if sig_count = MAX then      
                sig_count <= 0;          -- Reset čítače
                pulse <= '1';            -- Vygenerujeme impulz – trvá jeden takt
            else
                sig_count <= sig_count + 1; -- Inkrementujeme čítač
                pulse <= '0';               -- Výstupní impulz zůstává neaktivní
            end if;
        end if;
    end process p_clk_enable;

    -- Připojení vnitřního signálu na výstupní port – impulz trvá vždy jeden takt (10 ns při 100 MHz)
    pulse_1hz <= pulse;

end Behavioral;
