library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;


entity mips32 is
    port(CLK : in STD_LOGIC;
         ReadData : out STD_LOGIC_VECTOR (31 downto 0));
end entity;

architecture behav of mips32 is

	component memory is 
		Port ( CLK : in STD_LOGIC;
		MemRead : in STD_LOGIC;
		MemWrite : in STD_LOGIC;
		Address : in STD_LOGIC_VECTOR (31 downto 0);
		WriteData : in STD_LOGIC_VECTOR (31 downto 0);
		ReadData : out STD_LOGIC_VECTOR (31 downto 0));
	end component;
	
	signal pc : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
	
	--Control signals
	signal IorD : STD_LOGIC := '0';
	
	--Memory signals
	--signal CLK : STD_LOGIC := '0';
    signal t_MemRead, t_MemWrite : STD_LOGIC := '0';
    signal t_Address, t_WriteData: STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
begin

	process(CLK) is
	begin
		if rising_edge(CLK) then
            
            if IorD = '0' then                                   
                t_Address <= pc;                                 
            end if;                                              
            t_MemRead <= '1';                                    
            pc <= std_logic_vector(signed(pc) + x"00000001");    
                
         end if;
	end process;
	
	Memory1 : memory port map (CLK, t_MemRead, t_MemWrite, t_Address, t_WriteData, ReadData);
end architecture;

