library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seg7_driver is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        h_bin : in STD_LOGIC_VECTOR (4 downto 0);
        m_bin : in STD_LOGIC_VECTOR (5 downto 0);
        s_bin : in STD_LOGIC_VECTOR (5 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        an : out STD_LOGIC_VECTOR (7 downto 0)
    );
end seg7_driver;

architecture Behavioral of seg7_driver is
    signal digit_values : std_logic_vector(3 downto 0);
    signal mux_counter : unsigned(2 downto 0) := (others => '0');
    signal clkdiv : unsigned(15 downto 0) := (others => '0');
begin

    -- Jednoduchý clock divider pro multiplexing
    process(clk)
    begin
        if rising_edge(clk) then
            clkdiv <= clkdiv + 1;
            if clkdiv = 0 then
                mux_counter <= mux_counter + 1;
            end if;
        end if;
    end process;

    -- Výběr správné číslice
    process(mux_counter, h_bin, m_bin, s_bin)
    begin
        case mux_counter is
            when "000" => -- sekundy jednotky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(s_bin)) mod 10, 4));
                an <= "11111110";
            when "001" => -- sekundy desítky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(s_bin)) / 10, 4));
                an <= "11111101";
            when "010" => -- minuty jednotky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(m_bin)) mod 10, 4));
                an <= "11111011";
            when "011" => -- minuty desítky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(m_bin)) / 10, 4));
                an <= "11110111";
            when "100" => -- hodiny jednotky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(h_bin)) mod 10, 4));
                an <= "11101111";
            when "101" => -- hodiny desítky
                digit_values <= std_logic_vector(to_unsigned(to_integer(unsigned(h_bin)) / 10, 4));
                an <= "11011111";
            when others =>
                digit_values <= "0000";
                an <= "11111111";
        end case;
    end process;

    -- Převod binární hodnoty na 7-segmentový kód (common anode)
    process(digit_values)
    begin
        case digit_values is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- segment je off
        end case;
    end process;

end Behavioral;
