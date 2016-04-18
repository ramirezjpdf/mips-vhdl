-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg is
end tb_reg;

architecture behav of tb_reg is

	component Register_v2 is 
		Port ( CLK : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           ReadAddrs1 : in STD_LOGIC_VECTOR (4 downto 0);
           ReadAddrs2 : in STD_LOGIC_VECTOR (4 downto 0);
           WriteAddrs : in STD_LOGIC_VECTOR (4 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           ReadData1 : out STD_LOGIC_VECTOR (31 downto 0);
           ReadData2 : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
    
    signal t_CLK, t_RegWrite : STD_LOGIC;
    signal t_ReadAddrs1, t_ReadAddrs2, t_WriteAddrs : STD_LOGIC_VECTOR (4 downto 0);
    
    signal t_WriteData, t_ReadData1, t_ReadData2 : STD_LOGIC_VECTOR (31 downto 0);
    
begin
    process
    begin
    	t_CLK <= '1';
        t_RegWrite <= '1';
        t_ReadAddrs1 <= "00000";
        t_ReadAddrs2 <= "00000";
        t_WriteAddrs <= "00001";
        t_WriteData <= x"000000F0";
        
        wait for 1 ns;
        
        t_CLK <= '0';
        
        wait for 1 ns;
        
        t_CLK <= '1';
        t_RegWrite <= '0';
        t_ReadAddrs1 <= "00001";
        t_ReadAddrs2 <= "00000";
        t_WriteAddrs <= "00010";
        t_WriteData <= x"000000F0";

		wait for 1 ns;
        
		wait;
    end process;
    
    REG1 : Register_v2 port map (t_CLK, t_RegWrite, t_ReadAddrs1, t_ReadAddrs2, t_WriteAddrs, t_WriteData, t_ReadData1, t_ReadData2);
    
end behav;
