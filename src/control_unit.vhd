library ieeeç;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port(
        clk     : in std_logic;
        op_code ; in std_logic_vector (5 downto 0);
        
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
    
    end output_function;

end behav;