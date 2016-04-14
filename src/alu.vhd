
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
signal res_aux : std_logic_vector (31 downto 0);
begin

	process(a, b, alu_op)
	begin
		case alu_op is
		when "0000" => res_aux <= a and b;
		when "0001" => res_aux <= a or b;
		when "1100" => res_aux <= not a or b;
		when "0111" => 
			if signed(a) < signed(b)) then
				result <= x"00000001";
			else
				result <= x"00000000";
			end if;
		when "0010" => res_aux <=
					    std_logic_vector(signed(a) + signed(b));
		when "0110" => res_aux <=
					    std_logic_vector(signed(a) - signed(b));
		when others => res_aux <= 'X';
		end case;

		case res_aux is
			when x"00000000" => zero <= '0';
			when others => zero <= '1';
		end case;

		result <= res_aux;
	end process;
end behav;