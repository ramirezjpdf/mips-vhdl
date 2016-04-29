library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.const.all;


entity mips32 is
    port(CLK : in STD_LOGIC;
         ReadData : out STD_LOGIC_VECTOR (31 downto 0));
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
	
	signal pc : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
	
	--Control signals
	signal OpCode : STD_LOGIC_VECTOR(5 downto 0) := "000000";
	signal IorD, RegWrite, RegDst, MemWrite, MemtoReg : STD_LOGIC := '0';
	signal  MemRead, IRWrite : STD_LOGIC := '1';
	
	--Memory signals
    signal Mem_Address, MemWriteData, MemData : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --Register file signals
    signal ReadAddrs1, ReadAddrs2, WriteAddrs : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    signal RegWriteData, t_ReadData1, t_ReadData2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    
    --Auxiliar Registers
    signal ALUOut : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
    signal INSTR_REGISTER : STD_LOGIC_VECTOR (31 downto 0);
    signal MEM_DATA_REGISTER : STD_LOGIC_VECTOR (31 downto 0);
    
begin

	process(CLK) is
	begin
		if rising_edge(CLK) then
            
            case IorD is    --Multiplexer controlled by IorD signal from control unit
             
                when '1'    => Mem_Address <= ALUOut; 
                when others => Mem_Address <= pc;                            
            end case;
            
            MemRead <= '1'; 
            pc <= std_logic_vector(signed(pc) + x"00000001");  --PC + 1
                                                          
                                               
            
            
            if IRWrite = '1' then
            
            INSTR_REGISTER <= MemData;      --Write instruction into Instruction Register
            end if;
            
            MEM_DATA_REGISTER <= MemData;   --Always write data into Memory Data Register
            OpCode <= INSTR_REGISTER(31 downto 26);
            
            --Input signals and buses to Register File
            ReadAddrs1 <= INSTR_REGISTER(25 downto 21);
            ReadAddrs2 <= INSTR_REGISTER(20 downto 16);
            
            case RegDst is      --Multiplexer controlled by RegDst signal from control unit
                               
                when '1'    => WriteAddrs <= INSTR_REGISTER(15 downto 11);   
                when others => WriteAddrs <= INSTR_REGISTER(20 downto 16);                                        
            end case;
            
            case MemtoReg is    --Multiplexer controlled by MemtoReg signal from control unit
                
                when '1'    => RegWriteData <= MEM_DATA_REGISTER;
                when others => RegWriteData <= ALUOut;
            end case;   
            
            ReadData <= INSTR_REGISTER;     --Output of mips32 only for debug                                      
                    
            
            
                
                
         end if;
	end process;
	
	INSTR_DATA_MEMORY : memory port map (CLK, MemRead, MemWrite, Mem_Address, MemWriteData, MemData);
	REGISTER_FILE     : Register_v2 port map (CLK, RegWrite, ReadAddrs1, ReadAddrs2, WriteAddrs, 
	                                          RegWriteData, t_ReadData1, t_ReadData2);
end architecture;


