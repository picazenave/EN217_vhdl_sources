----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2023 14:47:27
-- Design Name: 
-- Module Name: Nbit_counter - Behavioral
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

ENTITY Nbit_Nplus_counter IS
    GENERIC (WIDTH : NATURAL;
            PLUS : NATURAL);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        init : IN STD_LOGIC;
        incr : IN STD_LOGIC;
        load : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR (WIDTH-1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR (WIDTH-1 DOWNTO 0));
END Nbit_Nplus_counter;

ARCHITECTURE Behavioral OF Nbit_Nplus_counter IS
    SIGNAL output_sig : unsigned (WIDTH-1 DOWNTO 0);
BEGIN
    cpt_process : PROCESS (clk, reset, ce) IS
    BEGIN
        IF (reset = '1') THEN
            output_sig <=  (OTHERS => '0');
        ELSIF (clk'event AND clk = '1') THEN
            IF (ce = '1') THEN
                IF (load = '1') THEN
                    output_sig <= unsigned(input);
                ELSIF (init = '1') THEN
                    output_sig <=  (OTHERS => '0');
                ELSIF (incr = '1') THEN
                    output_sig <= output_sig + to_unsigned(PLUS,WIDTH);
                END IF;
            END IF;
        END IF;
    END PROCESS cpt_process;
    output <= STD_LOGIC_VECTOR(output_sig);

END Behavioral;