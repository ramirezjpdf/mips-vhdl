library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_special is
    port(clk : in std_logic;
         write_signal : in std_logic;
         in_data : in std_logic_vector(31 downto 0);
         out_data: out std_logic_vector (31 downto 0));
end reg_special;

architecture behav of reg_special is
signal reg : std_logic_vector(31 downto 0) := x"00000000";
begin
    process(clk)
    begin
        out_data <= reg;
        if falling_edge(clk) and write_signal = '1' then
            reg <= in_data;
            out_data <= in_data;
        end if;
    end process;
end behav;