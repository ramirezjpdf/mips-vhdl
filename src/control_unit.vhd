library ieeeç;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        clk     : in std_logic;
        op_code : in std_logic_vector (5 downto 0);
        
        pc_write_cond : out std_logic;
        pc_write      : out std_logic;
        i_or_d        : out std_logic;
        mem_read      : out std_logic;
        mem_write     : out std_logic;
        mem_to_reg    : out std_logic_vector (1 downto 0);
        ir_write      : out std_logic;
        reg_write     : out std_logic;
        reg_dst       : out std_logic_vector (1 downto 0);
        alu_op        : out std_logic_vector (1 downto 0);
        alu_src_a     : out std_logic;
        alu_src_b     : out std_logic_vector (1 downto 0);
        pc_source     : out std_logic_vector (1 downto 0)
    );
end control_unit;

architecture behav of control_unit is

subtype state is integer range 0 to 12;

-- GENERAL STATES
constant INSTRUCTION_FETCH    : state := 0;
constant INST_DECODE_REG_READ : state := 1;
-- LW OR SW STATES
constant MEM_ADDR_COMP        : state := 2;
constant LW_MEM_ACCES         : state := 3;
constant MEM_READ_COMPLETION  : state := 4;
constant SW_MEM_ACCES         : state := 5;
-- R-TYPE ARITH AND LOGIC STATES
constant EXECUTION            : state := 6;
constant R_TYPE_COMPLETION    : state := 7;
-- BRANCH STATES
constant BRANCH_COMPLETION    : state := 8;
-- JUMP STATES
constant JUMP_COMPLETION      : state := 9;
constant JAL_COMPLETION       : state := 10;
constant JR_COMPLETION        : state := 11;
-- ADDI STATES
constant ADDI_EXECUTION       : state := MEM_ADDR_COMP;
constant ADDI_COMPLETION      : state := 12;

-- CURRENT_STATE
signal current_state : state := INSTRUCTION_FETCH;
begin
    next_state_function : process(clk)
    begin
        if rising_edge(clk) then
            case current_state is

                -- GENERAL STATES
                when INSTRUCTION_FETCH =>
                    current_state <= INST_DECODE_REG_READ;
                when INST_DECODE_REG_READ =>
                    case op_code is
                        when LW | SW =>
                            current_state <= MEM_ADDR_COMP;
                        when R_TYPE =>
                            current_state <= EXECUTION;
                        when BEQ | BNE =>
                            current_state <= BRANCH_COMPLETION;
                        when J =>
                            current_state <= JUMP_COMPLETION;
                        when JAL =>
                            current_state <= JAL_COMPLETION;
                        when ADDI =>
                            current_state <= ADDI_EXECUTION;
                        when others =>
                            current_state <= INSTRUCTION_FETCH;
                    end case;

                -- LW OR SW STATES
                -- this state is the same for addi and lw or sw
                when MEM_ADDR_COMP | ADDI_EXECUTION =>
                    case op_code is
                        when LW =>
                            current_state <= LW_MEM_ACCES;
                        when SW =>
                            current_state <= SW_MEM_ACCES;
                        when ADDI =>
                            current_state <= ADDI_COMPLETION
                        when others =>
                            current_state <= INSTRUCTION_FETCH;
                    end case;
                when LW_MEM_ACCES =>
                    current_state <= MEM_READ_COMPLETION;
                when SW_MEM_ACCES =>
                    current_state <= INSTRUCTION_FETCH;
                when MEM_READ_COMPLETION =>
                    current_state <= INSTRUCTION_FETCH;

                -- R-TYPE ARITH AND LOGIC STATES
                when EXECUTION =>
                    current_state <= R_TYPE_COMPLETION;
                when R_TYPE_COMPLETION =>
                    current_state <= INSTRUCTION_FETCH;

                -- BRANCH STATES
                when BRANCH_COMPLETION =>
                    current_state <= INSTRUCTION_FETCH;

                -- JUMP STATES
                when JUMP_COMPLETION | JAL_COMPLETION =>
                    current_state <= INSTRUCTION_FETCH;

                -- ADDI STATES
                when ADDI_COMPLETION =>
                    current_state <= INSTRUCTION_FETCH;

                -- OTHERS
                when others =>
                    current_state <= INSTRUCTION_FETCH;
            end case;
        end if;
    end next_state_function;

    output_function : process(current_state)
    begin
		case current_state is
			-- GENERAL STATES
			when INSTRUCTION_FETCH    =>
				pc_write_cond <= DEASSERTED;
				pc_write      <= ASSERTED;
				i_or_d        <= DEASSERTED;
				mem_read      <= ASSERTED;
				mem_write     <= DEASSERTED;
				mem_to_reg    <= ALU_OUT_MEM_TO_REG;
				ir_write      <= ASSERTED;
				reg_write     <= DEASSERTED;
				reg_dst       <= RT_REG_DST;
				alu_op        <= LW_OR_SW_ADD;
				alu_src_a     <= DEASSERTED;
				alu_src_b     <= FOUR_ALU_SRC_B;
				pc_source     <= ALU_RESULT_PC_SOURCE;
			when INST_DECODE_REG_READ =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= DEASSERTED;
			    alu_src_b     <= BRANCH_ADDR_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			-- LW OR SW STATES        =>
			when MEM_ADDR_COMP        =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= IMMED_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			when LW_MEM_ACCES         =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= ASSERTED;
			    mem_read      <= ASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= DEASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			when MEM_READ_COMPLETION  =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= MDR_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= ASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= DEASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			when SW_MEM_ACCES         =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= ASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= ASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= DEASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			-- R-TYPE ARITH AND LOGIC STATES
			when EXECUTION            =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= R_TYPE_INST;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			when R_TYPE_COMPLETION    =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= ASSERTED;
			    reg_dst       <= RD_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
			-- BRANCH STATES    
			when BRANCH_COMPLETION    =>
				pc_write_cond <= ASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= BEQ_OR_BNE_SUB;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_OUT_PC_SOURCE;
			-- JUMP STATES
			when JUMP_COMPLETION      =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= ASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= DEASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= JUMP_PC_SOURCE;
			when JAL_COMPLETION       =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= ASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= PC_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= ASSERTED;
			    reg_dst       <= RA_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= JUMP_PC_SOURCE;
			when JR_COMPLETION        =>
			-- think about it better
			-- the issue is that we need the funct
			-- part of intruction to know how to
			-- properly signalize this instruction
			-- ADDI STATES
			when ADDI_COMPLETION      =>
				pc_write_cond <= DEASSERTED; 
			    pc_write      <= DEASSERTED;
			    i_or_d        <= DEASSERTED;
			    mem_read      <= DEASSERTED;
			    mem_write     <= DEASSERTED;
			    mem_to_reg    <= ALU_OUT_MEM_TO_REG;
			    ir_write      <= DEASSERTED;
			    reg_write     <= ASSERTED;
			    reg_dst       <= RT_REG_DST;
			    alu_op        <= LW_OR_SW_ADD;
			    alu_src_a     <= ASSERTED;
			    alu_src_b     <= B_ALU_SRC_B;
			    pc_source     <= ALU_RESULT_PC_SOURCE;
		end case;
    
    end output_function;

end behav;