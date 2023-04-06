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
    Port ( sel              : in STD_LOGIC_VECTOR(2 downto 0);
           operand_accu     : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           operand_memoire  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           carry            : out STD_LOGIC;
           output           : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end UAL;

architecture Behavioral of UAL is
signal resultat : STD_LOGIC_VECTOR(32 downto 0);
begin

process(sel,operand_accu,operand_memoire)
    begin
         case sel is
            when "000" =>    --NOR
                resultat(31 downto 0)<= operand_accu NOR operand_memoire;
                resultat(32)<='0';
            
            when "001" =>    --Add
                resultat<=std_logic_vector(resize(unsigned(operand_memoire),33)+resize(unsigned(operand_accu),33));
            
            when "010" =>    -- Mul
                resultat(31 downto 0) <= std_logic_vector(resize(unsigned(operand_accu) * unsigned(operand_memoire), 32));
                resultat(32) <= '0';
                
            when "011" =>    -- Mod            
                resultat(31 downto 0) <= std_logic_vector(unsigned(operand_memoire) mod unsigned(operand_accu));
                resultat(32) <= '0';
            
            when "100" =>    --IFNeq 
                if (unsigned(operand_accu) /= unsigned(operand_memoire)) then
                    resultat(32) <= '1';
                else
                    resultat(32) <= '0';
                end if;
            when "101" =>    --IFSup (si Accu > memoire)
                if (unsigned(operand_accu) > unsigned(operand_memoire)) then
                    resultat(32) <= '1';
                else
                    resultat(32) <= '0';
                end if;
            when others =>
                resultat <= "000000000000000000000000000000000";
        end case;
    end process;

carry<=resultat(32);
output<=resultat(31 downto 0);

end Behavioral;

