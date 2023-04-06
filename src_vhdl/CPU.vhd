----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 17:14:54
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port (CLK               : in STD_LOGIC;
          RST               : in STD_LOGIC;
          CE                : in STD_LOGIC;
          DATA_FROM_MEMORY  : in STD_LOGIC_VECTOR(31 downto 0);
          DATA_TO_MEMORY    : out STD_LOGIC_VECTOR(31 downto 0);
          ADR_MEM           : out STD_LOGIC_VECTOR(27 downto 0);
          RW_MEMORY         : out STD_LOGIC;
          ENABLE_MEMORY     : out STD_LOGIC);
end CPU;

architecture Behavioral of CPU is
component UC
      port (clk                  : in STD_LOGIC;
            reset                : in STD_LOGIC;
            ce                   : in STD_LOGIC;
            carry                : in STD_LOGIC;
            instruction          : in STD_LOGIC_VECTOR(31 downto 0);
            load_reg_data        : out STD_LOGIC;
            sel_ual              : out STD_LOGIC_VECTOR (2 downto 0);
            load_accu            : out STD_LOGIC;
            load_carry           : out STD_LOGIC;
            init_carry           : out STD_LOGIC;
            r_w                  : out STD_LOGIC;
            enable_memory        : out STD_LOGIC;
            adress               : out STD_LOGIC_VECTOR(27 downto 0);
            init_accu            : out STD_LOGIC);
end component;

component UT
    port (reset            : in STD_LOGIC;
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
end component;

signal carry_cpu                : std_logic;
signal load_reg_data            : std_logic;
signal sel_ual                  : std_logic_vector(2 downto 0);
signal load_accu                : std_logic;
signal load_carry               : std_logic;
signal init_carry               : std_logic;
signal init_accu                : std_logic;

begin

UC_CPU : UC
port map (    clk           => CLK,
              reset         => RST,
              ce            => CE,
              carry         => carry_cpu,
              instruction   => DATA_FROM_MEMORY,
              load_reg_data => load_reg_data,
              sel_ual       => sel_ual,
              load_accu     => load_accu,
              load_carry    => load_carry,
              init_carry    => init_carry,
              r_w           => RW_MEMORY,
              enable_memory => ENABLE_MEMORY,
              adress        => ADR_MEM,
              init_accu     => init_accu);


UT_CPU : UT
port map     (reset        => RST,
              clk          => CLK,
              ce           => CE,
              load_fetch   => load_reg_data,
              load_carry   => load_carry,
              load_accu    => load_accu,
              init_carry   => init_carry,
              init_accu    => init_accu,
              sel_UAL      => sel_UAL,
              input_UT     => DATA_FROM_MEMORY,
              output_UT    => DATA_TO_MEMORY,
              output_carry => carry_cpu);

end Behavioral;
