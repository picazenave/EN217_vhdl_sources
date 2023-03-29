----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2023 00:26:10
-- Design Name: 
-- Module Name: Reg_19b - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Reg_19b IS
    PORT (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        load : IN STD_LOGIC;
        init : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(18 DOWNTO 0));
END Reg_19b;

ARCHITECTURE Behavioral OF Reg_19b IS
    SIGNAL internal_register : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            internal_register <=(OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF init = '1' THEN
                internal_register <= (OTHERS => '0');
            ELSIF ce = '1' THEN
                IF load = '1' THEN
                    internal_register <= input;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    output <= internal_register;

END Behavioral;