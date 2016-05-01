library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;


entity mips32_struct is
    port(CLK : in STD_LOGIC;
         MipsReadData : out STD_LOGIC_VECTOR (31 downto 0));    --Output of mips32_struct used for debuging during simulations
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
                 jr_signal : out std_logic
            );
    end component;
    
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
    
    component reg_aux is
        port(CLK : in std_logic;
            in_data : in std_logic_vector(31 downto 0);
            out_data: out std_logic_vector (31 downto 0));
    end component;
    
    component reg_special is
        port(CLK : in std_logic;
            write_signal : in std_logic;
            in_data : in std_logic_vector(31 downto 0);
            out_data: out std_logic_vector (31 downto 0));
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
    
    --Control signals
    signal ALUop,  ALUSrcB, PCSource, MemtoReg, RegDst : STD_LOGIC_VECTOR(1 downto 0);
    signal BNECond, PCWriteCond, PCWrite, IorD, RegWrite, MemWrite, MemRead, IRWrite, ALUSrcA : STD_LOGIC;
    
    --Memory signals
    signal Mem_Address, MemData : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --Register file signals
    signal WriteAddrs : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    signal RegWriteData, ReadData1, ReadData2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --ALU signals
    signal A, B, ALUresult : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal Zero : STD_LOGIC;
    
    --ALU control signals
    signal ALU_CONTROL_SIGNAL : STD_LOGIC_VECTOR (3 downto 0);
    signal JR_SIGNAL : STD_LOGIC;
    
    --Auxiliar Registers
    signal pc_out : STD_LOGIC_VECTOR (31 downto 0);
    signal pc_in : STD_LOGIC_VECTOR (31 downto 0);
    signal pc_write_signal : STD_LOGIC;
    signal ir_out : STD_LOGIC_VECTOR (31 downto 0);
    signal a_reg_out : std_logic_vector(31 downto 0); 
    signal b_reg_out : std_logic_vector(31 downto 0); 
    signal ALU_OUT_out_data : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal mdr_out : STD_LOGIC_VECTOR (31 downto 0);
    signal SignExt16_32 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal SignExt16_32_shift_left_2 : STD_LOGIC_VECTOR (31 downto 0);
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
                                                     ir_out(25 downto 21),   
                                                     ir_out(20 downto 16),   
                                                     WriteAddrs,   
                                                     RegWriteData, 
                                                     ReadData1,    
                                                     ReadData2);   
    
    ALU_MPIS32               : alu port map (A, 
                                             B,               
                                             ir_out(10 downto 6),           
                                             ALU_CONTROL_SIGNAL,  
                                             Zero,            
                                             ALUresult);         
    
    ALU_CONTROL1_MPIS32      : alu_control port map (ALUOp,
                                                     ir_out(5 downto 0),               
                                                     ALU_CONTROL_SIGNAL, 
                                                     JR_SIGNAL);          
    
    CONTROL_UNIT1_MPIS32     : control_unit port map (CLK, 
                                                      ir_out(31 downto 26),        
                                                      PCWriteCond, 
                                                      BNECond,      
                                                      PCWrite,      
                                                      IorD,        
                                                      MemRead,      
                                                      MemWrite,     
                                                      MemtoReg,    
                                                      IRWrite,      
                                                      RegWrite,     
                                                      RegDst,       
                                                      ALUOp,        
                                                      ALUSrcA,     
                                                      ALUSrcB,     
                                                      PCSource);

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
                                                REG_RA_ADDRES,
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
    SignExt16_32_shift_left_2 <= std_logic_vector(
                                     signed(SignExt16_32) sll  2);
    alu_source_b_mux         : mux_two generic map(MIPS32_DATA_LENGTH)
                                       port map(ALUSrcB,
                                                b_reg_out,
                                                x"00000001",
                                                SignExt16_32,
                                                SignExt16_32_shift_left_2,
                                                B);

    ALU_OUT                  : reg_aux port map(CLK,
                                                ALUresult,
                                                ALU_OUT_out_data);
                                                 
    jump_address(31 downto 28) <= pc_out(31 downto 28);
    jump_address(27 downto 2)  <= ir_out(25 downto 0);
    jump_address(1 downto 0)   <= "00";
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
    
end architecture;
