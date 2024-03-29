----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 11:07:02
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
    Port ( clk                  : in STD_LOGIC;
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
end UC;

architecture Behavioral of UC is
    component FSM
        port (clk              : in std_logic;
              reset            : in std_logic;
              ce               : in std_logic;
              code_op          : in std_logic_vector (3 downto 0);
              carry            : in std_logic;
              sel_mux          : out std_logic_vector(1 downto 0);
              load_instruction : out std_logic;
              r_w              : out std_logic;
              enable_memory    : out std_logic;
              init_carry       : out std_logic;
              load_carry       : out std_logic;
              load_reg_data    : out std_logic;
              load_accu        : out std_logic;
              sel_ual          : out std_logic_vector (2 downto 0);
              load_pc          : out std_logic;
              incr_pc          : out std_logic;
              init_pc          : out std_logic;
              init_accu        : out std_logic;
              load_data        : out std_logic);
    end component;
    
    component PC
        port (clk     : in std_logic;
              reset   : in std_logic;
              ce      : in std_logic;
              init_pc : in std_logic;
              incr_pc : in std_logic;
              load_pc : in std_logic;
              input   : in std_logic_vector (27 downto 0);
              output  : out std_logic_vector (27 downto 0));
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

    component Mux
        port (input_0      : in std_logic_vector (27 downto 0);
              input_1      : in std_logic_vector (27 downto 0);
              input_2      : in std_logic_vector (27 downto 0);
              input_select : in std_logic_vector (1 downto 0);
              output       : out std_logic_vector (27 downto 0));
    end component;
   

signal sel_mux : std_logic_vector(1 downto 0);
signal load_instruction : std_logic;
signal load_data : std_logic;
signal load_pc : std_logic;
signal incr_pc : std_logic;
signal init_pc : std_logic;
--signal code_op : std_logic_vector(1 downto 0);
--signal input_pc : std_logic_vector(5 downto 0);
signal output_pc : std_logic_vector(27 downto 0);
signal output_registre_instruction : std_logic_vector(31 downto 0);
signal output_registre_data : std_logic_vector(31 downto 0);

begin

    FSM_UC : FSM
    port map (clk              => clk,
              reset            => reset,
              ce               => ce,
              code_op          => output_registre_instruction(31 downto 28),
              carry            => carry,
              sel_mux          => sel_mux,
              load_instruction => load_instruction,
              r_w              => r_w,
              enable_memory    => enable_memory,
              init_carry       => init_carry,
              load_carry       => load_carry,
              load_reg_data    => load_reg_data,
              load_accu        => load_accu,
              sel_ual          => sel_ual,
              load_pc          => load_pc,
              incr_pc          => incr_pc,
              init_pc          => init_pc,
              init_accu        => init_accu,
              load_data        => load_data);

    PC_UC : PC
    port map (clk     => clk,
              reset   => reset,
              ce      => ce,
              init_pc => init_pc,
              incr_pc => incr_pc,
              load_pc => load_pc,
              input   => output_registre_instruction(27 downto 0),
              output  => output_pc);
              
    Mux_UC : Mux
    port map (input_0      => output_pc,
              input_1      => output_registre_instruction(27 downto 0),
              input_2      => output_registre_data(27 downto 0),
              input_select => sel_mux,
              output       => adress);
              
Registre_instruction : Reg_8b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_instruction,
              init   => '0',
              input  => instruction,
              output => output_registre_instruction);
              
Registre_data : Reg_8b
    port map (reset  => reset,
              clk    => clk,
              ce     => ce,
              load   => load_data,
              init   => '0',
              input  => instruction, -- ici ce sera des datas
              output => output_registre_data);

end Behavioral;
