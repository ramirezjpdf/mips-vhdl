library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mips32_struct_testbench is
end entity;

architecture behav of mips32_struct_testbench is

component mips32_struct is
    port(CLK : in STD_LOGIC;
         MipsReadData : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal t_clk : std_logic;
begin
    mips32 : mips32_struct port map(t_clk);

    process
    variable cycles : integer := 13;
    begin
        t_clk <= '1';
        wait for 1 ps;
        for i in 0 to (cycles * 2) loop
            t_clk <= not t_clk;
            wait for 1 ps;
        end loop;
        wait;
    end process;
end behav;
