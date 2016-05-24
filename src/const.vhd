library ieee;
use ieee.std_logic_1164.all;

package const is
    -- ALU CONTROL
    constant AND_CONTROL          : std_logic_vector (3 downto 0) := "0000";
    constant OR_CONTROL           : std_logic_vector (3 downto 0) := "0001";
    constant NOR_CONTROL          : std_logic_vector (3 downto 0) := "1100";
    constant SLT_CONTROL          : std_logic_vector (3 downto 0) := "0111";
    constant ADD_CONTROL          : std_logic_vector (3 downto 0) := "0010";
    constant SUB_CONTROL          : std_logic_vector (3 downto 0) := "0110";
    constant FP_ADD_CONTROL       : std_logic_vector (2 downto 0) := "000";
    constant FP_SUB_CONTROL       : std_logic_vector (2 downto 0) := "001";
    constant FP_MUL_CONTROL       : std_logic_vector (2 downto 0) := "010";
    constant FP_DIV_CONTROL       : std_logic_vector (2 downto 0) := "011";
    constant FP_SQR_CONTROL       : std_logic_vector (2 downto 0) := "100";
    constant FP_DIVADD_CONTROL    : std_logic_vector (2 downto 0) := "101";
    -- for shift operations, the value is not present in patterson
    -- found here (not official but sufficient for now)
    -- http://people.tamu.edu/~ehsanrohani/ECEN350/Lab08.pdf
    -- and here
    -- http://www.iuma.ulpgc.es/~nunez/clases-micros-para-com/clases-mpc-slides-links/Lafayette-Nestor-ece313-s04/mips%20multicycle%20Final%20Project.pdf
    constant SLL_CONTROL : std_logic_vector (3 downto 0) := "0011";
    constant SRL_CONTROL : std_logic_vector (3 downto 0) := "0100";

    -- ALU_OP
    constant LW_OR_SW_ADD    : std_logic_vector (1 downto 0) := "00";
    constant BEQ_OR_BNE_SUB  : std_logic_vector (1 downto 0) := "01";
    constant R_TYPE_INST     : std_logic_vector (1 downto 0) := "10";
    constant FP_TYPE_INST    : std_logic_vector (1 downto 0) := "11";

    -- FUNCT
    constant AND_FUNCT       : std_logic_vector (5 downto 0) := "100100";
    constant OR_FUNCT        : std_logic_vector (5 downto 0) := "100101";
    constant NOR_FUNCT       : std_logic_vector (5 downto 0) := "100111";
    constant SLT_FUNCT       : std_logic_vector (5 downto 0) := "101010";
    constant ADD_FUNCT       : std_logic_vector (5 downto 0) := "100000";
    constant SUB_FUNCT       : std_logic_vector (5 downto 0) := "100010";
    constant SLL_FUNCT       : std_logic_vector (5 downto 0) := "000000";
    constant SRL_FUNCT       : std_logic_vector (5 downto 0) := "000010";
    constant JR_FUNCT        : std_logic_vector (5 downto 0) := "001000";
    constant FP_ADD_FUNCT    : std_logic_vector (5 downto 0) := "000000";
    constant FP_SUB_FUNCT    : std_logic_vector (5 downto 0) := "000001";
    constant FP_MUL_FUNCT    : std_logic_vector (5 downto 0) := "000010";
    constant FP_DIV_FUNCT    : std_logic_vector (5 downto 0) := "000011";
    constant FP_SQR_FUNCT    : std_logic_vector (5 downto 0) := "000100";
    constant FP_DIVADD_FUNCT : std_logic_vector (5 downto 0) := "000101";
    
    -- REGISTER FILE
    constant REG_ZERO_ADDRS : std_logic_vector (4 downto 0) := "00000";
    constant REG_RA_ADDRES  : std_logic_vector (4 downto 0) := "11111";
    type reg is array(31 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
    constant REG_INIT_STATE : reg := (
        (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"),
        (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"),
        (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"),
        (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000"), (x"00000000")
    );
    
    -- GENERIC DATA LENGTHS
    constant MIPS32_DATA_LENGTH   : integer := 32;
    constant REG_FILE_ADDR_LENGTH : integer := 5;
    constant LED_DATA_LENGTH      : integer := 16;

    -- ROM TYPE MEMORY
    type rom_mem is array(0 to 15) of STD_LOGIC_VECTOR (31 downto 0);
    constant MEM_INIT_STATE : rom_mem := (
    ("10001100000010000000000000001110"), ("10001100000010010000000000001111"), ("01000110000010000100101010000101"),
    ("10000010000000000000000000000000"), ("00001000000000000000000000000000"), ("00000000000000000000000000000000"),
    ("00000000000000000000000000000000"), ("00000000000000000000000000000000"), ("00000000000000000000000000000000"),
    ("00000000000000000000000000000000"), ("00000000000000000000000000000000"), ("00000000000000000000000000000000"),
    ("00000000000000000000000000000000"), ("00000000000000000000000000000000"), ("01000000000000000000000000000000"),
    ("01000000010100000000000000000000"));


    -- OP CODES
    constant R_TYPE  : std_logic_vector (5 downto 0) := "000000";
    constant LW      : std_logic_vector (5 downto 0) := "100011";
    constant SW      : std_logic_vector (5 downto 0) := "101011";
    constant BEQ     : std_logic_vector (5 downto 0) := "000100";
    constant BNE     : std_logic_vector (5 downto 0) := "000101";
    constant J       : std_logic_vector (5 downto 0) := "000010";
    constant JAL     : std_logic_vector (5 downto 0) := "000011";
    constant ADDI    : std_logic_vector (5 downto 0) := "001000";
    constant OUT_LED : std_logic_vector (5 downto 0) := "100000";
    constant FP_TYPE : std_logic_vector (5 downto 0) := "010001";
    --constant COMPLEX : std_logic_vector (5 downto 0) := "010010";
    
    -- CONTROL LINES
    constant DEASSERTED              : std_logic := '0';
    constant ASSERTED                : std_logic := '1';
    constant ALU_OUT_MEM_TO_REG      : std_logic_vector (1 downto 0) := "00";
    constant MDR_MEM_TO_REG          : std_logic_vector (1 downto 0) := "01";
    constant PC_MEM_TO_REG           : std_logic_vector (1 downto 0) := "10";
    constant RT_REG_DST              : std_logic_vector (1 downto 0) := "00";
    constant RD_REG_DST              : std_logic_vector (1 downto 0) := "01";
    constant RA_REG_DST              : std_logic_vector (1 downto 0) := "10";
    constant B_ALU_SRC_B             : std_logic_vector (1 downto 0) := "00";
    constant FOUR_ALU_SRC_B          : std_logic_vector (1 downto 0) := "01";
    constant IMMED_ALU_SRC_B         : std_logic_vector (1 downto 0) := "10";
    constant BRANCH_ADDR_ALU_SRC_B   : std_logic_vector (1 downto 0) := "11";
    constant ALU_RESULT_PC_SOURCE    : std_logic_vector (1 downto 0) := "00";
    constant ALU_OUT_PC_SOURCE       : std_logic_vector (1 downto 0) := "01";
    constant JUMP_PC_SOURCE          : std_logic_vector (1 downto 0) := "10";
    constant CURRENT_PC_AS_PC_SOURCE : std_logic_vector (1 downto 0) := "11" ;
end const;

