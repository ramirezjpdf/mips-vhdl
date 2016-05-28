library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

entity alu_control is
    port(
         alu_op : in std_logic_vector (2 downto 0);
         funct  : in std_logic_vector (5 downto 0);
         alu_control_out_signal : out std_logic_vector(3 downto 0);
         fpu_control_out_signal : out std_logic_vector(2 downto 0);
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
                fpu_control_out_signal <= (others => 'X');
                jr_signal              <= DEASSERTED;
            when BEQ_OR_BNE_SUB  => 
                alu_control_out_signal <= SUB_CONTROL;
                fpu_control_out_signal <= (others => 'X');
                jr_signal              <= DEASSERTED;
            when R_TYPE_INST =>
                case funct is
                    -- add
                    when ADD_FUNCT => 
                        alu_control_out_signal <= ADD_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- sub
                    when SUB_FUNCT => 
                        alu_control_out_signal <= SUB_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- and
                    when AND_FUNCT => 
                        alu_control_out_signal <= AND_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- or
                    when OR_FUNCT  => 
                        alu_control_out_signal <= OR_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- nor
                    when NOR_FUNCT => 
                        alu_control_out_signal <= NOR_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- slt
                    when SLT_FUNCT => 
                        alu_control_out_signal <= SLT_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- sll
                    when SLL_FUNCT => 
                        alu_control_out_signal <= SLL_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- srl
                    when SRL_FUNCT => 
                        alu_control_out_signal <= SRL_CONTROL;
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                    -- jr                                                             
                    when JR_FUNCT  =>                                                 
                            alu_control_out_signal <= ADD_CONTROL;                    
                            fpu_control_out_signal <= (others => 'X');                          
                            jr_signal <= ASSERTED;                                    
                    when others => 
                        alu_control_out_signal <= (others => 'X');
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;
                end case;
            when FP_TYPE_INST =>
                case funct is                                                               
                    -- add                                                                  
                    when FP_ADD_FUNCT =>                                                       
                        alu_control_out_signal <= (others => 'X');
                        fpu_control_out_signal <= FP_ADD_CONTROL;                              
                        jr_signal <= DEASSERTED;                    
                    -- sub                                                                  
                    when FP_SUB_FUNCT =>                                                       
                        alu_control_out_signal <= (others => 'X');                              
                        fpu_control_out_signal <= FP_SUB_CONTROL; 
                        jr_signal <= DEASSERTED;                  
                    -- multiply                                                                  
                    when FP_MUL_FUNCT =>                                                       
                        alu_control_out_signal <= (others => 'X');                              
                        fpu_control_out_signal <= FP_MUL_CONTROL; 
                        jr_signal <= DEASSERTED;                  
                    -- divide                                                                   
                    when FP_DIV_FUNCT  =>                                                       
                        alu_control_out_signal <= (others => 'X');                              
                        fpu_control_out_signal <= FP_DIV_CONTROL; 
                        jr_signal <= DEASSERTED;                  
                     -- square root                       
                    when FP_SQR_FUNCT  =>                        
                        alu_control_out_signal <= (others => 'X');        
                        fpu_control_out_signal <= FP_SQR_CONTROL;
                        jr_signal <= DEASSERTED;                                       
                                            
                    when others => 
                        alu_control_out_signal <= (others => 'X');
                        fpu_control_out_signal <= (others => 'X');
                        jr_signal <= DEASSERTED;                        
                end case;
            -- floating point division for DIVADD complex inst
            when DIV_FP =>
                alu_control_out_signal <= (others => 'X');
                fpu_control_out_signal <= FP_DIV_CONTROL;
                jr_signal <= DEASSERTED;
            -- floating point add for DIADD complex instr
            when ADD_FP =>
                alu_control_out_signal <= (others => 'X');
                fpu_control_out_signal <= FP_ADD_CONTROL;
                jr_signal <= DEASSERTED;                                                            
            when others => 
                alu_control_out_signal <= (others => 'X');
                fpu_control_out_signal <= (others => 'X');
                jr_signal <= DEASSERTED;
        end case;
    end process;
end behav;
