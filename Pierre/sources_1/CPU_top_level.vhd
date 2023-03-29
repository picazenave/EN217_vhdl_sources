----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:00 02/15/2011 
-- Design Name: 
-- Module Name:    CPU_8bits - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_8bits is
    Port ( reset 		 : in  STD_LOGIC;
           clk100M 	     : in  STD_LOGIC;
	 	   AN            : out STD_LOGIC_VECTOR(7 downto 0);
           Sevenseg 	 : out STD_LOGIC_VECTOR (7 downto 0);
           LED 		     : out STD_LOGIC_VECTOR (7 downto 0);
           VGA_HS       : out std_logic;   -- horisontal vga syncr.
           VGA_VS       : out std_logic;   -- vertical vga syncr.
           VGA_R      : out std_logic_vector(3 downto 0);   -- red output
           VGA_G    : out std_logic_vector(3 downto 0);   -- green output
           VGA_B     : out std_logic_vector(3 downto 0)   -- blue output
			 );
end CPU_8bits;

architecture Behavioral of CPU_8bits is

component VGA_bitmap_640x480
    generic(bit_per_pixel : integer range 1 to 12:=1;    -- number of bits per pixel
          grayscale     : boolean := false);           -- should data be displayed in grayscale
    port(clk          : in  std_logic;
       reset        : in  std_logic;
       VGA_hs       : out std_logic;   -- horisontal vga syncr.
       VGA_vs       : out std_logic;   -- vertical vga syncr.
       VGA_red      : out std_logic_vector(3 downto 0);   -- red output
       VGA_green    : out std_logic_vector(3 downto 0);   -- green output
       VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output

       ADDR         : in  std_logic_vector(18 downto 0);
       data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0);
       data_write   : in  std_logic;
       data_out     : out std_logic_vector(bit_per_pixel - 1 downto 0));
end component;

component Memory
    port (clk     : in std_logic;
          ce      : in std_logic;
          rw      : in std_logic;
          enable  : in std_logic;
          address : in std_logic_vector (5 downto 0);
          input   : in std_logic_vector (7 downto 0);
          output  : out std_logic_vector (7 downto 0));
end component;

component CPU
    Port ( Clk 					 : in  STD_LOGIC;
	       Ce					 : in  STD_LOGIC;
           Reset 				 : in  STD_LOGIC;  
           mem_adr               : out std_logic_vector (5 downto 0);
           data_mem_in           : out std_logic_vector (7 downto 0); --data to memory
           data_mem_out          : in std_logic_vector (7 downto 0);--data from memory
           mem_rw                : out std_logic;
           mem_enable            : out std_logic);
end component;

component acces_carte 
    port (clk 		    : in std_logic;
	 	  reset  		: in std_logic;
          AdrLSB 		: in std_logic_vector(3 downto 0);
          AdrMSB 		: in std_logic_vector(1 downto 0);
          DataLSB		: in std_logic_vector(3 downto 0);
          DataMSB		: in std_logic_vector(3 downto 0);
          DataInMem		: in std_logic_vector(7 downto 0);
	 	  ce1s  		: out std_logic;
	      ce25M  		: out std_logic;
	 	  AN            : out std_logic_vector(7 downto 0);
	 	  Sseg 			: out std_logic_vector(7 downto 0);
	 	  LED  			: out std_logic_vector(7 downto 0);
		  LEDg 			: out std_logic);
end component;

signal Data_Mem_Unit    : STD_LOGIC_VECTOR (7 downto 0);
signal Data_Unit_Mem    : STD_LOGIC_VECTOR (7 downto 0);
signal Adr           	: STD_LOGIC_VECTOR (5 downto 0);
signal sig_clk			: STD_LOGIC;
signal ce1s 			: STD_LOGIC;
signal ce25M			: STD_LOGIC;
signal LEDg 			: STD_LOGIC;
signal sig_locked   	: STD_LOGIC;
signal sig_reset        : STD_LOGIC;

signal data_cpu_to_mem  : STD_LOGIC_VECTOR (7 downto 0);
signal data_mem_to_cpu  : STD_LOGIC_VECTOR (7 downto 0);
signal address_cpu_to_mem  : STD_LOGIC_VECTOR (5 downto 0);
signal enable_cpu_to_mem  : STD_LOGIC;
signal rw_cpu_to_mem  : STD_LOGIC;

signal dummy_address  : std_logic_vector(18 downto 0);

constant zero         : STD_LOGIC := '0';

begin

sig_reset <= not (reset);
sig_clk   <= clk100M;

-- Attention pour la simulation mettre  ce de UT et UC à ce25M sinon ce1s

VGA_out : VGA_bitmap_640x480
    generic map( bit_per_pixel => 3,
                    grayscale => false)
    port map (clk        => sig_clk,
              reset      => sig_reset,
              VGA_hs     => VGA_HS,
              VGA_vs     => VGA_VS,
              VGA_red    => VGA_R,
              VGA_green  => VGA_G,
              VGA_blue   => VGA_B,
              ADDR       => dummy_address,
              data_in    => "111",
              data_write => '1',
              data_out   => open);


dummy_address<="0000000000001" & address_cpu_to_mem;
										  
 proc : CPU
    port map (Clk          => sig_clk,
              Reset        => sig_reset,
              Ce           => ce25M,
              mem_adr      => address_cpu_to_mem,
              data_mem_in  => data_cpu_to_mem,
              data_mem_out => data_mem_to_cpu,
              mem_rw       => rw_cpu_to_mem,
              mem_enable   => enable_cpu_to_mem);


Peripheriques 	 : acces_carte  port map (sig_clk,
										  sig_reset, 
										  Adr(3 downto 0), 
										  Adr(5 downto 4),
										  Data_Unit_Mem(3 downto 0), 
										  Data_Unit_Mem(7 downto 4),
										  Data_Mem_Unit,
										  ce1s,  
										  ce25M, 
										  AN,
										  Sevenseg, 
										  LED, 
										  LEDg);		
										  
mem_inst : Memory
    port map (clk     => sig_clk,
              ce      => ce25M,
              rw      => rw_cpu_to_mem,
              enable  => enable_cpu_to_mem,
              address => address_cpu_to_mem,
              input   => data_cpu_to_mem,
              output  => data_mem_to_cpu);
end Behavioral;

