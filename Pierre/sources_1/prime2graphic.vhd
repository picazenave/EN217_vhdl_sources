----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2023 08:53:21
-- Design Name: 
-- Module Name: prime2graphic - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY prime2graphic IS
    PORT (
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        counter : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
        ready : OUT STD_LOGIC);
END prime2graphic;

ARCHITECTURE Behavioral OF prime2graphic IS
    SIGNAL number_integer : INTEGER := 0;
    SIGNAL counter_integer : INTEGER := 0;
BEGIN
    number_integer <= to_integer(unsigned(data_in));
    counter_integer <= to_integer(unsigned(counter));
    --decomposer nombre pour chiffre � afficher
    --digit_array(0) <= number_integer MOD 10;
    --digit_array(1) <= number_integer/10 MOD 10;
    --digit_array(2) <= number_integer/100 MOD 10;
    --digit_array(3) <= number_integer/1000 MOD 10;
    -- digit_array(4) <= number_integer/10000 MOD 10;
    -- digit_array(5) <= number_integer/100000 MOD 10;
    -- digit_array(6) <= number_integer/1000000 MOD 10;
    -- digit_array(7) <= number_integer/10000000 MOD 10;
    -- digit_array(8) <= number_integer/100000000 MOD 10;
    -- digit_array(9) <= number_integer/1000000000 MOD 10;
    data_out(47 DOWNTO 45)<="000";
    data_out(44) <= '1';
    data_out(43 DOWNTO 38) <= STD_LOGIC_VECTOR(to_unsigned(number_integer/1000 MOD 10,6));
    data_out(37 DOWNTO 32) <= STD_LOGIC_VECTOR(to_unsigned(number_integer/100 MOD 10,6));
    data_out(31 DOWNTO 26) <= STD_LOGIC_VECTOR(to_unsigned(number_integer/10 MOD 10,6));
    data_out(25 DOWNTO 20) <= STD_LOGIC_VECTOR(to_unsigned(number_integer MOD 10,6));

    data_out(19 DOWNTO 10) <= STD_LOGIC_VECTOR(to_unsigned(100,10));
    data_out(9 DOWNTO 0) <= STD_LOGIC_VECTOR(to_unsigned(counter_integer*15,10));

END Behavioral;