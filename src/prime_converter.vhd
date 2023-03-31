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

ENTITY prime_converter IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        ce : IN STD_LOGIC;
        prime_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        address_graphic : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        address_prime : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        r_w_graphic : OUT STD_LOGIC;
        data_graphic : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
END prime_converter;

ARCHITECTURE Behavioral OF prime_converter IS
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
    --===========================================================
    COMPONENT prime_fsm IS
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            CE : IN STD_LOGIC;
            DATA_PRIME : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
            OUTPUT_CPT_ADR_PRIME : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
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
    END COMPONENT;
    --===========================================================
    COMPONENT number_to_digit IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            number_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            digit_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    --===========================================================
    SIGNAL adress_offset_graphic : unsigned(11 DOWNTO 0);
    SIGNAL adress_offset_prime : unsigned(11 DOWNTO 0);
    SIGNAL y_offset_graphic : unsigned(9 DOWNTO 0);

    SIGNAL INCR_CPT_Y : STD_LOGIC;
    SIGNAL digit_out_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL digit_to_display : STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- SIGNAL digit0 : unsigned(3 DOWNTO 0);
    -- SIGNAL digit1 : unsigned(3 DOWNTO 0);
    -- SIGNAL digit2 : unsigned(3 DOWNTO 0);
    -- SIGNAL digit3 : unsigned(3 DOWNTO 0);

    SIGNAL output_counter_graphic : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL output_counter_prime : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL output_counter_boucle : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL output_counter_y : STD_LOGIC_VECTOR(9 DOWNTO 0);

    SIGNAL INIT_CPT_ADR_GRAPH : STD_LOGIC;
    SIGNAL INIT_CPT_PRIME : STD_LOGIC;
    SIGNAL INIT_CPT_BOUCLE : STD_LOGIC;
    SIGNAL INCR_CPT_ADR_GRAPH : STD_LOGIC;
    SIGNAL INCR_CPT_PRIME : STD_LOGIC;
    SIGNAL INCR_CPT_BOUCLE : STD_LOGIC;
    SIGNAL LOAD_CPT_ADR_GRAPH : STD_LOGIC;
    SIGNAL LOAD_CPT_PRIME : STD_LOGIC;
    SIGNAL LOAD_CPT_BOUCLE : STD_LOGIC;
BEGIN

    counter_address_graphic : Nbit_counter
    GENERIC MAP(
        WIDTH => 12
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init => INIT_CPT_ADR_GRAPH,
        incr => INCR_CPT_ADR_GRAPH,
        load => LOAD_CPT_ADR_GRAPH,
        input => STD_LOGIC_VECTOR(adress_offset_graphic),
        output => output_counter_graphic);
    --===========================================================
    counter_address_prime : Nbit_counter
    GENERIC MAP(
        WIDTH => 12
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init => INIT_CPT_PRIME,
        incr => INCR_CPT_PRIME,
        load => LOAD_CPT_PRIME,
        input => STD_LOGIC_VECTOR(adress_offset_prime),
        output => output_counter_prime);
    --===========================================================
    counter_boucle : Nbit_counter
    GENERIC MAP(
        WIDTH => 3
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init => INIT_CPT_BOUCLE,
        incr => INCR_CPT_BOUCLE,
        load => LOAD_CPT_BOUCLE,
        input => (OTHERS => '0'),
        output => output_counter_boucle);
    --===========================================================
    counter_y_graphic : Nbit_counter
    GENERIC MAP(
        WIDTH => 3
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        init => '0',
        incr => INCR_CPT_Y,
        load => '0',
        input => STD_LOGIC_VECTOR(y_offset_graphic),
        output => output_counter_y);
    --===========================================================
    fsm : prime_fsm
    PORT MAP(
        CLK => clk,
        RESET => reset,
        CE => ce,
        DATA_PRIME => prime_data_in,
        OUTPUT_CPT_ADR_PRIME => output_counter_graphic,
        OUTPUT_CPT_BOUCLE => output_counter_boucle,
        INIT_CPT_ADR_GRAPH => INIT_CPT_ADR_GRAPH,
        INIT_CPT_PRIME => INIT_CPT_PRIME,
        INIT_CPT_BOUCLE => INIT_CPT_BOUCLE,
        INCR_CPT_ADR_GRAPH => INCR_CPT_ADR_GRAPH,
        INCR_CPT_PRIME => INCR_CPT_PRIME,
        INCR_CPT_BOUCLE => INCR_CPT_BOUCLE,
        LOAD_CPT_ADR_GRAPH => LOAD_CPT_ADR_GRAPH,
        LOAD_CPT_PRIME => LOAD_CPT_PRIME,
        LOAD_CPT_BOUCLE => LOAD_CPT_BOUCLE,
        r_w_graphic => r_w_graphic);
    --===========================================================
    conv_chiffre : number_to_digit
    PORT MAP(
        clk => clk,
        reset => reset,
        ce => ce,
        number_in => prime_data_in,
        digit_out => digit_out_signal);
    --===========================================================
    --mux pour le bon chiffre
    --y decale en meme temps que le changement d'addresse prime
    INCR_CPT_Y <= INCR_CPT_PRIME;
    --x decale par le counter boucle

    maj_chiffres : PROCESS (digit_out_signal)
    BEGIN
        CASE output_counter_boucle IS
            WHEN "000" =>
                digit_to_display <= digit_out_signal(3 DOWNTO 0);
            WHEN "000" =>
                digit_to_display <= digit_out_signal(7 DOWNTO 4);
            WHEN "000" =>
                digit_to_display <= digit_out_signal(11 DOWNTO 8);
            WHEN "000" =>
                digit_to_display <= digit_out_signal(15 DOWNTO 12);
            WHEN OTHERS =>
                digit_to_display <= STD_LOGIC_VECTOR(to_unsigned(60, digit_to_display'length));
        END CASE;
    END PROCESS maj_chiffres;
    -- maj_chiffres : PROCESS (CLK, RESET) IS--peut etre enlever et mettre juste un mux
    -- BEGIN
    --     IF (RESET = '1') THEN
    --         digit0 <= "0000";
    --         digit1 <= "0000";
    --         digit2 <= "0000";
    --         digit3 <= "0000";
    --     ELSIF (CLK'event AND CLK = '1') THEN
    --         IF (CE = '1') THEN
    --             digit0 <= digit_out_signal(3 DOWNTO 0);
    --             digit1 <= digit_out_signal(7 DOWNTO 4);
    --             digit2 <= digit_out_signal(11 DOWNTO 8);
    --             digit3 <= digit_out_signal(15 DOWNTO 12);
    --         END IF;
    --     END IF;
    -- END PROCESS maj_chiffres;

    --==========================================================
    --creation de la data graphic
    data_graphic(44)<='1';
    data_graphic(43 DOWNTO 24)<=(OTHERS => '0');
    data_graphic(23 DOWNTO 20)<=digit_to_display;--digit
    data_graphic(19 DOWNTO 10)<=output_counter_y;--y
    data_graphic(9 DOWNTO 0)<=output_counter_boucle;--x
    --==========================================================
    --CONNECTIONS
    address_graphic <= output_counter_graphic;
    address_prime <= output_counter_prime;
END Behavioral;