library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;

entity reg_aux is
    generic(data_length    : integer := MIPS32_DATA_LENGTH;
            is_rising_edge : boolean := True);
    port(clk : in std_logic;
         in_data : in std_logic_vector(data_length - 1 downto 0);
         out_data: out std_logic_vector (data_length - 1 downto 0));
end reg_aux;

architecture behav of reg_aux is
signal reg : std_logic_vector(data_length - 1 downto 0) := (others => '0');
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
