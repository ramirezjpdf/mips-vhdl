library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;


entity mips32_struct is
    port(CLK : in STD_LOGIC;
         LED : out STD_LOGIC_VECTOR (31 downto 0));
end entity;

architecture struct of mips32_struct is

    component memory is 
        Port ( CLK : in STD_LOGIC;                                  
               MemRead : in STD_LOGIC;                                
               MemWrite : in STD_LOGIC;                               
               Address : in STD_LOGIC_VECTOR (31 downto 0);           
               WriteData : in STD_LOGIC_VECTOR (31 downto 0);         
               MemData : out STD_LOGIC_VECTOR (31 downto 0));         
    end component;
    
    component Register_v2 is
       Port (  CLK : in STD_LOGIC;
               RegWrite : in STD_LOGIC;
               ReadAddrs1 : in STD_LOGIC_VECTOR (4 downto 0);
               ReadAddrs2 : in STD_LOGIC_VECTOR (4 downto 0);
               WriteAddrs : in STD_LOGIC_VECTOR (4 downto 0);
               WriteData : in STD_LOGIC_VECTOR (31 downto 0);
               ReadData1 : out STD_LOGIC_VECTOR (31 downto 0);
               ReadData2 : out STD_LOGIC_VECTOR (31 downto 0));
    end component;
    
    component alu is
        port(
            a, b           : in std_logic_vector(31 downto 0);
            shamt          : in std_logic_vector(4 downto 0);
            alu_control_in : in std_logic_vector(3 downto 0);
            zero           : out std_logic;
            result         : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component alu_control is
        port(
                 alu_op : in std_logic_vector (1 downto 0);
                 funct  : in std_logic_vector (5 downto 0);
                 alu_control_out_signal : out std_logic_vector(3 downto 0);
                 fpu_control_out_signal : out std_logic_vector(2 downto 0);
                 jr_signal : out std_logic
            );
    end component;
    
    component control_unit is
        port(
            clk       : in std_logic;
            op_code   : in std_logic_vector (5 downto 0);
            fpu_ready : in std_logic;
            
            pc_write_cond : out std_logic;
            bne_cond      : out std_logic;
            pc_write      : out std_logic;
            i_or_d        : out std_logic;
            RASrc         : out std_logic;
            mem_read      : out std_logic;
            mem_write     : out std_logic;
            mem_to_reg    : out std_logic_vector (1 downto 0);
            ir_write      : out std_logic;
            reg_write     : out std_logic;
            reg_dst       : out std_logic_vector (1 downto 0);
            alu_op        : out std_logic_vector (1 downto 0);
            alu_src_a     : out std_logic;
            alu_src_b     : out std_logic_vector (1 downto 0);
            aluout_src    : out std_logic;
            pc_source     : out std_logic_vector (1 downto 0);
            start_fpu     : out std_logic;
            out_led_write : out std_logic
        );
    end component;
    
    component reg_aux is
        generic(data_length     : integer := MIPS32_DATA_LENGTH;
                is_rising_edge  : boolean := True);
        port(CLK : in std_logic;
            in_data : in std_logic_vector(31 downto 0);
            out_data: out std_logic_vector (31 downto 0));
    end component;
    
    component reg_special is
        generic(data_length     : integer := MIPS32_DATA_LENGTH;
                is_rising_edge  : boolean := True);
        port(CLK : in std_logic;
            write_signal : in std_logic;
            in_data : in std_logic_vector(data_length - 1 downto 0);
            out_data: out std_logic_vector (data_length - 1 downto 0));
    end component;
    
    component mux_one is
    generic (data_length : integer);
    port(sel : in std_logic;
         in0_data : in std_logic_vector(data_length - 1 downto 0);
         in1_data : in std_logic_vector(data_length - 1 downto 0);
         out_data: out std_logic_vector(data_length - 1 downto 0));
    end component;
    
    component mux_two is
    generic(data_length : integer);
    port(sel : in std_logic_vector(1 downto 0);
         in0_data : in std_logic_vector(data_length - 1 downto 0);
         in1_data : in std_logic_vector(data_length - 1 downto 0);
         in2_data : in std_logic_vector(data_length - 1 downto 0);
         in3_data : in std_logic_vector(data_length - 1 downto 0);
         out_data: out std_logic_vector(data_length - 1 downto 0));
    end component;
    
    component fpu is
        port (
            clk_i             : in std_logic;
    
            -- Input Operands A & B
            opa_i            : in std_logic_vector(31 downto 0);  -- Default: FP_WIDTH=32 
            opb_i           : in std_logic_vector(31 downto 0);
            
            -- fpu operations (fpu_op_i):
            -- ========================
            -- 000 = add, 
            -- 001 = substract, 
            -- 010 = multiply, 
            -- 011 = divide,
            -- 100 = square root
            -- 101 = unused
            -- 110 = unused
            -- 111 = unused
            fpu_op_i        : in std_logic_vector(2 downto 0);
            
            -- Rounding Mode: 
            -- ==============
            -- 00 = round to nearest even(default), 
            -- 01 = round to zero, 
            -- 10 = round up, 
            -- 11 = round down
            rmode_i         : in std_logic_vector(1 downto 0);
            
            -- Output port   
            output_o        : out std_logic_vector(31 downto 0);
            
            -- Control signals
            start_i            : in std_logic; -- is also restart signal
            ready_o         : out std_logic;
            
            -- Exceptions
            ine_o             : out std_logic; -- inexact
            overflow_o      : out std_logic; -- overflow
            underflow_o     : out std_logic; -- underflow
            div_zero_o      : out std_logic; -- divide by zero
            inf_o            : out std_logic; -- infinity
            zero_o            : out std_logic; -- zero
            qnan_o            : out std_logic; -- queit Not-a-Number
            snan_o            : out std_logic -- signaling Not-a-Number
        );   
    end component;
    
    --Control signals
    signal ALUop,  ALUSrcB, PCSource, MemtoReg, RegDst      : STD_LOGIC_VECTOR(1 downto 0);
    signal BNECond, PCWriteCond, PCWrite, IorD, RegWrite,
           MemWrite, MemRead, IRWrite, ALUSrcA, OutLedWrite,
           ALUOUT_SRC, START_FPU, FPU_READY, RASrc : STD_LOGIC;
    
    --Memory signals
    signal Mem_Address, MemData : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --Register file signals
    signal WriteAddrs, read_register_1, read_register_2 : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    signal RegWriteData, ReadData1, ReadData2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --ALU signals
    signal A, B, ALUresult : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal Zero : STD_LOGIC;
    
    --ALU control signals
    signal ALU_CONTROL_SIGNAL : STD_LOGIC_VECTOR (3 downto 0);
    SIGNAL FPU_CONTROL_SIGNAL : STD_LOGIC_VECTOR (2 downto 0);
    signal JR_SIGNAL : STD_LOGIC;
    
    --pc signals
    signal pc_out : STD_LOGIC_VECTOR (31 downto 0);
    signal pc_in : STD_LOGIC_VECTOR (31 downto 0);
    signal pc_write_signal : STD_LOGIC;

    --ir signals
    signal ir_out : STD_LOGIC_VECTOR (31 downto 0);

    --alu signals
    signal a_reg_out : std_logic_vector(31 downto 0); 
    signal b_reg_out : std_logic_vector(31 downto 0); 
    signal SignExt16_32 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --aluout signals
    signal ALU_OUT_out_data, ALUOUT_IN : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --fpu signals
    signal FPU_RESULT : STD_LOGIC_VECTOR (31 DOWNTO 0) := X"00000000";

    --mdr signals
    signal mdr_out : STD_LOGIC_VECTOR (31 downto 0);
    
    --jump signals
    signal jump_address : STD_LOGIC_VECTOR (31 downto 0);
    signal pc_source_mux1_out: STD_LOGIC_VECTOR (31 downto 0);

    
    
begin
    INSTR_DATA_MEMORY_MPIS32 : memory port map (CLK,
                                                MemRead,      
                                                MemWrite,     
                                                Mem_Address,  
                                                b_reg_out, 
                                                MemData);     
    
    REGISTER_FILE_MPIS32     : Register_v2 port map (CLK,
                                                     RegWrite,     
                                                     read_register_1,   
                                                     read_register_2,   
                                                     WriteAddrs,   
                                                     RegWriteData, 
                                                     ReadData1,    
                                                     ReadData2); 
                                                     
    read_register_1_mux      : mux_one generic map(REG_FILE_ADDR_LENGTH)
                                          port map(RASrc,                                                                 
                                                   ir_out(25 downto 21),                                                               
                                                   ir_out(20 downto 16),                                                     
                                                   read_register_1);                                                         
                                                                                                      
    read_register_2_mux      : mux_one generic map(REG_FILE_ADDR_LENGTH)
                                          port map(RASrc,                                                                                                                
                                                   ir_out(20 downto 16),                                                                                                              
                                                   ir_out(15 downto 11),                                                                                                    
                                                   read_register_2);                                                                                                        
    
    ALU_MPIS32               : alu port map (A, 
                                             B,               
                                             ir_out(10 downto 6),           
                                             ALU_CONTROL_SIGNAL,  
                                             Zero,            
                                             ALUresult);         
    
    ALU_CONTROL1_MPIS32      : alu_control port map (ALUOp,
                                                     ir_out(5 downto 0),               
                                                     ALU_CONTROL_SIGNAL,
                                                     FPU_CONTROL_SIGNAL, 
                                                     JR_SIGNAL);          
    
    CONTROL_UNIT1_MPIS32     : control_unit port map (CLK, 
                                                      ir_out(31 downto 26),
                                                      FPU_READY,        
                                                      PCWriteCond, 
                                                      BNECond,      
                                                      PCWrite,      
                                                      IorD,
                                                      RASrc,        
                                                      MemRead,      
                                                      MemWrite,     
                                                      MemtoReg,    
                                                      IRWrite,      
                                                      RegWrite,     
                                                      RegDst,       
                                                      ALUOp,        
                                                      ALUSrcA,     
                                                      ALUSrcB,
                                                      ALUOUT_SRC,     
                                                      PCSource,
                                                      START_FPU,
                                                      OutLedWrite);

    pc_write_signal <= PCWrite or (PCWriteCond and(BNECond xor Zero));
    PC                       : reg_special port map (CLK,
                                                     pc_write_signal,
                                                     pc_in,
                                                     pc_out);

    i_or_d_mux               : mux_one generic map(MIPS32_DATA_LENGTH)
                                       port map (IorD,
                                                 pc_out,
                                                 ALU_OUT_out_data,
                                                 Mem_Address);
 
    IR                       : reg_special port map (CLK,
                                                     IRWrite,
                                                     MemData,
                                                     ir_out);

    MEMORY_DATA_REGISTER     : reg_aux port map (CLK,
                                                 MemData,
                                                 mdr_out);

    write_reg_addr_mux       : mux_two generic map(REG_FILE_ADDR_LENGTH) 
                                       port map(RegDst,
                                                ir_out(20 downto 16),
                                                ir_out(15 downto 11),
                                                ir_out(10 downto 6),
                                                "XXXXX",
                                                WriteAddrs);
                                                
    write_reg_data_mux       : mux_two generic map(MIPS32_DATA_LENGTH) 
                                       port map(MemtoReg,
                                                ALU_OUT_out_data,
                                                mdr_out,
                                                pc_out,
                                                "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                                                RegWriteData);
                                                
    A_REG                    : reg_aux port map(CLK,
                                                ReadData1,
                                                a_reg_out);
                                                
    alu_source_a_mux         : mux_one generic map(MIPS32_DATA_LENGTH)
                                       port map(ALUSrcA,
                                                pc_out,
                                                a_reg_out,
                                                A);
                                                
    B_REG                    : reg_aux port map(CLK,
                                                ReadData2,
                                                b_reg_out);
                                                
    SignExt16_32 <= std_logic_vector(resize(signed(ir_out(15 downto 0)),
                                     SignExt16_32'length));
    
    alu_source_b_mux         : mux_two generic map(MIPS32_DATA_LENGTH)
                                       port map(ALUSrcB,
                                                b_reg_out,
                                                x"00000001",
                                                SignExt16_32,
                                                SignExt16_32,
                                                B);

    ALU_OUT                  : reg_aux port map(CLK,
                                                ALUOUT_IN,
                                                ALU_OUT_out_data);
                                                 
    jump_address <= pc_out(31 downto 28) &
                    std_logic_vector(
                        resize(unsigned(ir_out(25 downto 0)), 28));
    pc_source_mux1            : mux_two generic map(MIPS32_DATA_LENGTH)
                                        port map(PCSource,
                                                 ALUresult,
                                                 ALU_OUT_out_data,
                                                 jump_address,
                                                 pc_out,
                                                 pc_source_mux1_out);
                                                 
    pc_source_mux2            : mux_one generic map(MIPS32_DATA_LENGTH)
                                        port map(JR_SIGNAL,
                                                 pc_source_mux1_out,
                                                 ALU_OUT_out_data,
                                                 pc_in);
    
    out_led_reg_special       : reg_special generic map(MIPS32_DATA_LENGTH)
                                            port map(CLK,
                                                     OutLedWrite,
                                                     ALUresult,
                                                     LED);
                                                     
    aluout_source_mux         : mux_one generic map(MIPS32_DATA_LENGTH)
                                           port map(ALUOUT_SRC,                                                   
                                                    ALUresult,                                                    
                                                    FPU_RESULT,                                                 
                                                    ALUOUT_IN);                                                        
    
    fp_unit                   : fpu port map (CLK,
                                                A,
                                                B,
                                              FPU_CONTROL_SIGNAL,
                                              "00",
                                              FPU_RESULT,
                                              START_FPU,
                                              FPU_READY);
end architecture;
