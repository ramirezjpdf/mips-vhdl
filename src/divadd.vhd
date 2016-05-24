
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.fpupack.all;

entity divadd is
    Port ( clk_i        : in STD_LOGIC;
           opa_i        : in STD_LOGIC_VECTOR (31 downto 0);
           opb_i        : in STD_LOGIC_VECTOR (31 downto 0);
           start_i      : in STD_LOGIC;
           rmode_i 	    : in std_logic_vector(1 downto 0);
           output_o     : out STD_LOGIC_VECTOR (31 downto 0);
           div_ine_o    : out STD_LOGIC;
           add_ine_o    : out STD_LOGIC);
end divadd;

architecture rtl of divadd is

    -- Div Unit
	component pre_norm_div is
	port(
			 clk_i		  	: in std_logic;
			 opa_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 opb_i			: in std_logic_vector(FP_WIDTH-1 downto 0);
			 exp_10_o		: out std_logic_vector(EXP_WIDTH+1 downto 0);
			 dvdnd_50_o		: out std_logic_vector(2*(FRAC_WIDTH+2)-1 downto 0); 
			 dvsor_27_o		: out std_logic_vector(FRAC_WIDTH+3 downto 0)
		);
	end component;
	
	component serial_div is
	port(
			 clk_i 			  	: in std_logic;
			 dvdnd_i			: in std_logic_vector(2*(FRAC_WIDTH+2)-1 downto 0); -- hidden(1) & fraction(23)
			 dvsor_i			: in std_logic_vector(FRAC_WIDTH+3 downto 0);
			 sign_dvd_i 		: in std_logic;
			 sign_div_i 		: in std_logic;
			 start_i			: in std_logic;
			 ready_o			: out std_logic;
			 qutnt_o			: out std_logic_vector(FRAC_WIDTH+3 downto 0);
			 rmndr_o			: out std_logic_vector(FRAC_WIDTH+3 downto 0);
			 sign_o 			: out std_logic;
			 div_zero_o			: out std_logic
			 );
	end component;	
	
	component post_norm_div is
	port(
			 clk_i		  		: in std_logic;
			 opa_i				: in std_logic_vector(FP_WIDTH-1 downto 0);
			 opb_i				: in std_logic_vector(FP_WIDTH-1 downto 0);
			 qutnt_i			: in std_logic_vector(FRAC_WIDTH+3 downto 0);
			 rmndr_i			: in std_logic_vector(FRAC_WIDTH+3 downto 0);
			 exp_10_i			: in std_logic_vector(EXP_WIDTH+1 downto 0);
			 sign_i				: in std_logic;
			 rmode_i			: in std_logic_vector(1 downto 0);
			 output_o			: out std_logic_vector(FP_WIDTH-1 downto 0);
			 ine_o				: out std_logic
		);
	end component;	
	
    -- Add/Sub Unit
    component pre_norm_addsub is
	port(clk_i 			: in std_logic;
			 opa_i			: in std_logic_vector(31 downto 0);
			 opb_i			: in std_logic_vector(31 downto 0);
			 fracta_28_o		: out std_logic_vector(27 downto 0);	-- carry(1) & hidden(1) & fraction(23) & guard(1) & round(1) & sticky(1)
			 fractb_28_o		: out std_logic_vector(27 downto 0);
			 exp_o			: out std_logic_vector(7 downto 0));
	end component;
	
	component addsub_28 is
	port(clk_i 			  : in std_logic;
			 fpu_op_i		   : in std_logic;
			 fracta_i			: in std_logic_vector(27 downto 0); -- carry(1) & hidden(1) & fraction(23) & guard(1) & round(1) & sticky(1)
			 fractb_i			: in std_logic_vector(27 downto 0);
			 signa_i 			: in std_logic;
			 signb_i 			: in std_logic;
			 fract_o			: out std_logic_vector(27 downto 0);
			 sign_o 			: out std_logic);
	end component;
	
	component post_norm_addsub is
	port(clk_i 				: in std_logic;
			 opa_i 				: in std_logic_vector(31 downto 0);
			 opb_i 				: in std_logic_vector(31 downto 0);
			 fract_28_i		: in std_logic_vector(27 downto 0);	-- carry(1) & hidden(1) & fraction(23) & guard(1) & round(1) & sticky(1)
			 exp_i			  : in std_logic_vector(7 downto 0);
			 sign_i			  : in std_logic;
			 fpu_op_i			: in std_logic;
			 rmode_i			: in std_logic_vector(1 downto 0);
			 output_o			: out std_logic_vector(31 downto 0);
			 ine_o				: out std_logic
		);
	end component;
	

--	***Add/Substract units signals***

	signal prenorm_addsub_fracta_28_o, prenorm_addsub_fractb_28_o : std_logic_vector(27 downto 0);
	signal prenorm_addsub_exp_o : std_logic_vector(7 downto 0); 
	
	signal addsub_fract_o : std_logic_vector(27 downto 0); 
	signal addsub_sign_o : std_logic;
	
	signal postnorm_addsub_output_o : std_logic_vector(31 downto 0); 
	signal postnorm_addsub_ine_o : std_logic;
	
	--	***Division units signals***
	
	signal pre_norm_div_dvdnd : std_logic_vector(49 downto 0);
	signal pre_norm_div_dvsor : std_logic_vector(26 downto 0);
	signal pre_norm_div_exp	: std_logic_vector(EXP_WIDTH+1 downto 0);
	
	signal serial_div_qutnt : std_logic_vector(26 downto 0);
	signal serial_div_rmndr : std_logic_vector(26 downto 0);
	signal serial_div_sign : std_logic;
	signal serial_div_div_zero : std_logic;
	
	signal post_norm_div_output : std_logic_vector(31 downto 0);
	signal post_norm_div_ine : std_logic;

begin

	--***Division units***
	
	i_pre_norm_div2 : pre_norm_div
	port map(
			 clk_i => clk_i,
			 opa_i => opa_i,
			 opb_i => opb_i,
			 exp_10_o => pre_norm_div_exp,
			 dvdnd_50_o	=> pre_norm_div_dvdnd,
			 dvsor_27_o	=> pre_norm_div_dvsor);
			 
	i_serial_div2 : serial_div
	port map(
			 clk_i=> clk_i,
			 dvdnd_i => pre_norm_div_dvdnd,
			 dvsor_i => pre_norm_div_dvsor,
			 sign_dvd_i => opa_i(31),
			 sign_div_i => opb_i(31),
			 start_i => start_i,
			 ready_o => open,
			 qutnt_o => serial_div_qutnt,
			 rmndr_o => serial_div_rmndr,
			 sign_o => serial_div_sign,
			 div_zero_o	=> serial_div_div_zero);
	
	i_post_norm_div2 : post_norm_div
	port map(
			 clk_i => clk_i,
			 opa_i => opa_i,
			 opb_i => opb_i,
			 qutnt_i =>	serial_div_qutnt,
			 rmndr_i => serial_div_rmndr,
			 exp_10_i => pre_norm_div_exp,
			 sign_i	=> serial_div_sign,
			 rmode_i =>	rmode_i,
			 output_o => post_norm_div_output,
			 ine_o => div_ine_o);

	--***Add/Substract units***
	
	i_prenorm_addsub2: pre_norm_addsub
    port map (
         clk_i => clk_i,
		 opa_i => post_norm_div_output,
		 opb_i => opb_i,
		 fracta_28_o => prenorm_addsub_fracta_28_o,
		 fractb_28_o => prenorm_addsub_fractb_28_o,
		 exp_o=> prenorm_addsub_exp_o);
				
	i_addsub2: addsub_28
	port map(
		 clk_i    => clk_i, 			
		 fpu_op_i => '0',		 
		 fracta_i => prenorm_addsub_fracta_28_o,	
		 fractb_i => prenorm_addsub_fractb_28_o,		
		 signa_i  => post_norm_div_output(31),			
		 signb_i  => opb_i(31),				
		 fract_o  => addsub_fract_o,			
		 sign_o   => addsub_sign_o);	
			 
	i_postnorm_addsub2: post_norm_addsub
	port map(
	     clk_i => clk_i,		
		 opa_i => opa_i,
		 opb_i => post_norm_div_output,	
		 fract_28_i => addsub_fract_o,
		 exp_i => prenorm_addsub_exp_o,
		 sign_i => addsub_sign_o,
		 fpu_op_i => '0', 
		 rmode_i => rmode_i,
		 output_o => output_o,
		 ine_o => add_ine_o
		);


end rtl;
