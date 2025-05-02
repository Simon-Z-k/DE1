library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dig_clk is
    Port (
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        pulse_1hz : in STD_LOGIC;
        set       : in STD_LOGIC;         -- spustí na?tení nového ?asu ( BTND)
        new_h     : in STD_LOGIC_VECTOR (4 downto 0);
        new_m     : in STD_LOGIC_VECTOR (5 downto 0);
        hours     : out STD_LOGIC_VECTOR (4 downto 0);
        minutes   : out STD_LOGIC_VECTOR (5 downto 0);
        seconds   : out STD_LOGIC_VECTOR (5 downto 0)
    );
end dig_clk;

architecture Behavioral of dig_clk is
    signal h : unsigned(4 downto 0) := (others => '0');
    signal m : unsigned(5 downto 0) := (others => '0');
    signal s : unsigned(5 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                h <= (others => '0');
                m <= (others => '0');
                s <= (others => '0');

            elsif set = '1' then
                h <= unsigned(new_h);
                m <= unsigned(new_m);

            elsif pulse_1hz = '1' then
                if s = 59 then
                    s <= (others => '0');
                    if m = 59 then
                        m <= (others => '0');
                        if h = 23 then
                            h <= (others => '0');
                        else
                            h <= h + 1;
                        end if;
                    else
                        m <= m + 1;
                    end if;
                else
                    s <= s + 1;
                end if;
            end if;
        end if;
    end process;

    hours   <= std_logic_vector(h);
    minutes <= std_logic_vector(m);
    seconds <= std_logic_vector(s);

end Behavioral;