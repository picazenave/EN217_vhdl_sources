----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 11:25:21
-- Design Name: 
-- Module Name: toplevel_CPU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toplevel_CPU is
 Port ( clk                  : in STD_LOGIC;
       reset                : in STD_LOGIC;
       ce                   : in STD_LOGIC);
end toplevel_CPU;

architecture Behavioral of toplevel_CPU is
component UC
    port (clk           : in std_logic;
          reset         : in std_logic;
          ce            : in std_logic;
          carry         : in std_logic;
          instruction   : in std_logic_vector (7 downto 0);
          load_reg_data : out std_logic;
          sel_ual       : out std_logic;
          load_accu     : out std_logic;
          load_carry    : out std_logic;
          init_carry    : out std_logic;
          r_w           : out std_logic;
          enable_memory : out std_logic;
          adress        : out std_logic_vector (5 downto 0));
end component;
signal instruction_input_UC   : std_logic_vector (7 downto 0);
signal load_reg_data_UC : std_logic;
signal sel_ual_UC       : std_logic;
signal load_accu_UC     : std_logic;
signal load_carry_UC    : std_logic;
signal init_carry_UC    : std_logic;
signal r_w_UC           : std_logic;
signal enable_memory_UC : std_logic;
signal adress_UC        : std_logic_vector (5 downto 0);                       
---------------------------------
component UT
    port (reset        : in std_logic;
          clk          : in std_logic;
          ce           : in std_logic;
          load_fetch   : in std_logic;
          load_carry   : in std_logic;
          load_accu    : in std_logic;
          init_carry   : in std_logic;
          sel_UAL      : in std_logic;
          input_UT     : in std_logic_vector (7 downto 0);
          output_UT    : out std_logic_vector (7 downto 0);
          output_carry : out std_logic);
end component;
signal input_UT     : std_logic_vector (7 downto 0);
signal internal_output_UT    : std_logic_vector (7 downto 0);
signal output_carry_UT : std_logic;
---------------------------------------
component Memory
    port (clk     : in std_logic;
          ce      : in std_logic;
          rw      : in std_logic;
          enable  : in std_logic;
          address : in std_logic_vector (5 downto 0);
          input   : in std_logic_vector (7 downto 0);
          output  : out std_logic_vector (7 downto 0));
end component;

signal output_MEMORY  : std_logic_vector (7 downto 0);
begin


uc_inst : UC
    port map (clk           => clk,
              reset         => reset,
              ce            => ce,
              carry         => output_carry_UT,
              instruction   => output_MEMORY,
              load_reg_data => load_reg_data_UC,--fetch coté UT
              sel_ual       => sel_ual_UC,
              load_accu     => load_accu_UC,
              load_carry    => load_carry_UC,
              init_carry    => init_carry_UC,
              r_w           => r_w_UC,
              enable_memory => enable_memory_UC,
              adress        => adress_UC);

ut_inst : UT
    port map (reset        => reset,
              clk          => clk,
              ce           => ce,
              load_fetch   => load_reg_data_UC,
              load_carry   => load_carry_UC,
              load_accu    => load_accu_UC,
              init_carry   => init_carry_UC,
              sel_UAL      => sel_ual_UC,
              input_UT     => output_MEMORY,
              output_UT    => internal_output_UT,
              output_carry => output_carry_UT);

mem_inst : Memory
    port map (clk     => clk,
              ce      => ce,
              rw      => r_w_UC,
              enable  => enable_memory_UC,
              address => adress_UC,
              input   => internal_output_UT,
              output  => output_MEMORY);

end Behavioral;
