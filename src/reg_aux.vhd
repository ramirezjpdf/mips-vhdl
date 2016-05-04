library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_aux is
    generic(is_rising_edge : boolean := True);
    port(clk : in std_logic;
         in_data : in std_logic_vector(31 downto 0);
         out_data: out std_logic_vector (31 downto 0));
end reg_aux;

architecture behav of reg_aux is
signal reg : std_logic_vector(31 downto 0) := x"00000000";
begin
    process(clk)
    begin
        out_data <= reg;
        if is_rising_edge then
            if rising_edge(clk) then
                reg <= in_data;
                out_data <= in_data;
            end if;
        else    
            if falling_edge(clk) then
                reg <= in_data;
                out_data <= in_data;
            end if;
        end if;
    end process;
end behav;
