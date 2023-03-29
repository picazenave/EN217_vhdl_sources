
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UT is
    Port ( reset            : in STD_LOGIC;
           clk              : in STD_LOGIC;
           ce               : in STD_LOGIC;
           load_fetch       : in STD_LOGIC;
           load_carry       : in STD_LOGIC;
           load_accu        : in STD_LOGIC;
           init_carry       : in STD_LOGIC;
           init_accu        : in STD_LOGIC;
           sel_UAL          : in STD_LOGIC_VECTOR(2 downto 0);
           input_UT         : in STD_LOGIC_VECTOR(31 downto 0);
           output_UT        : out STD_LOGIC_VECTOR(31 downto 0);
           output_carry     : out STD_LOGIC);
end UT;

architecture Behavioral of UT is


component UAL
        port (sel             : in std_logic_vector (2 downto 0);
              operand_accu    : in std_logic_vector (31 downto 0);
              operand_memoire : in std_logic_vector (31 downto 0);
              carry           : out std_logic;
              output          : out std_logic_vector (31 downto 0));
    end component;


component Reg_1b
    port (reset  : in std_logic;
          clk    : in std_logic;
          ce     : in std_logic;
          load   : in std_logic;
          init   : in std_logic;
          input  : in std_logic;
          output : out std_logic);
end component;

component Reg_8b
        port (reset  : in std_logic;
              clk    : in std_logic;
              ce     : in std_logic;
              load   : in std_logic;
              init   : in std_logic;
              input  : in std_logic_vector (31 downto 0);
              output : out std_logic_vector (31 downto 0));
end component;


---------Internal Signal----------
signal the_carry : std_logic;
signal operand_from_memory : std_logic_vector(31 downto 0);
signal resultat : std_logic_vector(31 downto 0);
signal operand_from_accu : std_logic_vector(31 downto 0);

 
begin

carry : Reg_1b -- validé
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_carry,
              init   => init_carry,
              input  => the_carry,
              output => output_carry);
              
reg_fetch : Reg_8b -- validé
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_fetch,
              init   => '0',  
              input  => input_UT,
              output => operand_from_memory);

reg_accu : Reg_8b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_accu,
              init   => init_accu,
              input  => resultat,
              output => operand_from_accu);
output_UT <= operand_from_accu;
ual_ut : UAL
port map (sel               => sel_UAL,
          operand_accu      => operand_from_accu,
          operand_memoire   => operand_from_memory,
          carry             => the_carry,
          output            => resultat); 


end Behavioral;