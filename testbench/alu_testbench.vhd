library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

entity alu_testbench is
end alu_testbench;

architecture behav of alu_testbench is

component alu is
port(
        a, b           : in std_logic_vector(31 downto 0);
        shamt          : in std_logic_vector(4 downto 0);
        alu_control_in : in std_logic_vector(3 downto 0);
        zero           : out std_logic;
        result         : out std_logic_vector(31 downto 0)
    );
end component;

signal t_a, t_b, t_result : std_logic_vector(31 downto 0);
signal t_shamt            : std_logic_vector(4 downto 0);
signal t_alu_control_in   : std_logic_vector(3 downto 0);
signal t_zero             : std_logic;

begin
    t_alu : alu port map(a              => t_a,
                         b              => t_b,
                         shamt          => t_shamt,
                         alu_control_in => t_alu_control_in,
                         zero           => t_zero,
                         result         => t_result 
                         );
    
    process
    begin
        t_a <= std_logic_vector(to_signed(2, t_a'length));
        t_b <= std_logic_vector(to_signed(2, t_b'length));
        t_shamt <= std_logic_vector(to_signed(1, t_shamt'length));

        -- ADD
        t_alu_control_in <= ADD_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "add operation zero output failed.";
        assert signed(t_result) = 4
            report "add operation result output failed.";

        -- SUB
        t_alu_control_in <= SUB_CONTROL;
        wait for 1 ps;

        assert t_zero = '1'
            report "sub operation zero output failed.";
        assert signed(t_result) = 0
            report "sub operation result output failed.";

        -- AND
        t_alu_control_in <= AND_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "snd operation zero output failed.";
        assert signed(t_result) = 2
            report "and operation result output failed.";

        -- OR
        t_alu_control_in <= OR_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "or operation zero output failed.";
        assert signed(t_result) = 2
            report "or operation result output failed.";

        -- NOR
        t_alu_control_in <= NOR_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "nor operation zero output failed.";
        assert t_result = x"FFFFFFFD"
            report "nor operation result output failed.";

        -- SLL
        t_alu_control_in <= SLL_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "sll operation zero output failed.";
        assert signed(t_result) = 4
            report "sll operation result output failed.";

        -- SRL
        t_alu_control_in <= SRL_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "srl operation zero output failed.";
        assert signed(t_result) = 1
            report "srl operation result output failed.";

        -- SLT a == b
        t_alu_control_in <= SLT_CONTROL;
        wait for 1 ps;

        assert t_zero = '1'
            report "slt a == b  operation zero output failed.";
        assert signed(t_result) = 0
            report "slt a == b operation result output failed.";

        -- SLT a > b
        t_a <= std_logic_vector(to_signed(3, t_a'length));
        t_alu_control_in <= SLT_CONTROL;
        wait for 1 ps;

        assert t_zero = '1'
            report "slt a > b  operation zero output failed.";
        assert signed(t_result) = 0
            report "slt a > b operation result output failed.";

        -- SLT a < b
        t_a <= std_logic_vector(to_signed(1, t_a'length));
        t_alu_control_in <= SLT_CONTROL;
        wait for 1 ps;

        assert t_zero = '0'
            report "slt a < b  operation zero output failed.";
        assert signed(t_result) = 1
            report "slt a < b operation result output failed.";

        wait for 1 ps;
        assert False report "Test End" ;
        wait;
    end process;
end behav;
