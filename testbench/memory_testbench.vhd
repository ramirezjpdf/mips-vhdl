
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;

entity memory_testbench is
end memory_testbench;

architecture behav of memory_testbench is

	component memory is 
		Port ( CLK : in STD_LOGIC;
			   MemRead : in STD_LOGIC;
			   MemWrite : in STD_LOGIC;
			   Address : in STD_LOGIC_VECTOR (31 downto 0);
			   WriteData : in STD_LOGIC_VECTOR (31 downto 0);
			   ReadData : out STD_LOGIC_VECTOR (31 downto 0));
	end component;

	signal t_CLK : STD_LOGIC := '0';
    signal t_MemRead, t_MemWrite : STD_LOGIC := '0';
    signal t_Address, t_WriteData, t_ReadData : STD_LOGIC_VECTOR (31 downto 0);
    
begin
	clk_control : process
	begin
		
		wait for 1 ns;
		t_CLK <= '1';
		t_MemRead <= '1';
		t_MemWrite <= '0';
		t_Address <= x"0000000f";
		t_WriteData <= x"00000000";

		wait for 1 ns;
		t_CLK <= '0';

		wait for 1 ns;
		t_CLK <= '1';
		t_MemRead <= '0';
		t_MemWrite <= '1';
		t_Address <= x"00000008";
		t_WriteData <= x"000000fb";

		wait for 1 ns;
		t_CLK <= '0';

		wait for 1 ns;
		t_CLK <= '1';
		t_MemRead <= '1';
		t_MemWrite <= '0';
		t_Address <= x"00000008";
		t_WriteData <= x"00000000";

 		wait for 1 ns;
		t_CLK <= '0';
		
		wait for 1 ns;
		t_CLK <= '1';
		t_MemRead <= '1';
		t_MemWrite <= '0';
		t_Address <= x"00000000";
		t_WriteData <= x"00000000";
		wait;

	end process;
	
	Memory1 : memory port map (t_CLK, t_MemRead, t_MemWrite, t_Address, t_WriteData, t_ReadData); 
end behav;


