library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_two is
	generic(data_length : integer);
    port(sel : in std_logic_vector(1 downto 0);
         in0_data : in std_logic_vector(data_length - 1 downto 0);
         in1_data : in std_logic_vector(data_length - 1 downto 0);
         in2_data : in std_logic_vector(data_length - 1 downto 0);
         in3_data : in std_logic_vector(data_length - 1 downto 0);
         out_data: out std_logic_vector(data_length - 1 downto 0));
end mux_two;

architecture behav of mux_two is
begin
    process(sel, in0_data, in1_data, in2_data, in3_data)
    begin
        case sel is
            when "00"    => out_data <= in0_data;
            when "01"    => out_data <= in1_data;
            when "10"    => out_data <= in2_data;
            when "11"    => out_data <= in3_data;
            when others => out_data <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end case;
    end process;
end behav;