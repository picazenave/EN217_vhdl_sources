----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.03.2023 14:28:44
-- Design Name: 
-- Module Name: COEUR_CPU - Behavioral
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

entity COEUR_CPU is
    Port (CLK               : in STD_LOGIC;
          RST               : in STD_LOGIC;
          CE                : in STD_LOGIC;
          output_cpu        : out STD_LOGIC_VECTOR(31 downto 0));
          
end COEUR_CPU;

architecture Behavioral of COEUR_CPU is
component Memory
    port(  clk                  : in STD_LOGIC;
           ce                   : in STD_LOGIC;
           rw                   : in STD_LOGIC;--R/=0 W=0
           enable               : in STD_LOGIC;
           address_read_only    : in STD_LOGIC_VECTOR(27 downto 0);
           address              : in STD_LOGIC_VECTOR(27 downto 0);
           input                : in STD_LOGIC_VECTOR(31 downto 0);
           output_read_only     : out STD_LOGIC_VECTOR(31 downto 0);
           output               : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component CPU
        port (CLK              : in std_logic;
              RST              : in std_logic;
              CE               : in std_logic;
              DATA_FROM_MEMORY : in std_logic_vector (31 downto 0);
              DATA_TO_MEMORY   : out std_logic_vector (31 downto 0);
              ADR_MEM          : out std_logic_vector (27 downto 0);
              RW_MEMORY        : out std_logic;
              ENABLE_MEMORY    : out std_logic);
    end component;
    
signal data_from_memory : std_logic_vector (31 downto 0);
signal data_to_memory   : std_logic_vector (31 downto 0);
signal adr_mem          : std_logic_vector (27 downto 0);
signal rw_memory        : std_logic;
signal enable_memory    : std_logic;

signal address_read_only : std_logic_vector (27 downto 0);
signal output_read_only  : std_logic_vector (31 downto 0);

begin

coeur_cpu : CPU
    port map (CLK              => CLK,
              RST              => RST,
              CE               => CE,
              DATA_FROM_MEMORY => data_from_memory,
              DATA_TO_MEMORY   => data_to_memory,
              ADR_MEM          => adr_mem,
              RW_MEMORY        => rw_memory,
              ENABLE_MEMORY    => enable_memory);

Memory_CPU : Memory
port map (    clk     => CLK,
              ce      => CE,
              rw      => rw_memory,
              enable  => enable_memory,
              address_read_only => address_read_only,
              address => adr_mem,
              input   => data_to_memory,
              output_read_only => output_read_only,
              output  => data_from_memory);

end Behavioral;
