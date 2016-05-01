library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

entity alu_control is
    port(
         alu_op : in std_logic_vector (1 downto 0);
         funct  : in std_logic_vector (5 downto 0);
         alu_control_out_signal : out std_logic_vector(3 downto 0);
         jr_signal : out std_logic
    );
end alu_control;

architecture behav of alu_control is

begin
    process(alu_op, funct)
    begin
        case alu_op is
            when LW_OR_SW_ADD    =>
                alu_control_out_signal <= ADD_CONTROL;
                jr_signal              <= DEASSERTED;
            when BEQ_OR_BNE_SUB  => 
                alu_control_out_signal <= SUB_CONTROL;
                jr_signal              <= DEASSERTED;
            when R_TYPE_INST =>
                case funct is
                    -- add
                    when ADD_FUNCT => 
                        alu_control_out_signal <= ADD_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- sub
                    when SUB_FUNCT => 
                        alu_control_out_signal <= SUB_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- and
                    when AND_FUNCT => 
                        alu_control_out_signal <= AND_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- or
                    when OR_FUNCT  => 
                        alu_control_out_signal <= OR_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- nor
                    when NOR_FUNCT => 
                        alu_control_out_signal <= NOR_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- slt
                    when SLT_FUNCT => 
                        alu_control_out_signal <= SLT_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- sll
                    when SLL_FUNCT => 
                        alu_control_out_signal <= SLL_CONTROL;
                                                jr_signal <= DEASSERTED;
                    -- srl
                    when SRL_FUNCT => 
                        alu_control_out_signal <= SRL_CONTROL;
                                                jr_signal <= DEASSERTED;
                                        -- jr
                                        when JR_FUNCT  =>
                                                alu_control_out_signal <= ADD_CONTROL;
                                                jr_signal <= ASSERTED;
                    when others => alu_control_out_signal <= "XXXX";
                end case;
            when others => alu_control_out_signal <= "XXXX";
        end case;
    end process;
end behav;
