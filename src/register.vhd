----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2016 02:01:25 PM
-- Design Name: 
-- Module Name: register - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    Port ( Din : in STD_LOGIC_VECTOR (31 downto 0);
           Dout : out STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC);
end reg;

architecture Behavioral of reg is
    signal aux : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    component flipflop is
    port( D : in STD_LOGIC;
          CLK : in STD_LOGIC;
          Q : out STD_LOGIC;
          Qc : out STD_LOGIC);
    end component;

begin
    FF0: flipflop port map(Din(0), CLK, Dout(0), aux(0));
    FF1: flipflop port map(Din(1), CLK, Dout(1), aux(1));
    FF2: flipflop port map(Din(2), CLK, Dout(2), aux(2));
    FF3: flipflop port map(Din(3), CLK, Dout(3), aux(3));
    FF4: flipflop port map(Din(4), CLK, Dout(4), aux(4));
    FF5: flipflop port map(Din(5), CLK, Dout(5), aux(5));
    FF6: flipflop port map(Din(6), CLK, Dout(6), aux(6));
    FF7: flipflop port map(Din(7), CLK, Dout(7), aux(7));
    FF8: flipflop port map(Din(8), CLK, Dout(8), aux(8));
    FF9: flipflop port map(Din(9), CLK, Dout(9), aux(9));
    FF10: flipflop port map(Din(10), CLK, Dout(10), aux(10));
    FF11: flipflop port map(Din(11), CLK, Dout(11), aux(11));
    FF12: flipflop port map(Din(12), CLK, Dout(12), aux(12));
    FF13: flipflop port map(Din(13), CLK, Dout(13), aux(13));
    FF14: flipflop port map(Din(14), CLK, Dout(14), aux(14));
    FF15: flipflop port map(Din(15), CLK, Dout(15), aux(15));
    FF16: flipflop port map(Din(16), CLK, Dout(16), aux(16));
    FF17: flipflop port map(Din(17), CLK, Dout(17), aux(17));
    FF18: flipflop port map(Din(18), CLK, Dout(18), aux(18));
    FF19: flipflop port map(Din(19), CLK, Dout(19), aux(19));
    FF20: flipflop port map(Din(20), CLK, Dout(20), aux(20));
    FF21: flipflop port map(Din(21), CLK, Dout(21), aux(21));
    FF22: flipflop port map(Din(22), CLK, Dout(22), aux(22));
    FF23: flipflop port map(Din(23), CLK, Dout(23), aux(23));
    FF24: flipflop port map(Din(24), CLK, Dout(24), aux(24));
    FF25: flipflop port map(Din(25), CLK, Dout(25), aux(25));
    FF26: flipflop port map(Din(26), CLK, Dout(26), aux(26));
    FF27: flipflop port map(Din(27), CLK, Dout(27), aux(27));
    FF28: flipflop port map(Din(28), CLK, Dout(28), aux(28));
    FF29: flipflop port map(Din(29), CLK, Dout(29), aux(29));
    FF30: flipflop port map(Din(30), CLK, Dout(30), aux(30));
    FF31: flipflop port map(Din(31), CLK, Dout(31), aux(31));
end Behavioral;
