library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;


entity mips32 is
    port(CLK : in STD_LOGIC;
         MipsReadData : out STD_LOGIC_VECTOR (31 downto 0));    --Output of mips32 used for debuging during simulations
end entity;

architecture behav of mips32 is

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
	
	signal pc : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
	
	--Control signals
	signal OpCode : STD_LOGIC_VECTOR(5 downto 0);
	signal ALUop,  ALUSrcB, PCSource, MemtoReg, RegDst : STD_LOGIC_VECTOR(1 downto 0);
	signal BNECond, PCWriteCond, PCWrite, IorD, RegWrite, MemWrite, MemRead, IRWrite, ALUSrcA : STD_LOGIC;
	
	--Memory signals
    signal Mem_Address, MemWriteData, MemData : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --Register file signals
    signal ReadAddrs1, ReadAddrs2, WriteAddrs : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    signal RegWriteData, ReadData1, ReadData2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --ALU signals
    signal A, B, ALUresult : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal SHAMT : STD_LOGIC_VECTOR (5 downto 0);
    signal Zero : STD_LOGIC;
    
    --ALU control signals
    signal FUNCT : STD_LOGIC_VECTOR (5 downto 0);
    signal ALU_CONTROL_SIGNAL : STD_LOGIC_VECTOR (3 downto 0);
    signal JR_SIGNAL : STD_LOGIC;
    
    --Auxiliar Registers
    signal regA, regB, ALUOut : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal INSTR_REGISTER : STD_LOGIC_VECTOR (31 downto 0);
    signal MEM_DATA_REGISTER : STD_LOGIC_VECTOR (31 downto 0);
    signal SignExt16_32 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
begin

	process(CLK) is
	begin
		if rising_edge(CLK) then
            
            case IorD is    --Multiplexer controlled by IorD signal from control unit
             
                when '1'    => Mem_Address <= ALUOut; 
                when others => Mem_Address <= pc;                            
            end case;
            
            --MemRead <= '1'; 
            if  (PCWrite or (PCWriteCond and (zero xor BNECond))) then
            --if  or(unsigned(PCWrite), and(unsigned(PCWriteCond), xor(unsigned(zero), unsigned(BNECond)))) then
                case JR_SIGNAL is
                    when '1' => pc <= ALUOut;
                    when others =>
                        case PCSource is
                            when "01"   => pc <= ALUresult;
                            when "10"   => pc <= std_logic_vector(signed(INSTR_REGISTER(25 downto 0)) sll 2) & pc(31 downto 28);
                            when others => pc <= ALUOut;
                        end case;
                end case;
            else
                pc <= std_logic_vector(signed(pc) + x"00000001");  --PC + 1
            end if;
                                                      
            if IRWrite = '1' then
                INSTR_REGISTER <= MemData;  --Write instruction into Instruction Register
            end if;
            
            MEM_DATA_REGISTER <= MemData;   --Always write data into Memory Data Register
            MemWriteData <= regB;              --regB is wired direct to the data to write port of the memory 
            
            OpCode <= INSTR_REGISTER(31 downto 26);
            FUNCT <= INSTR_REGISTER(5 downto 0);
            SHAMT <= INSTR_REGISTER(10 downto 6);
            
            --Input signals and buses of Register File
            ReadAddrs1 <= INSTR_REGISTER(25 downto 21);
            ReadAddrs2 <= INSTR_REGISTER(20 downto 16);
            
            case RegDst is      --Multiplexer controlled by RegDst signal from control unit                  
                when "01"    => WriteAddrs <= INSTR_REGISTER(15 downto 11);   
                when others => WriteAddrs <= INSTR_REGISTER(20 downto 16);                                        
            end case;
            
            case MemtoReg is    --Multiplexer controlled by MemtoReg signal from control unit 
                when "1"    => RegWriteData <= MEM_DATA_REGISTER;
                when others => RegWriteData <= ALUOut;
            end case;
            
            regA <= ReadData1;
            regB <= ReadData2;           
                                          
            --Sign extend of Instruction[15-0] to 32 bits        
            SignExt16_32 <= std_logic_vector(resize(signed(INSTR_REGISTER(15 downto 0)), SignExt16_32'length));
            
            --ALU signals                                                    
            case ALUSrcA is      --Multiplexer controlled by ALUSrcA signal  from control unit                                                         
                when '1'    => A <= regA;                                    
                when others => A <= pc;                                                    
            end case;                                                        
                                                                             
            case ALUSrcB is      --Multiplexer controlled by ALUSrcB signal  from control unit                                                           
                when "01"   => B <= x"00000004";  
                when "10"   => B <= SignExt16_32;
                when "11"   => B <= std_logic_vector(signed(SignExt16_32) sll  2); --Instruction(15-0) extended to 32 and shifted to left by 2                         
                when others => B <= regB;                                                                 
            end case;  
            
            ALUOut <= ALUresult;
            MipsReadData  <= ALUOut; --MipsReadData is used only for debug                                                                            
                
         end if;
	end process;
	
	INSTR_DATA_MEMORY_MPIS32 : memory port map (CLK,
                                                MemRead,      
                                                MemWrite,     
                                                Mem_Address,  
                                                MemWriteData, 
                                                MemData);     
	
	REGISTER_FILE_MPIS32     : Register_v2 port map (CLK,
                                                     RegWrite,     
                                                     ReadAddrs1,   
                                                     ReadAddrs2,   
                                                     WriteAddrs,   
                                                     RegWriteData, 
                                                     ReadData1,    
                                                     ReadData2);   
	
	ALU_MPIS32               : alu port map (A, 
                                             B,               
                                             SHAMT,           
                                             ALU_CONTROL_SIGNAL,  
                                             Zero,            
                                             ALUresult);         
	
	ALU_CONTROL1_MPIS32      : alu_control port map (ALUOp,
                                                     FUNCT,               
                                                     ALU_CONTROL_SIGNAL, 
                                                     JR_SIGNAL);          
	
	CONTROL_UNIT1_MPIS32     : control_unit port map (CLK, 
                                                      OpCode,        
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
    
end architecture;
