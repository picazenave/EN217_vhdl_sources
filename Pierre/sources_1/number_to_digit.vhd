----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 09:08:04
-- Design Name: 
-- Module Name: number_to_digit - Behavioral
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY number_to_digit IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        number_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        digit_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END number_to_digit;

ARCHITECTURE Behavioral OF number_to_digit IS

    SIGNAL number_integer : INTEGER := 0;
BEGIN
    number_integer <= to_integer(unsigned(number_in));

    PROCESS (clk, reset) IS
    BEGIN
        IF (reset = '1') THEN
            digit_out<=(OTHERS => '0');
        ELSIF (clk'event AND clk = '1') THEN
            IF (ce = '1') THEN
                digit_out(3 DOWNTO 0) <= STD_LOGIC_VECTOR(to_unsigned(number_integer MOD 10,4));
                digit_out(7 DOWNTO 4) <= STD_LOGIC_VECTOR(to_unsigned(number_integer/10 MOD 10,4));
                digit_out(11 DOWNTO 8) <= STD_LOGIC_VECTOR(to_unsigned(number_integer/100 MOD 10,4));
                digit_out(15 DOWNTO 12) <= STD_LOGIC_VECTOR(to_unsigned(number_integer/1000 MOD 10,4));
            END IF;
        END IF;
    END PROCESS;

END Behavioral;