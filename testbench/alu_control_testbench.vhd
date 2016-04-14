use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.alu_control_const.all;

entity alu_control_testbench is
end alu_control_testbench;

architecture behav of alu_control_testbench is

	component alu_control is
	port(
			 alu_op : in std_logic_vector (1 downto 0);
			 funct  : in std_logic_vector (5 downto 0);
			 alu_control_out_signal : out std_logic_vector(3 downto 0)
		);
	end component;

	signal t_alu_op : in std_logic_vector (1 downto 0);
	signal t_funct  : in std_logic_vector (5 downto 0);
begin

	ac_test : alu_control port map(alu_op => t_alu_op,
                                   func => t_func);
	process
	begin
		t_alu_op => LW_OR_SW;
		t_func   => "--";
		
		wait for 1 ns;
		
		t_alu_op => BEQ_OR_BNE;
		t_func   => "--";
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => AND_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => OR_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => NOR_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => SLT_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => ADD_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => SUB_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => SLL_FUNCT;
		
		wait for 1 ns;
		
		t_alu_op => R_TYPE_INST;
		t_func   => SRL_FUNCT;
		
		wait for 1 ns;
		
		assert false report "alu_control test end";
		wait;
	end process;

end behav;