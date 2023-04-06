----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 17:13:33
-- Design Name: 
-- Module Name: primitive_drawing - Behavioral
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

ENTITY line_drawing IS
    PORT(
        clk         : IN  STD_LOGIC;
        ce          : IN  STD_LOGIC;
        enable      : IN  STD_LOGIC;
        x           : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        y           : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        x2          : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        y2          : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
        address_out : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
        data_out    : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        ready       : OUT STD_LOGIC);
END line_drawing;

ARCHITECTURE Behavioral OF line_drawing IS
    component Nbit_counter
        generic(WIDTH : NATURAL);
        port(
            clk    : IN  STD_LOGIC;
            reset  : IN  STD_LOGIC;
            ce     : IN  STD_LOGIC;
            init   : IN  STD_LOGIC;
            incr   : IN  STD_LOGIC;
            load   : IN  STD_LOGIC;
            input  : IN  STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0)
        );
    end component Nbit_counter;

    SIGNAL internal_ready : STD_LOGIC                    := '0';
    SIGNAL load_cnt       : STD_LOGIC                    := '1';
    SIGNAL incr_cnt       : STD_LOGIC                    := '0';
    SIGNAL output_cnt     : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');

    SIGNAL x_out : unsigned(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y_out : unsigned(10 DOWNTO 0) := (OTHERS => '0');
BEGIN
    Nbit_counter_inst : component Nbit_counter
        generic map(
            WIDTH => 10
        )
        port map(
            clk    => clk,
            reset  => '0',
            ce     => ce,
            init   => '0',
            incr   => incr_cnt,
            load   => load_cnt,
            input  => x,
            output => output_cnt
        );

    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (enable = '0') THEN
                internal_ready <= '0';
                x_out          <= (OTHERS => '0');
                y_out          <= (OTHERS => '0');
                load_cnt       <= '1';
                data_out(0)    <= '0';

            ELSIF ce = '1' THEN

                IF internal_ready = '0' THEN
                    load_cnt <= '0';
                    incr_cnt <= '1';

                    if unsigned(output_cnt) = unsigned(x2) then --fini de dessiner
                        internal_ready <= '1';
                        incr_cnt       <= '0';
                        data_out(0)    <= '0';
                    else
                        data_out(0) <= '1';
                    end if;

                END IF;
            END IF;
        END IF;
    END PROCESS;

    address_out <= STD_LOGIC_VECTOR(resize(unsigned(output_cnt) + unsigned(y) * 640, 19));
    ready       <= internal_ready;

END Behavioral;
