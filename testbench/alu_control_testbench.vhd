library ieee;
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

	signal t_alu_op :  std_logic_vector (1 downto 0);
	signal t_funct  :  std_logic_vector (5 downto 0);
	signal t_alu_control_out_signal : std_logic_vector (3 downto 0);
begin

	ac_test : alu_control port map(alu_op => t_alu_op,
                          funct => t_funct,
		          alu_control_out_signal => t_alu_control_out_signal);
	process
	begin
		t_alu_op <= LW_OR_SW;
		t_funct   <= "------";
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(ADD_CONTROL)
                report "Error in alu control signal for lw or sw instructions";
		
		wait for 1 ns;
		
		t_alu_op <= BEQ_OR_BNE;
		t_funct   <= "------";
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(SUB_CONTROL)
                report 
                "Error in alu control signal for beq or bne instructions";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= AND_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(AND_CONTROL)
                report "Error in alu control signal for and instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= OR_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(OR_CONTROL)
                report "Error in alu control signal for or instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= NOR_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(NOR_CONTROL)
                report "Error in alu control signal for nor instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= SLT_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(SLT_CONTROL)
                report "Error in alu control signal for slt instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= ADD_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(ADD_CONTROL)
                report "Error in alu control signal for add instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= SUB_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(SUB_CONTROL)
                report "Error in alu control signal for sub instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= SLL_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(SLL_CONTROL)
                report "Error in alu control signal for sll instruction";
		
		wait for 1 ns;
		
		t_alu_op <= R_TYPE_INST;
		t_funct   <= SRL_FUNCT;
		wait for 1 ns; assert
                unsigned(t_alu_control_out_signal ) = unsigned(SRL_CONTROL)
                report "Error in alu control signal for srl instruction";
		
		wait for 1 ns;
		
		assert false report "alu_control test end";
		wait;
	end process;

end behav;
