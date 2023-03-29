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

ENTITY FSM_GPU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
        ready_drawing_entity : IN STD_LOGIC;
        enable_drawing : OUT STD_LOGIC;
        address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END FSM_GPU;

ARCHITECTURE Behavioral OF FSM_GPU IS
    -- ATTRIBUTE mark_debug : STRING;
    COMPONENT Nbit_counter
        GENERIC (WIDTH : NATURAL);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            init : IN STD_LOGIC;
            incr : IN STD_LOGIC;
            load : IN STD_LOGIC;
            input : IN STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR (WIDTH - 1 DOWNTO 0));
    END COMPONENT;
    TYPE etat IS(init,
    fetch_data_graphic,
    display_graphic,
    loop_graphic,
    end_state);

    SIGNAL pr_state, nx_state : Etat;

    SIGNAL load_pc : STD_LOGIC;
    SIGNAL incr_pc : STD_LOGIC;
    SIGNAL init_pc : STD_LOGIC;
    SIGNAL output_pc : STD_LOGIC_VECTOR(11 DOWNTO 0);

    -- ATTRIBUTE mark_debug OF pr_state : SIGNAL IS "true";
    -- ATTRIBUTE mark_debug OF address : SIGNAL IS "true";
BEGIN

    address_counter : Nbit_counter
    GENERIC MAP(
        WIDTH => 12
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init => init_pc,
        incr => incr_pc,
        load => '0',
        input => (OTHERS => '0'),
        output => output_pc);

    maj_etat : PROCESS (clk, reset) IS
    BEGIN
        IF (reset = '1') THEN
            pr_state <= init;
        ELSIF (clk'event AND clk = '1') THEN
            IF (ce = '1') THEN
                pr_state <= nx_state;
            END IF;
        END IF;
    END PROCESS maj_etat;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    calc_new_state : PROCESS (data_in, pr_state, ready_drawing_entity) IS
    BEGIN
        CASE pr_state IS
            WHEN init => nx_state <= fetch_data_graphic;
                ----------------------------------------------------------------------------------
            WHEN fetch_data_graphic =>
                IF (data_in = x"000000000000") THEN
                    nx_state <= end_state;
                ELSE
                    nx_state <= display_graphic;
                END IF;
                ----------------------------------------------------------------------------------
            WHEN display_graphic =>
                IF (ready_drawing_entity = '1') THEN
                    nx_state <= loop_graphic;
                ELSE
                    nx_state <= display_graphic;
                END IF;
            WHEN loop_graphic =>
                IF (data_in = x"000000000000") THEN
                    nx_state <= end_state;
                ELSE
                    nx_state <= fetch_data_graphic;
                END IF;

            WHEN end_state =>
                IF (data_in = x"000000000000") THEN
                    nx_state <= end_state;
                ELSE
                    nx_state <= fetch_data_graphic;
                END IF;
                ----------------------------------------------------------------------------------
                --WHEN exec_IFSup => nx_state <= fetch_instruction;
        END CASE;

    END PROCESS calc_new_state;
    ----------------------------------------------------------------------------------

    --===============================================================================

    ----------------------------------------------------------------------------------
    calc_output : PROCESS (pr_state)
    BEGIN
        CASE pr_state IS
            WHEN init =>
                --address <= (OTHERS => '0');
                enable_drawing <= '0';
                --counter_address_graphic <= (OTHERS => '0');
                init_pc <= '1';
                incr_pc <= '0';

            WHEN fetch_data_graphic => -- 1 for graphic data
                --address <= STD_LOGIC_VECTOR(counter_address_graphic);
                enable_drawing <= '0';
                incr_pc <= '0';
                init_pc <= '0';

            WHEN display_graphic =>
                enable_drawing <= '1';
                incr_pc <= '0';
                init_pc <= '0';

            WHEN loop_graphic =>
                enable_drawing <= '0';
                incr_pc <= '1';
                init_pc <= '0';
                --counter_address_graphic <= counter_address_graphic + 1;

            WHEN end_state =>
                --address <= (OTHERS => '0');
                enable_drawing <= '0';
                --counter_address_graphic <= (OTHERS => '0');
                incr_pc <= '0';
                init_pc <= '0';
        END CASE;
    END PROCESS calc_output;

    address <= output_pc;

END Behavioral;