----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2016 10:52:34 AM
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
--use work.TYPES.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_v2 is
    Port ( CLK : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           ReadAddrs1 : in STD_LOGIC_VECTOR (4 downto 0);
           ReadAddrs2 : in STD_LOGIC_VECTOR (4 downto 0);
           WriteAddrs : in STD_LOGIC_VECTOR (4 downto 0);
           WriteData : in STD_LOGIC_VECTOR (31 downto 0);
           ReadData1 : out STD_LOGIC_VECTOR (31 downto 0);
           ReadData2 : out STD_LOGIC_VECTOR (31 downto 0));
end Register_v2;

architecture Behavioral of Register_v2 is

    type reg is array(31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
    signal reg_file : reg;
    --signal temp : integer;

begin
    process (CLK) is
    begin
        if rising_edge(CLK) then
            ReadData1 <= reg_file(to_integer(unsigned(ReadAddrs1)));
            ReadData2 <= reg_file(to_integer(unsigned(ReadAddrs2)));
        
            --if ((RegWrite = '1') and (WriteAddrs /= "0000")) then
                --temp <= to_integer(unsigned(WriteAddrs));
                reg_file(to_integer(unsigned(WriteAddrs))) <= WriteData;
            --end if;
        end if;
        
    end process;

end Behavioral;
