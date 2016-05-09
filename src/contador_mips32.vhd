----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 02:56:23 PM
-- Design Name: 
-- Module Name: contador_mips32 - Behavioral
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

entity contador_mips32 is
    Port ( CLK : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           Anodo : out STD_LOGIC_VECTOR (7 downto 0);
           Catodo : out STD_LOGIC_VECTOR (7 downto 0));
end contador_mips32;

architecture Behavioral of contador_mips32 is

    component mips32_struct is
        port(CLK : in STD_LOGIC;
             LED : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component s7segmentos is
    Port ( CLK : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (31 downto 0);
           Anodo : out STD_LOGIC_VECTOR (7 downto 0);
           Catodo : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

signal aux_clk1, aux_clk2 : std_logic;
signal aux_led : std_logic_vector (31 downto 0);

begin

    process(CLK) is
    variable counter1, counter2 : integer := 0;
    
    begin 
    if rising_edge(CLK) then
        if counter1 > 1000000 then
            aux_clk1 <= not aux_clk1;
            counter1 := 0;
        
        else
            counter1 := counter1 + 1;
        
        end if;
        
        if counter2 > 100000 then
            aux_clk2 <= not aux_clk2;
            counter2 := 0;                  
                                            
        else                                
            counter2 := counter2 + 1;        
                                            
        end if;                             
    
    end if;
    end process;
    LED <= aux_led(15 downto 0);
    mips : mips32_struct port map (aux_clk1, aux_led);
    display : s7segmentos port map (aux_clk2, aux_led, Anodo, Catodo);

end Behavioral;
