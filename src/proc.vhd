library ieee;
use ieee.std_logic_1164.all;

entity proc is
port(
        clk100M            : in std_logic;
        reset              : in std_logic;
        LED                : out std_logic_vector(7 downto 0)
        );

end proc;

architecture Behavioral of proc is

    component COEUR_CPU
        port (CLK : in std_logic;
              RST : in std_logic;
              CE  : in std_logic;
              output_cpu        : out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    component acces_carte 
    port (clk 		    : in std_logic;
	 	  reset  		: in std_logic;
	 	  ce1s  		: out std_logic;
	      ce25M  		: out std_logic);
end component;


signal reset_sig    : std_logic;
signal ce1s         : std_logic;
signal ce25M        : std_logic;
signal output_cpu   : std_logic_vector(31 downto 0);
begin
    reset_sig <= not(reset);
    
    
    processeur32b    : COEUR_CPU   port map (   CLK => clk100M,
                                                RST => reset_sig,
                                                CE  => ce25M,
                                                output_cpu =>  output_cpu);


    Peripheriques 	 : acces_carte  port map (  clk100M,
										        reset_sig, 
										        ce1s,  
										        ce25M);
										        										        
LED <= output_cpu(7 downto 0);
end Behavioral;