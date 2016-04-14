library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
	port(alu_op : in std_logic_vector (1 downto 0);
		 funct  : in std_logic_vector (5 downto 0);
		 alu_control_out_signal : out std_logic_vector(3 downto 0)
	);
end alu_control;

architecture behav of alu_control is

begin
	process(alu_op, funct)
	begin
		case alu_op is
			when "00" => alu_control_out_signal <= "0010";
			when "01" => alu_control_out_signal <= "0110";
			when "10" =>
				case funct is
					when "100000" => alu_control_out_signal <= "0010";
					when "100010" => alu_control_out_signal <= "0110";
					when "100100" => alu_control_out_signal <= "0000";
					when "100101" => alu_control_out_signal <= "0001";
					when "101010" => alu_control_out_signal <= "0111";
					when others => alu_control_out_signal <= 'X';
				end case;
			when others => alu_control_out_signal <= 'X';
		end case;
	end process;
end behav;