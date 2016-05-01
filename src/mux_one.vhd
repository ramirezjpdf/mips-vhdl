library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_one is
    generic (data_length : integer);
    port(sel : in std_logic;
         in0_data : in std_logic_vector(data_length - 1 downto 0);
         in1_data : in std_logic_vector(data_length - 1 downto 0);
         out_data: out std_logic_vector(data_length - 1 downto 0));
end mux_one;

architecture behav of mux_one is
begin
    process(sel, in0_data, in1_data)
    begin
        case sel is
            when '0'    => out_data <= in0_data;
            when '1'    => out_data <= in1_data;
            when others => out_data <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end case;
    end process;
end behav;