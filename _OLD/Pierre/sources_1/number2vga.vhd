----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2023 09:25:39
-- Design Name: 
-- Module Name: number2vga - Behavioral
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

ENTITY number2vga IS
    PORT (
        clk : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        x : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        number_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        chiffre_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        glyph_in : IN STD_LOGIC_VECTOR(39 DOWNTO 0);
        address_out : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        ready : OUT STD_LOGIC);
END number2vga;

ARCHITECTURE Behavioral OF number2vga IS

    TYPE memory_array IS ARRAY (INTEGER RANGE 0 TO 9) OF INTEGER;-- to represent 0->9
    SIGNAL digit_array : memory_array := (
        0, --0
        OTHERS => 0);
    SIGNAL number_integer : INTEGER := 0;
    SIGNAL x_integer : INTEGER := 0;
    SIGNAL y_integer : INTEGER := 0;
    SIGNAL address_out_integer : INTEGER := 0;

    SIGNAL current_position : INTEGER := 0;
    SIGNAL current_line : INTEGER := 0;
    SIGNAL current_chiffre : INTEGER := 0;

    SIGNAL glyph_index : INTEGER := 0;
    SIGNAL chiffre_index : INTEGER := 0;

    SIGNAL internal_ready : STD_LOGIC := '1';

BEGIN
    number_integer <= to_integer(unsigned(number_in));
    x_integer <= to_integer(unsigned(x));
    y_integer <= to_integer(unsigned(y));

    --decomposer nombre pour chiffre � afficher
    digit_array(0) <= number_integer MOD 10;
    digit_array(1) <= number_integer/10 MOD 10;
    digit_array(2) <= number_integer/100 MOD 10;
    digit_array(3) <= number_integer/1000 MOD 10;
    digit_array(4) <= number_integer/10000 MOD 10;
    digit_array(5) <= number_integer/100000 MOD 10;
    digit_array(6) <= number_integer/1000000 MOD 10;
    digit_array(7) <= number_integer/10000000 MOD 10;
    digit_array(8) <= number_integer/100000000 MOD 10;
    digit_array(9) <= number_integer/1000000000 MOD 10;
    --calculer addresse avec x et y
    address_out_integer <= y_integer * 640 + x_integer;

    --ready '0'
    --chercher glyph
    --sortir glyph 1bit par 1bit
    --passer au chiffre suivant
    glyph_index <= current_position + current_line * 5;
    chiffre_index <= 9 - current_chiffre;
    PROCESS (glyph_index)
    BEGIN
        --traitement
        address_out <= STD_LOGIC_VECTOR(to_unsigned(address_out_integer + current_chiffre * 6 + current_position + current_line * 640, address_out'length));

        IF (glyph_index = 40) THEN
            data_out(0) <= '0';
        ELSE
            data_out(0) <= glyph_in(39 - glyph_index);
        END IF;
    END PROCESS;

    -- process(current_chiffre)
    --     begin
    --     if (current_chiffre=10) then
    --         chiffre_out<="0000";
    --     else

    --     end if;
    -- end process;

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF ce = '1' THEN
                IF (enable = '1') AND (internal_ready = '1') THEN
                    internal_ready <= '0';
                    chiffre_out <= STD_LOGIC_VECTOR(to_unsigned(digit_array(9 - current_chiffre), chiffre_out'length));
                    --address_out<="0000000000000000000";
                    --data_out<="0";
                ELSIF internal_ready = '0' THEN

                    IF (current_chiffre = 10) THEN
                        chiffre_out <= "0000";
                    ELSE
                        chiffre_out <= STD_LOGIC_VECTOR(to_unsigned(digit_array(9 - current_chiffre), chiffre_out'length));
                    END IF;

                    --verification des boucles
                    current_position <= current_position + 1;

                    IF (current_position = 4) THEN --bout de ligne aller a la suivante
                        current_line <= current_line + 1;
                        current_position <= 0;
                    END IF;

                    IF (current_line = 8) THEN --fin de l'ecriture du chiffre courant
                        current_chiffre <= current_chiffre + 1;
                        current_position <= 0;
                        current_line <= 0;
                    END IF;

                    IF (current_chiffre = 10) THEN--fin de l'ecriture du nombre
                        internal_ready <= '1';
                        current_position <= 0;
                        current_line <= 0;
                        current_chiffre <= 0;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    ready <= internal_ready;
END Behavioral;