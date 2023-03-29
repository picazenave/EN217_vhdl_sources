----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 15:29:34
-- Design Name: 
-- Module Name: graphic_memory - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity text_memory is
Port ( 
        clk : in STD_LOGIC;
        ce : in STD_LOGIC;
        address : in std_logic_vector(5 downto 0);
        data_out     : out std_logic_vector(47 downto 0));
end text_memory;

architecture Behavioral of text_memory is
type memory_array is array (integer range 0 to 63) of std_logic_vector (47 downto 0);
signal memory_data: memory_array :=( -- glyph x/y
                                  
                                   others => x"000000000000");
begin

process(clk)
    begin
        if falling_edge(clk) then
            if ce = '1' then
                 data_out<=memory_data(to_integer(unsigned(address)));
            end if;
        end if;
    end process;

end Behavioral;
