library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.const.all;

entity control_unit_testbench is
end control_unit_testbench;


architecture behav of control_unit_testbench is


component control_unit is
    port(
        clk     : in std_logic;
        op_code : in std_logic_vector (5 downto 0);
        
        pc_write_cond : out std_logic;
        bne_cond      : out std_logic;
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
end component;

signal t_clk           : std_logic;
signal t_op_code       : std_logic_vector (5 downto 0);

signal t_pc_write_cond : std_logic;
signal t_bne_cond      : std_logic;
signal t_pc_write      : std_logic;
signal t_i_or_d        : std_logic;
signal t_mem_read      : std_logic;
signal t_mem_write     : std_logic;
signal t_mem_to_reg    : std_logic_vector (1 downto 0);
signal t_ir_write      : std_logic;
signal t_reg_write     : std_logic;
signal t_reg_dst       : std_logic_vector (1 downto 0);
signal t_alu_op        : std_logic_vector (1 downto 0);
signal t_alu_src_a     : std_logic;
signal t_alu_src_b     : std_logic_vector (1 downto 0);
signal t_pc_source     : std_logic_vector (1 downto 0);

begin
    cun : control_unit port map (clk => t_clk,
                                 op_code => t_op_code,
                                 
                                 pc_write_cond => t_pc_write_cond,
                                 bne_cond      => t_bne_cond,
                                 pc_write      => t_pc_write,
                                 i_or_d        => t_i_or_d,
                                 mem_read      => t_mem_read,
                                 mem_write     => t_mem_write,
                                 mem_to_reg    => t_mem_to_reg,
                                 ir_write      => t_ir_write,
                                 reg_write     => t_reg_write,
                                 reg_dst       => t_reg_dst,
                                 alu_op        => t_alu_op,
                                 alu_src_a     => t_alu_src_a,
                                 alu_src_b     => t_alu_src_b,
                                 pc_source     => t_pc_source
                                 );
    process
    procedure assert_inst_fetch(
        pc_write_cond : std_logic;
        bne_cond      : std_logic;
        pc_write      : std_logic;
        i_or_d        : std_logic;
        mem_read      : std_logic;
        mem_write     : std_logic;
        mem_to_reg    : std_logic_vector (1 downto 0);
        ir_write      : std_logic;
        reg_write     : std_logic;
        reg_dst       : std_logic_vector (1 downto 0);
        alu_op        : std_logic_vector (1 downto 0);
        alu_src_a     : std_logic;
        alu_src_b     : std_logic_vector (1 downto 0);
        pc_source     : std_logic_vector (1 downto 0)
    )  is
    begin
        assert pc_write_cond = DEASSERTED report "pc_write_cond Instruction fetch state error";
        assert bne_cond      = DEASSERTED report "bne_cond Instruction fetch state error";
        assert pc_write      = ASSERTED report "pc_write Instruction fetch state error";
        assert i_or_d        = DEASSERTED report "i_or_d Instruction fetch state error";
        assert mem_read      = ASSERTED report "mem_read Instruction fetch state error";
        assert mem_write     = DEASSERTED report "mem_write InsInstruction fetch state error";
        assert mem_to_reg    = ALU_OUT_MEM_TO_REG report "mem_to_reg Instruction fetch state error";
        assert ir_write      = ASSERTED report "ir_write Instruction fetch state error";
        assert reg_write     = DEASSERTED report "reg_write Instruction fetch state error";
        assert reg_dst       = RT_REG_DST report "reg_dst Instruction fetch state error";
        assert alu_op        = LW_OR_SW_ADD report "alu_op Instruction fetch state error";
        assert alu_src_a     = DEASSERTED report "alu_src_a Instruction fetch state error";
        assert alu_src_b     = FOUR_ALU_SRC_B report "alu_src_b Instruction fetch state error";
        assert pc_source     = ALU_RESULT_PC_SOURCE report "pc_source Instruction fetch state error";
        
    end procedure assert_inst_fetch;
    
    procedure assert_reg_read_inst_decode(
        pc_write_cond : std_logic;
        bne_cond      : std_logic;
        pc_write      : std_logic;
        i_or_d        : std_logic;
        mem_read      : std_logic;
        mem_write     : std_logic;
        mem_to_reg    : std_logic_vector (1 downto 0);
        ir_write      : std_logic;
        reg_write     : std_logic;
        reg_dst       : std_logic_vector (1 downto 0);
        alu_op        : std_logic_vector (1 downto 0);
        alu_src_a     : std_logic;
        alu_src_b     : std_logic_vector (1 downto 0);
        pc_source     : std_logic_vector (1 downto 0)
    )  is
    begin
        assert pc_write_cond = DEASSERTED report "pc_write_cond Instruction decode state error";
        assert bne_cond      = DEASSERTED report "bne_cond Instruction decode state error";
        assert pc_write      = DEASSERTED report "pc_write Instruction decode state error";
        assert i_or_d        = DEASSERTED report "i_or_d Instruction decode state error";
        assert mem_read      = DEASSERTED report "mem_read Instruction decode state error";
        assert mem_write     = DEASSERTED report "mem_write Instruction decode state error";
        assert mem_to_reg    = ALU_OUT_MEM_TO_REG report "mem_to_reg Instruction decode state error";
        assert ir_write      = DEASSERTED report "ir_write Instruction decode state error";
        assert reg_write     = DEASSERTED report "reg_write Instruction decode state error";
        assert reg_dst       = RT_REG_DST report "reg_dst Instruction decode state error";
        assert alu_op        = LW_OR_SW_ADD report "alu_op Instruction decode state error";
        assert alu_src_a     = DEASSERTED report "alu_src_a Instruction decode state error";
        assert alu_src_b     = BRANCH_ADDR_ALU_SRC_B report "alu_src_b Instruction decode state error";
        assert pc_source     = ALU_RESULT_PC_SOURCE report "pc_source Instruction decode state error";
    end procedure assert_reg_read_inst_decode;
    
    procedure assert_lwsw_addr_calc_addi_exec(
        pc_write_cond : std_logic;
        bne_cond      : std_logic;
        pc_write      : std_logic;
        i_or_d        : std_logic;
        mem_read      : std_logic;
        mem_write     : std_logic;
        mem_to_reg    : std_logic_vector (1 downto 0);
        ir_write      : std_logic;
        reg_write     : std_logic;
        reg_dst       : std_logic_vector (1 downto 0);
        alu_op        : std_logic_vector (1 downto 0);
        alu_src_a     : std_logic;
        alu_src_b     : std_logic_vector (1 downto 0);
        pc_source     : std_logic_vector (1 downto 0)
    )  is
    begin
        assert pc_write_cond = DEASSERTED report "pc_write_cond  address calc state error";
        assert bne_cond      = DEASSERTED report "bne_cond       address calc state error";
        assert pc_write      = DEASSERTED report "pc_write       address calc state error";
        assert i_or_d        = DEASSERTED report "i_or_d         address calc state error";
        assert mem_read      = DEASSERTED report "mem_read       address calc state error";
        assert mem_write     = DEASSERTED report "mem_write      address calc state error";
        assert mem_to_reg    = ALU_OUT_MEM_TO_REG report "mem_to_reg     address calc state error";
        assert ir_write      = DEASSERTED report "ir_write       address calc state error";
        assert reg_write     = DEASSERTED report "reg_write      address calc state error";
        assert reg_dst       = RT_REG_DST report "reg_dst        address calc state error";
        assert alu_op        = LW_OR_SW_ADD report "alu_op         address calc state error";
        assert alu_src_a     = ASSERTED report "alu_src_a      address calc state error";
        assert alu_src_b     = IMMED_ALU_SRC_B report "alu_src_b      address calc state error";
        assert pc_source     = ALU_RESULT_PC_SOURCE report "pc_source      address calc state error";
    end procedure assert_lwsw_addr_calc_addi_exec;
    
    procedure assert_lw_mem_access(
        pc_write_cond : std_logic;
        bne_cond      : std_logic;
        pc_write      : std_logic;
        i_or_d        : std_logic;
        mem_read      : std_logic;
        mem_write     : std_logic;
        mem_to_reg    : std_logic_vector (1 downto 0);
        ir_write      : std_logic;
        reg_write     : std_logic;
        reg_dst       : std_logic_vector (1 downto 0);
        alu_op        : std_logic_vector (1 downto 0);
        alu_src_a     : std_logic;
        alu_src_b     : std_logic_vector (1 downto 0);
        pc_source     : std_logic_vector (1 downto 0)
    )  is
    begin
        assert pc_write_cond = DEASSERTED report "pc_write_cond mem access state error";
        assert bne_cond      = DEASSERTED report "bne_cond      mem access state error";
        assert pc_write      = DEASSERTED report "pc_write      mem access state error";
        assert i_or_d        = ASSERTED report "i_or_d        mem access state error";
        assert mem_read      = ASSERTED report "mem_read      mem access state error";
        assert mem_write     = DEASSERTED report "mem_write     mem access state error";
        assert mem_to_reg    = ALU_OUT_MEM_TO_REG report "mem_to_reg    mem access state error";
        assert ir_write      = DEASSERTED report "ir_write      mem access state error";
        assert reg_write     = DEASSERTED report "reg_write     mem access state error";
        assert reg_dst       = RT_REG_DST report "reg_dst       mem access state error";
        assert alu_op        = LW_OR_SW_ADD report "alu_op        mem access state error";
        assert alu_src_a     = DEASSERTED report "alu_src_a     mem access state error";
        assert alu_src_b     = B_ALU_SRC_B report "alu_src_b     mem access state error";
        assert pc_source     = ALU_RESULT_PC_SOURCE report "pc_source     mem access state error";
    end procedure assert_lw_mem_access;
    
    procedure assert_lw_reg_write(
        pc_write_cond : std_logic;
        bne_cond      : std_logic;
        pc_write      : std_logic;
        i_or_d        : std_logic;
        mem_read      : std_logic;
        mem_write     : std_logic;
        mem_to_reg    : std_logic_vector (1 downto 0);
        ir_write      : std_logic;
        reg_write     : std_logic;
        reg_dst       : std_logic_vector (1 downto 0);
        alu_op        : std_logic_vector (1 downto 0);
        alu_src_a     : std_logic;
        alu_src_b     : std_logic_vector (1 downto 0);
        pc_source     : std_logic_vector (1 downto 0)
    )  is
    begin
        assert pc_write_cond = DEASSERTED report "pc_write_cond mem read state error";
        assert bne_cond      = DEASSERTED report "bne_cond      mem read state error";
        assert pc_write      = DEASSERTED report "pc_write      mem read state error";
        assert i_or_d        = DEASSERTED report "i_or_d        mem read state error";
        assert mem_read      = DEASSERTED report "mem_read      mem read state error";
        assert mem_write     = DEASSERTED report "mem_write     mem read state error";
        assert mem_to_reg    = MDR_MEM_TO_REG report "mem_to_reg    mem read state error";
        assert ir_write      = DEASSERTED report "ir_write      mem read state error";
        assert reg_write     = ASSERTED report "reg_write     mem read state error";
        assert reg_dst       = RT_REG_DST report "reg_dst       mem read state error";
        assert alu_op        = LW_OR_SW_ADD report "alu_op        mem read state error";
        assert alu_src_a     = DEASSERTED report "alu_src_a     mem read state error";
        assert alu_src_b     = B_ALU_SRC_B report "alu_src_b     mem read state error";
        assert pc_source     = ALU_RESULT_PC_SOURCE report "pc_source     mem read state error";
    end procedure assert_lw_reg_write;
    
    
    begin
        -- LW

        -- INSTRUCTION FETCH
        t_clk <= '0';
        wait for 1 ps;
        t_clk <= '1';
        assert_inst_fetch(pc_write_cond => t_pc_write_cond,
                          bne_cond      => t_bne_cond,
                          pc_write      => t_pc_write,
                          i_or_d        => t_i_or_d,
                          mem_read      => t_mem_read,
                          mem_write     => t_mem_write,
                          mem_to_reg    => t_mem_to_reg,
                          ir_write      => t_ir_write,
                          reg_write     => t_reg_write,
                          reg_dst       => t_reg_dst,
                          alu_op        => t_alu_op,
                          alu_src_a     => t_alu_src_a,
                          alu_src_b     => t_alu_src_b,
                          pc_source     => t_pc_source);
        t_op_code <= LW;
        wait for 1 ps;
        t_clk <= '0';

        -- REGISTER READ / INST DECODE
        wait for 1 ps;
        t_clk <= '1';
        assert_reg_read_inst_decode(pc_write_cond => t_pc_write_cond,
                                    bne_cond      => t_bne_cond,
                                    pc_write      => t_pc_write,
                                    i_or_d        => t_i_or_d,
                                    mem_read      => t_mem_read,
                                    mem_write     => t_mem_write,
                                    mem_to_reg    => t_mem_to_reg,
                                    ir_write      => t_ir_write,
                                    reg_write     => t_reg_write,
                                    reg_dst       => t_reg_dst,
                                    alu_op        => t_alu_op,
                                    alu_src_a     => t_alu_src_a,
                                    alu_src_b     => t_alu_src_b,
                                    pc_source     => t_pc_source);
        wait for 1 ps;
        t_clk <= '0';

        -- ADDRESS CALCULATION
        wait for 1 ps;
        t_clk <= '1';
        assert_lwsw_addr_calc_addi_exec(pc_write_cond => t_pc_write_cond,
                         bne_cond      => t_bne_cond,
                         pc_write      => t_pc_write,
                         i_or_d        => t_i_or_d,
                         mem_read      => t_mem_read,
                         mem_write     => t_mem_write,
                         mem_to_reg    => t_mem_to_reg,
                         ir_write      => t_ir_write,
                         reg_write     => t_reg_write,
                         reg_dst       => t_reg_dst,
                         alu_op        => t_alu_op,
                         alu_src_a     => t_alu_src_a,
                         alu_src_b     => t_alu_src_b,
                         pc_source     => t_pc_source);
        wait for 1 ps;
        t_clk <= '0';

        -- MEM ACCESS
        wait for 1 ps;
        t_clk <= '1';
        assert_lw_mem_access(pc_write_cond => t_pc_write_cond,
                          bne_cond      => t_bne_cond,
                          pc_write      => t_pc_write,
                          i_or_d        => t_i_or_d,
                          mem_read      => t_mem_read,
                          mem_write     => t_mem_write,
                          mem_to_reg    => t_mem_to_reg,
                          ir_write      => t_ir_write,
                          reg_write     => t_reg_write,
                          reg_dst       => t_reg_dst,
                          alu_op        => t_alu_op,
                          alu_src_a     => t_alu_src_a,
                          alu_src_b     => t_alu_src_b,
                          pc_source     => t_pc_source);
        wait for 1 ps;
        t_clk <= '0';

        -- REGISTER WRITE
        wait for 1 ps;
        t_clk <= '1';
        assert_lw_reg_write(pc_write_cond => t_pc_write_cond,
                         bne_cond      => t_bne_cond,
                         pc_write      => t_pc_write,
                         i_or_d        => t_i_or_d,
                         mem_read      => t_mem_read,
                         mem_write     => t_mem_write,
                         mem_to_reg    => t_mem_to_reg,
                         ir_write      => t_ir_write,
                         reg_write     => t_reg_write,
                         reg_dst       => t_reg_dst,
                         alu_op        => t_alu_op,
                         alu_src_a     => t_alu_src_a,
                         alu_src_b     => t_alu_src_b,
                         pc_source     => t_pc_source);
        wait for 1 ps;
        t_clk <= '0';
        
        wait for 1 ps;
        assert False report "Test end";
        wait;
    end process;

end behav;