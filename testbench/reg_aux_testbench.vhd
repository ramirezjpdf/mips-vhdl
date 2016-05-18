library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;

entity reg_aux_testbench is
end reg_aux_testbench;

architecture behav of reg_aux_testbench is
component reg_aux is
    port(clk : in std_logic;
         in_data : in std_logic_vector(31 downto 0);
         out_data: out std_logic_vector (31 downto 0));
end component;
signal t_clk      : std_logic;
signal t_in_data  : std_logic_vector(31 downto 0);

begin
    ra : reg_aux port map(clk => t_clk, in_data => t_in_data);
    process
    begin
        t_clk <= '0';
        wait for 1 ps;
        t_in_data <= x"00000002";
        t_clk <= '1';
        wait for 1 ps;
        t_clk <= '0';
        wait for 1 ps;
        t_clk <= '1';
        wait for 1 ps;
        t_clk <= '0';
        wait for 1 ps;
        t_in_data <= x"0000000F";
        t_clk <= '1';
        wait for 1 ps;
        t_clk <= '0';
        wait for 1 ps;
        wait;
    end process;
end behav;