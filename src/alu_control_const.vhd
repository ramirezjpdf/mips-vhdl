library ieee;
use ieee.std_logic_1164.all;

package alu_control_const is
	-- ALU CONTROL
	constant AND_CONTROL : std_logic_vector (3 downto 0) := "0000";
	constant OR_CONTROL  : std_logic_vector (3 downto 0) := "0001";
	constant NOR_CONTROL : std_logic_vector (3 downto 0) := "1100";
	constant SLT_CONTROL : std_logic_vector (3 downto 0) := "0111";
	constant ADD_CONTROL : std_logic_vector (3 downto 0) := "0010";
	constant SUB_CONTROL : std_logic_vector (3 downto 0) := "0110";
	-- for shift operations, the value is not present in patterson
	-- found here (not official but sufficient for now)
	-- http://people.tamu.edu/~ehsanrohani/ECEN350/Lab08.pdf
	-- and here
	-- http://www.iuma.ulpgc.es/~nunez/clases-micros-para-com/clases-mpc-slides-links/Lafayette-Nestor-ece313-s04/mips%20multicycle%20Final%20Project.pdf
	constant SLL_CONTROL : std_logic_vector (3 downto 0) := "0011";
	constant SRL_CONTROL : std_logic_vector (3 downto 0) := "0100";

	-- ALU_OP
	constant LW_OR_SW    : std_logic_vector (1 downto 0) := "00";
	constant BEQ_OR_BNE  : std_logic_vector (1 downto 0) := "01";
	constant R_TYPE_INST : std_logic_vector (1 downto 0) := "10";

	-- FUNCT
	constant AND_FUNCT : std_logic_vector (5 downto 0) := "100100";
	constant OR_FUNCT  : std_logic_vector (5 downto 0) := "100101";
	constant NOR_FUNCT : std_logic_vector (5 downto 0) := "100111";
	constant SLT_FUNCT : std_logic_vector (5 downto 0) := "101010";
	constant ADD_FUNCT : std_logic_vector (5 downto 0) := "100000";
	constant SUB_FUNCT : std_logic_vector (5 downto 0) := "100010";
	constant SLL_FUNCT : std_logic_vector (5 downto 0) := "000000";
	constant SRL_FUNCT : std_logic_vector (5 downto 0) := "000010";
end alu_control_const;
