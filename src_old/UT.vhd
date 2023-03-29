
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
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           
           load_fetch : in STD_LOGIC;
           load_carry : in STD_LOGIC;
           load_accu : in STD_LOGIC;
           
           init_carry : in STD_LOGIC;
           
           sel_UAL : in STD_LOGIC;
           
           input_UT : in STD_LOGIC_VECTOR(7 downto 0);
           output_UT : out STD_LOGIC_VECTOR(7 downto 0);
           output_carry : out STD_LOGIC);
end UT;

architecture Behavioral of UT is
component Reg_8b
        port (reset  : in std_logic;
              clk    : in std_logic;
              ce     : in std_logic;
              load   : in std_logic;
              init   : in std_logic;
              input  : in std_logic_vector (7 downto 0);
              output : out std_logic_vector (7 downto 0));
end component;

component UAL
    port (sel       : in std_logic;
          operand_0 : in std_logic_vector (7 downto 0);
          operand_1 : in std_logic_vector (7 downto 0);
          carry     : out std_logic;
          output    : out std_logic_vector (7 downto 0));
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

--signal load_carry   : std_logic;
--signal init_carry   : std_logic;
signal input_carry  : std_logic;
--signal output_carry : std_logic;
--- 
--signal load_fetch  : std_logic;
signal init_fetch  : std_logic;
signal input_fetch  : std_logic_vector(7 downto 0);
signal output_fetch : std_logic_vector(7 downto 0);
--- 
--signal load_accu  : std_logic;
signal init_accu  : std_logic :='0';
signal input_accu  : std_logic_vector(7 downto 0);
signal output_accu : std_logic_vector(7 downto 0); 
---
--signal sel_ual    : std_logic;
signal operand_0_ual : std_logic_vector (7 downto 0);
signal operand_1_ual : std_logic_vector (7 downto 0);
signal carry_ual   : std_logic;
signal output_ual    : std_logic_vector (7 downto 0);   
begin

carry : Reg_1b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_carry,
              init   => init_carry,
              input  => input_carry,
              output => output_carry);
reg_fetch : Reg_8b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_fetch,
              init   => init_fetch,
              input  => input_fetch,
              output => output_fetch);
reg_accu : Reg_8b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_accu,
              init   => init_accu,
              input  => input_accu,
              output => output_accu);
ual_ut : UAL
port map (sel       => sel_ual,
          operand_0 => operand_0_ual,
          operand_1 => operand_1_ual,
          carry    => carry_ual,
          output   => output_ual); 

input_carry<=carry_ual;
input_accu<=output_ual;
input_fetch<=input_UT;

output_UT<=output_accu;

operand_0_ual<=output_fetch;
operand_1_ual<=output_accu;


process(clk, reset)
    begin
        if reset = '1' then
            --output_UT <= x"00";
        elsif rising_edge(clk) then
            if ce = '1' then
                
                
            end if;
        end if;
    end process;

end Behavioral;