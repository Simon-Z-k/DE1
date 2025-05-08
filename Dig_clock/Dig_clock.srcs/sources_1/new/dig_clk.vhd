library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

-- Deklarace entity (rozhraní)
entity dig_clk is
    Port (
        clk       : in STD_LOGIC;                    -- Hlavní hodinový signál (100 MHz)
        rst       : in STD_LOGIC;                    -- Reset
        pulse_1hz : in STD_LOGIC;                    -- Impulz 1 Hz (z modulu clock_enable)
        set       : in STD_LOGIC;                    -- Nastavení casu (BTND)
        new_h     : in STD_LOGIC_VECTOR (4 downto 0);-- Nová hodnota hodin
        new_m     : in STD_LOGIC_VECTOR (5 downto 0);-- Nová hodnota minut
        hours     : out STD_LOGIC_VECTOR (4 downto 0);-- Výstupní hodiny
        minutes   : out STD_LOGIC_VECTOR (5 downto 0);-- Výstupní minuty
        seconds   : out STD_LOGIC_VECTOR (5 downto 0) -- Výstupní sekundy
    );
end dig_clk;

architecture Behavioral of dig_clk is

    -- unsigned pro scítání
    signal h : unsigned(4 downto 0) := (others => '0'); -- hodiny: 0–23
    signal m : unsigned(5 downto 0) := (others => '0'); -- minuty: 0–59
    signal s : unsigned(5 downto 0) := (others => '0'); -- sekundy: 0–59

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset casu na nulu
                h <= (others => '0');
                m <= (others => '0');
                s <= (others => '0');

            elsif set = '1' then
                -- Nastavení nové hodnoty hodin a minut (přes tlacítko)
                h <= unsigned(new_h);
                m <= unsigned(new_m);

            elsif pulse_1hz = '1' then
                -- inkrementujeme cas
                if s = 59 then
                    s <= (others => '0'); -- Reset sekund
                    if m = 59 then
                        m <= (others => '0'); -- Reset minut
                        if h = 23 then
                            h <= (others => '0'); -- Reset hodin
                        else
                            h <= h + 1; -- Jinak inkrementace hodin
                        end if;
                    else
                        m <= m + 1; -- inkrementace minut
                    end if;
                else
                    s <= s + 1; -- inkrementace sekund
                end if;
            end if;
        end if;
    end process;

    -- Prirazení interních registrů na výstupy (prevod z unsigned na std_logic_vector)
    hours   <= std_logic_vector(h);
    minutes <= std_logic_vector(m);
    seconds <= std_logic_vector(s);

end Behavioral;
