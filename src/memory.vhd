----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2016 17:33:45 AM
-- Design Name: 
-- Module Name: Register_v2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory is
    Port ( CLK : in STD_LOGIC;
	       MemRead : in STD_LOGIC;      --Control signal from control unit
           MemWrite : in STD_LOGIC;     --Control signal from control unit
           Address : in STD_LOGIC_VECTOR (31 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           MemData : out STD_LOGIC_VECTOR (31 downto 0));
end memory;

architecture Behavioral of memory is

    signal memory : rom_mem := MEM_INIT_STATE; --initialized memory with instructions

begin
    process (CLK) is
    begin
        if rising_edge(CLK) then
			if MemRead = '1' then
		    	MemData <= memory(to_integer(unsigned(Address)));
		    end if;
		   	
		    if MemWrite = '1' then
		       	memory(to_integer(unsigned(Address))) <= WriteData;
		    end if;
        end if;
        
    end process;

end Behavioral;



