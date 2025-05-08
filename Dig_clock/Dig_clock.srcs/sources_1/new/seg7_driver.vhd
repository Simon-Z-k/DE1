library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg7_driver is
    Port (
        clk     : in STD_LOGIC;                             -- Hlavní hodinový signál (100 MHz)
        rst     : in STD_LOGIC;                             -- Reset (ale nepouzivá se zde)
        h_bin   : in STD_LOGIC_VECTOR (4 downto 0);         -- Vstup: hodiny (5 bitů)
        m_bin   : in STD_LOGIC_VECTOR (5 downto 0);         -- Vstup: minuty (6 bitů)
        s_bin   : in STD_LOGIC_VECTOR (5 downto 0);         -- Vstup: sekundy (6 bitů)
        SEG     : out STD_LOGIC_VECTOR (6 downto 0);        -- Výstup: segmenty A–G (active-low)
        AN      : out STD_LOGIC_VECTOR (7 downto 0)         -- Výstup: anody 8 míst (active-low)
    );
end seg7_driver;

architecture Behavioral of seg7_driver is

    -- Registr pro hodnotu jedné cifry, která se aktuálne zobrazuje
    signal digit_values : std_logic_vector(3 downto 0);

    -- Pocítadlo 3 bitů pro výber jednoho ze 6 zobrazovaných míst (0–5)
    signal mux_counter : unsigned(2 downto 0) := (others => '0');

    -- Delicka frekvence (16 bitů) – zpomalí přepínání mezi pozicemi
    signal clkdiv : unsigned(15 downto 0) := (others => '0');

begin

    -- CLOCK DIVIDER
    -- Snizuje frekvenci multiplexování na desítky az stovky Hz
    process(clk)
    begin
        if rising_edge(clk) then
            clkdiv <= clkdiv + 1;
            if clkdiv = 0 then
                mux_counter <= mux_counter + 1; -- prepnutí na dalsí pozici displeje
            end if;
        end if;
    end process;

    -- MUX / VÝBER POZICE 
    -- Zvolí, která císlice se má zobrazit, a na kterou pozici
    process(mux_counter, h_bin, m_bin, s_bin)
    begin
        case mux_counter is
            when "000" => -- sekundy jednotky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(s_bin)) mod 10, 4));
                AN <= "11111110"; -- aktivní první pozice (zcela vpravo)
            when "001" => -- sekundy desítky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(s_bin)) / 10, 4));
                AN <= "11111101";
            when "010" => -- minuty jednotky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(m_bin)) mod 10, 4));
                AN <= "11111011";
            when "011" => -- minuty desítky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(m_bin)) / 10, 4));
                AN <= "11110111";
            when "100" => -- hodiny jednotky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(h_bin)) mod 10, 4));
                AN <= "11101111";
            when "101" => -- hodiny desítky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(h_bin)) / 10, 4));
                AN <= "11011111";
            when others =>
                digit_values <= "0000"; -- výchozí hodnota
                AN <= "11111111";       -- zádná pozice aktivní
        end case;
    end process;

    -- DEKODÉR BINÁRNÍ CÍSLICE 
    -- Prevede 4bitové císlo (0–9) na kód pro 7segmentovku (common anode)
    process(digit_values)
    begin
        case digit_values is
            when "0000" => SEG <= "1000000"; -- 0
            when "0001" => SEG <= "1111001"; -- 1
            when "0010" => SEG <= "0100100"; -- 2
            when "0011" => SEG <= "0110000"; -- 3
            when "0100" => SEG <= "0011001"; -- 4
            when "0101" => SEG <= "0010010"; -- 5
            when "0110" => SEG <= "0000010"; -- 6
            when "0111" => SEG <= "1111000"; -- 7
            when "1000" => SEG <= "0000000"; -- 8
            when "1001" => SEG <= "0010000"; -- 9
            when others => SEG <= "1111111"; -- vypnuto
        end case;
    end process;

end Behavioral;
