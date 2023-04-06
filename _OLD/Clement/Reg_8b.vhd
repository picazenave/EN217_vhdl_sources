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

entity Reg_8b is
    Port ( reset    : in STD_LOGIC;
           clk      : in STD_LOGIC;
           ce       : in STD_LOGIC;
           load     : in STD_LOGIC;
           init     : in STD_LOGIC;
           input    : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           output   : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end Reg_8b;

architecture Behavioral of Reg_8b is
signal internal_register : STD_LOGIC_VECTOR(31 DOWNTO 0):="00000000000000000000000000000000";
begin

process(clk, reset)
    begin
        if reset = '1' then
            internal_register <= "00000000000000000000000000000000";
        elsif rising_edge(clk) then
        if init = '1' then
            internal_register <= "00000000000000000000000000000000";
        elsif ce = '1' then
                if load = '1' then
                    internal_register <= input;
                end if;
            end if;
        end if;
    end process;
output<=internal_register;
end Behavioral;
