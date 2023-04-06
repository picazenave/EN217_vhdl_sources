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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAL is
    Port ( sel : in STD_LOGIC;
           operand_0 : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           operand_1 : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           carry : out STD_LOGIC;
           output : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end UAL;

architecture Behavioral of UAL is
signal somme : STD_LOGIC_VECTOR(8 downto 0);
begin

process(sel,operand_0,operand_1)
    begin
       if sel='0' then
        somme(7 downto 0)<= operand_1 NOR operand_0;
        somme(8)<='0';        
       else
        somme<=std_logic_vector(resize(unsigned(operand_0),9)+resize(unsigned(operand_1),9));
       end if;
    end process;

carry<=somme(8);
output<=somme(7 downto 0);

end Behavioral;

