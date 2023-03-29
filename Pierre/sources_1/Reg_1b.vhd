----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 08:20:16
-- Design Name: 
-- Module Name: Reg_1b - Behavioral
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

entity Reg_1b is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           load : in STD_LOGIC;
           init : in STD_LOGIC;
           input : in STD_LOGIC;
           output : out STD_LOGIC);
end Reg_1b;

architecture Behavioral of Reg_1b is

begin

process(clk, reset)
    begin
        if reset = '1' then
            output <= '0';
        elsif rising_edge(clk) then
            if ce = '1' then
               if init = '1' then
                   output <= '0';
               elsif load = '1' then
                    output <= input;
               end if;
            end if;
        end if;
    end process;

end Behavioral;
