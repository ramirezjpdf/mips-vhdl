----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2016 03:59:51 PM
-- Design Name: 
-- Module Name: 7segmentos - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity s7segmentos is
    Port ( CLK : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (31 downto 0);
           Anodo : out STD_LOGIC_VECTOR (7 downto 0);
           Catodo : out STD_LOGIC_VECTOR (7 downto 0));
end s7segmentos;


architecture behavioral of s7segmentos is
	type state_type is (an7,an6,an5,an4,an3,an2,an1,an0);
	signal state : state_type;
	
	constant SEVEN_0 : std_logic_vector(7 downto 0) := "11000000";
    constant SEVEN_1 : std_logic_vector(7 downto 0) := "11111001";
    constant SEVEN_2 : std_logic_vector(7 downto 0) := "10100100";
    constant SEVEN_3 : std_logic_vector(7 downto 0) := "10110000";
    constant SEVEN_4 : std_logic_vector(7 downto 0) := "10011001";
    constant SEVEN_5 : std_logic_vector(7 downto 0) := "10010010";
    constant SEVEN_6 : std_logic_vector(7 downto 0) := "10000010";
    constant SEVEN_7 : std_logic_vector(7 downto 0) := "11111000";
    constant SEVEN_8 : std_logic_vector(7 downto 0) := "10000000";
    constant SEVEN_9 : std_logic_vector(7 downto 0) := "10011000";
    constant SEVEN_A : std_logic_vector(7 downto 0) := "10001000";
    constant SEVEN_B : std_logic_vector(7 downto 0) := "10000011";
    constant SEVEN_C : std_logic_vector(7 downto 0) := "11000110";
    constant SEVEN_D : std_logic_vector(7 downto 0) := "10100001";
    constant SEVEN_E : std_logic_vector(7 downto 0) := "10000110";
    constant SEVEN_F : std_logic_vector(7 downto 0) := "10001110";
    
    type SEGMENT is array(0 to 15) of std_logic_vector(0 to 7);
    constant SEVENS : SEGMENT :=
    ((SEVEN_0), (SEVEN_1), (SEVEN_2), (SEVEN_3), (SEVEN_4), (SEVEN_5), (SEVEN_6),
     (SEVEN_7), (SEVEN_8), (SEVEN_9), (SEVEN_A), (SEVEN_B), (SEVEN_C), (SEVEN_D),
     (SEVEN_E), (SEVEN_F)
    );

begin
	process(CLK)
	   function to_display_digit(hex_data : in std_logic_vector(3 downto 0))
                               return std_logic_vector is
       begin
           return SEVENS(to_integer(unsigned(hex_data)));
       end to_display_digit;
	
	begin
		if(rising_edge(CLK))then
			case state is
				when an0 =>
					Anodo <= "11111110";
				    Catodo <= to_display_digit(Data(3 downto 0));
				when an1 =>
					Anodo <= "11111101";
					Catodo <= to_display_digit(Data(7 downto 4));
				when an2 =>
					Anodo <= "11111011";
					Catodo <= to_display_digit(Data(11 downto 8));
				when an3 =>
					Anodo <= "11110111";
					Catodo <= to_display_digit(Data(15 downto 12));
				when an4 =>
					Anodo <= "11101111";
					Catodo <= to_display_digit(Data(19 downto 16));
				when an5 =>
					Anodo <= "11011111";
					Catodo <= to_display_digit(Data(23 downto 20));
				when an6 =>
					Anodo <= "10111111";
					Catodo <= to_display_digit(Data(27 downto 24));
				when an7 =>
					Anodo <= "01111111";
					Catodo <= to_display_digit(Data(31 downto 28));
			end case;
		end if;
	end process;
	
	process(CLK)
	begin
		if(rising_edge(CLK))then
			case state is
				when an0 => 
					state <= an1;
				when an1 =>
					state <= an2;
				when an2 =>
					state <= an3;
				when an3 =>
					state <= an4;
				when an4 =>
					state <= an5;
				when an5 =>
					state <= an6;
				when an6 =>
					state <= an7;
				when an7 =>
					state <= an0;
				when others =>
					state <= an0;
			end case;
		end if;
	end process;
end behavioral;