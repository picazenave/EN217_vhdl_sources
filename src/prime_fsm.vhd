----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 09:11:04
-- Design Name: 
-- Module Name: FSM - Behavioral
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

ENTITY prime_fsm IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        CE : IN STD_LOGIC;
        DATA_PRIME : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
        OUTPUT_CPT_ADR_PRIME : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        OUTPUT_CPT_BOUCLE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        INIT_CPT_ADR_GRAPH : OUT STD_LOGIC;
        INIT_CPT_PRIME : OUT STD_LOGIC;
        INIT_CPT_BOUCLE : OUT STD_LOGIC;

        INCR_CPT_ADR_GRAPH : OUT STD_LOGIC;
        INCR_CPT_PRIME : OUT STD_LOGIC;
        INCR_CPT_BOUCLE : OUT STD_LOGIC;

        LOAD_CPT_ADR_GRAPH : OUT STD_LOGIC;
        LOAD_CPT_PRIME : OUT STD_LOGIC;
        LOAD_CPT_BOUCLE : OUT STD_LOGIC;

        r_w_graphic : OUT STD_LOGIC);
END prime_fsm;

ARCHITECTURE Behavioral OF prime_fsm IS
    TYPE etat IS(
    init,
    fetch_data_prime,
    loop_state,
    copy_graphic,
    loop_graphic,
    raz_incr,
    end_state);

    SIGNAL pr_state, nx_state : Etat;
    SIGNAL boucle_to_do : unsigned(2 DOWNTO 0) := to_unsigned(0, 3);
BEGIN

    maj_etat : PROCESS (CLK, RESET) IS
    BEGIN
        IF (RESET = '1') THEN
            pr_state <= init;
        ELSIF (CLK'event AND CLK = '1') THEN
            IF (CE = '1') THEN
                pr_state <= nx_state;
            END IF;
        END IF;
    END PROCESS maj_etat;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    --TODO
    --permettrait de pas afficher les 0 devant les nombres

    -- maj_boucle_todo : PROCESS (DATA_PRIME) IS
    -- BEGIN
    --     boucle_to_do<=
    -- END PROCESS maj_boucle_todo;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    calc_new_state : PROCESS (pr_state, DATA_PRIME, OUTPUT_CPT_BOUCLE, OUTPUT_CPT_ADR_PRIME) IS
    BEGIN
        CASE pr_state IS
            WHEN init => nx_state <= fetch_data_prime;
                ----------------------------------------------------------------------------------
            WHEN fetch_data_prime => nx_state <= loop_state;
                ----------------------------------------------------------------------------------
            WHEN loop_state =>
                IF (DATA_PRIME = "0000000000000000000000000000") THEN
                    nx_state <= fetch_data_prime;
                ELSIF (OUTPUT_CPT_ADR_PRIME = x"F8") THEN--TODO s'arrete à 45+57=45+debut data nb premier 0x66
                    nx_state <= end_state;
                ELSE
                    nx_state <= copy_graphic;
                END IF;
                ----------------------------------------------------------------------------------
            WHEN copy_graphic => nx_state <= loop_graphic;
                ----------------------------------------------------------------------------------
            WHEN loop_graphic =>
                IF (unsigned(OUTPUT_CPT_BOUCLE) < 3) THEN
                    nx_state <= copy_graphic;
                ELSE
                    nx_state <= raz_incr;
                END IF;
                ----------------------------------------------------------------------------------
            WHEN raz_incr =>
                nx_state <= fetch_data_prime;
                ----------------------------------------------------------------------------------
            WHEN end_state =>
                nx_state <= fetch_data_prime;--TODO loop car le CPU va pas aussi vite donc s'arret trop vite sinon
        END CASE;

    END PROCESS calc_new_state;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    calc_output : PROCESS (pr_state)
    BEGIN
        CASE pr_state IS
            WHEN init =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '1';

                INCR_CPT_ADR_GRAPH <= '0';
                INCR_CPT_PRIME <= '0';
                INCR_CPT_BOUCLE <= '0';

                LOAD_CPT_ADR_GRAPH <= '1';
                LOAD_CPT_PRIME <= '1';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '0';
                ----------------------------------------------------------------------------------
            WHEN fetch_data_prime =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '0';

                INCR_CPT_ADR_GRAPH <= '0';
                INCR_CPT_PRIME <= '0';
                INCR_CPT_BOUCLE <= '0';

                LOAD_CPT_ADR_GRAPH <= '0';
                LOAD_CPT_PRIME <= '0';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '0';
                ----------------------------------------------------------------------------------
            WHEN loop_state =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '0';

                INCR_CPT_ADR_GRAPH <= '0';
                INCR_CPT_PRIME <= '0';
                INCR_CPT_BOUCLE <= '0';

                LOAD_CPT_ADR_GRAPH <= '0';
                LOAD_CPT_PRIME <= '0';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '0';
                ----------------------------------------------------------------------------------
            WHEN copy_graphic =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '0';

                INCR_CPT_ADR_GRAPH <= '0';
                INCR_CPT_PRIME <= '0';
                INCR_CPT_BOUCLE <= '0';

                LOAD_CPT_ADR_GRAPH <= '0';
                LOAD_CPT_PRIME <= '0';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '1';
                ----------------------------------------------------------------------------------
            WHEN loop_graphic =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '0';

                INCR_CPT_ADR_GRAPH <= '1';
                INCR_CPT_PRIME <= '0';
                INCR_CPT_BOUCLE <= '1';

                LOAD_CPT_ADR_GRAPH <= '0';
                LOAD_CPT_PRIME <= '0';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '0';
                ----------------------------------------------------------------------------------
            WHEN raz_incr =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '1';

                INCR_CPT_ADR_GRAPH <= '0';
                INCR_CPT_PRIME <= '1';
                INCR_CPT_BOUCLE <= '0';

                LOAD_CPT_ADR_GRAPH <= '0';
                LOAD_CPT_PRIME <= '0';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '0';
                ----------------------------------------------------------------------------------
            WHEN end_state =>
                INIT_CPT_ADR_GRAPH <= '0';
                INIT_CPT_PRIME <= '0';
                INIT_CPT_BOUCLE <= '0';

                INCR_CPT_ADR_GRAPH <= '0';
                INCR_CPT_PRIME <= '0';
                INCR_CPT_BOUCLE <= '0';

                LOAD_CPT_ADR_GRAPH <= '0';
                LOAD_CPT_PRIME <= '0';
                LOAD_CPT_BOUCLE <= '0';

                r_w_graphic <= '0';
                ----------------------------------------------------------------------------------
        END CASE;
    END PROCESS calc_output;
END Behavioral;