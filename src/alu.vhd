
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.const.all;

entity alu is
	port(
		a, b           : in std_logic_vector(31 downto 0);
		shamt          : in std_logic_vector(4 downto 0);
		alu_control_in : in std_logic_vector(3 downto 0);
		zero           : out std_logic;
		result         : out std_logic_vector(31 downto 0)
	);
end alu;

architecture behav of alu is

signal res_aux : std_logic_vector (31 downto 0);
begin
	process(a, b, alu_control_in, shamt)
	begin
		case alu_control_in is
		when AND_CONTROL => res_aux <= a and b;
		when OR_CONTROL  => res_aux <= a or b;
		when NOR_CONTROL => res_aux <= not a or b;
		when SLT_CONTROL => 
			if signed(a) < signed(b) then
				res_aux <= x"00000001";
			else
				res_aux <= x"00000000";
			end if;
		when ADD_CONTROL => res_aux <=
				     std_logic_vector(signed(a) + signed(b));
		when SUB_CONTROL => res_aux <=
				     std_logic_vector(signed(a) - signed(b));
		when SLL_CONTROL => res_aux <=
			     	     std_logic_vector(
                                     signed(b) sll to_integer(unsigned(shamt))
                                     );
		when SRL_CONTROL => res_aux <=
				     std_logic_vector(
                                     signed(b) srl to_integer(unsigned(shamt))
                                     );
		when others => res_aux <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		end case;

		case res_aux is
			when x"00000000" => zero <= '0';
			when others => zero <= '1';
		end case;

		result <= res_aux;
	end process;
end behav;
