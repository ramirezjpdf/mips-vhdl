
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port(
		a, b   : in std_logic_vector(31 downto 0);
		alu_op : in std_logic_vector(3 downto 0);
		zero   : out std_logic;
		result : out std_logic_vector(31 downto 0)
	);
end alu;

architecture behav of alu is

begin

	process(a, b, alu_op)
	begin
		zero <= '0';
		case alu_op is
		when "0000" => result <= a and b;
		when "0001" => result <= a or b;
		when "0111" => 
			if to_integer(unsigned(a)) < to_integer(unsgined(b)) then
				result <= x"00000001";
			else
				result <= x"00000000";
			end if;
		
		end case;
	end process;
end behav;