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
    PORT(
        clk             : IN  STD_LOGIC;
        reset           : IN  STD_LOGIC;
        ce              : IN  STD_LOGIC;
        prime_data_in   : IN  STD_LOGIC_VECTOR(27 DOWNTO 0);
        address_graphic : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        address_prime   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        r_w_graphic     : OUT STD_LOGIC;
        data_graphic    : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
END prime_converter;

ARCHITECTURE Behavioral OF prime_converter IS
    COMPONENT Nbit_counter
        GENERIC(WIDTH : NATURAL);
        PORT(
            clk    : IN  STD_LOGIC;
            reset  : IN  STD_LOGIC;
            ce     : IN  STD_LOGIC;
            init   : IN  STD_LOGIC;
            incr   : IN  STD_LOGIC;
            load   : IN  STD_LOGIC;
            input  : IN  STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0));
    END COMPONENT;
    --===========================================================
    COMPONENT Nbit_Nplus_counter
        GENERIC(WIDTH : NATURAL;
                PLUS  : NATURAL);
        PORT(
            clk    : IN  STD_LOGIC;
            reset  : IN  STD_LOGIC;
            ce     : IN  STD_LOGIC;
            init   : IN  STD_LOGIC;
            incr   : IN  STD_LOGIC;
            load   : IN  STD_LOGIC;
            input  : IN  STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0));
    END COMPONENT;
    --===========================================================
    COMPONENT prime_fsm IS
        PORT(
            CLK                  : IN  STD_LOGIC;
            RESET                : IN  STD_LOGIC;
            CE                   : IN  STD_LOGIC;
            DATA_PRIME           : IN  STD_LOGIC_VECTOR(27 DOWNTO 0);
            OUTPUT_CPT_ADR_PRIME : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            OUTPUT_CPT_BOUCLE    : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            INIT_CPT_ADR_GRAPH   : OUT STD_LOGIC;
            INIT_CPT_PRIME       : OUT STD_LOGIC;
            INIT_CPT_BOUCLE      : OUT STD_LOGIC;
            INCR_CPT_ADR_GRAPH   : OUT STD_LOGIC;
            INCR_CPT_PRIME       : OUT STD_LOGIC;
            INCR_CPT_BOUCLE      : OUT STD_LOGIC;
            LOAD_CPT_ADR_GRAPH   : OUT STD_LOGIC;
            LOAD_CPT_PRIME       : OUT STD_LOGIC;
            LOAD_CPT_BOUCLE      : OUT STD_LOGIC;
            r_w_graphic          : OUT STD_LOGIC);
    END COMPONENT;
    --===========================================================
    COMPONENT number_to_digit IS
        PORT(
            clk       : IN  STD_LOGIC;
            reset     : IN  STD_LOGIC;
            ce        : IN  STD_LOGIC;
            number_in : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            digit_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    --===========================================================
    component Nbit_divider IS
        generic(WIDTH : NATURAL);
        port(
            clk    : IN  STD_LOGIC;
            reset  : IN  STD_LOGIC;
            ce     : IN  STD_LOGIC;
            init   : IN  STD_LOGIC;
            incr   : IN  STD_LOGIC;
            load   : IN  STD_LOGIC;
            input  : IN  STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC
        );
    end component Nbit_divider;
    --===========================================================
    SIGNAL adress_offset_graphic : unsigned(11 DOWNTO 0)        := to_unsigned(2262, 12);
    SIGNAL adress_offset_prime   : STD_LOGIC_VECTOR(7 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(56, 8));
    SIGNAL y_offset_graphic      : unsigned(9 DOWNTO 0)         := to_unsigned(30, 10);
    SIGNAL x_offset_graphic      : unsigned(9 DOWNTO 0)         := to_unsigned(340, 10);

    SIGNAL INCR_CPT_Y            : STD_LOGIC;
    SIGNAL digit_out_signal      : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL digit_to_display      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL input_number_to_digit : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL x_for_calc : STD_LOGIC_VECTOR(9 DOWNTO 0);

    SIGNAL output_counter_graphic : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL output_counter_prime   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL output_counter_boucle  : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL output_counter_y       : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL output_divider_colonne : STD_LOGIC;
    SIGNAL output_counter_colonne : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL INIT_CPT_ADR_GRAPH : STD_LOGIC;
    SIGNAL INIT_CPT_PRIME     : STD_LOGIC;
    SIGNAL INIT_CPT_BOUCLE    : STD_LOGIC;
    SIGNAL INCR_CPT_ADR_GRAPH : STD_LOGIC;
    SIGNAL INCR_CPT_PRIME     : STD_LOGIC;
    SIGNAL INCR_CPT_BOUCLE    : STD_LOGIC;
    SIGNAL LOAD_CPT_ADR_GRAPH : STD_LOGIC;
    SIGNAL LOAD_CPT_PRIME     : STD_LOGIC;
    SIGNAL LOAD_CPT_BOUCLE    : STD_LOGIC;
BEGIN

    counter_address_graphic : Nbit_counter
        GENERIC MAP(
            WIDTH => 12
        )
        PORT MAP(
            clk    => clk,
            reset  => reset,
            ce     => ce,
            init   => INIT_CPT_ADR_GRAPH,
            incr   => INCR_CPT_ADR_GRAPH,
            load   => LOAD_CPT_ADR_GRAPH,
            input  => STD_LOGIC_VECTOR(adress_offset_graphic),
            output => output_counter_graphic);
    --===========================================================
    counter_address_prime : Nbit_counter
        GENERIC MAP(
            WIDTH => 8
        )
        PORT MAP(
            clk    => clk,
            reset  => reset,
            ce     => ce,
            init   => INIT_CPT_PRIME,
            incr   => INCR_CPT_PRIME,
            load   => LOAD_CPT_PRIME,
            input  => adress_offset_prime,
            output => output_counter_prime);
    --===========================================================
    counter_boucle : Nbit_counter
        GENERIC MAP(
            WIDTH => 3
        )
        PORT MAP(
            clk    => clk,
            reset  => reset,
            ce     => ce,
            init   => INIT_CPT_BOUCLE,
            incr   => INCR_CPT_BOUCLE,
            load   => LOAD_CPT_BOUCLE,
            input  => (OTHERS => '0'),
            output => output_counter_boucle);
    --===========================================================
    counter_y_graphic : Nbit_Nplus_counter
        GENERIC MAP(
            WIDTH => 10,
            PLUS  => 10
        )
        PORT MAP(
            clk    => clk,
            reset  => reset,
            ce     => ce,
            init   => output_divider_colonne, --reset y with each column
            incr   => INCR_CPT_Y,
            load   => LOAD_CPT_PRIME OR output_divider_colonne,   --TODO rajouter sortie dedié dans fsm
            input  => STD_LOGIC_VECTOR(y_offset_graphic),
            output => output_counter_y);
    --===========================================================
    fsm : prime_fsm
        PORT MAP(
            CLK                  => clk,
            RESET                => reset,
            CE                   => ce,
            DATA_PRIME           => prime_data_in,
            OUTPUT_CPT_ADR_PRIME => output_counter_prime,
            OUTPUT_CPT_BOUCLE    => output_counter_boucle,
            INIT_CPT_ADR_GRAPH   => INIT_CPT_ADR_GRAPH,
            INIT_CPT_PRIME       => INIT_CPT_PRIME,
            INIT_CPT_BOUCLE      => INIT_CPT_BOUCLE,
            INCR_CPT_ADR_GRAPH   => INCR_CPT_ADR_GRAPH,
            INCR_CPT_PRIME       => INCR_CPT_PRIME,
            INCR_CPT_BOUCLE      => INCR_CPT_BOUCLE,
            LOAD_CPT_ADR_GRAPH   => LOAD_CPT_ADR_GRAPH,
            LOAD_CPT_PRIME       => LOAD_CPT_PRIME,
            LOAD_CPT_BOUCLE      => LOAD_CPT_BOUCLE,
            r_w_graphic          => r_w_graphic);
    --===========================================================
    conv_chiffre : number_to_digit
        PORT MAP(
            clk       => clk,
            reset     => reset,
            ce        => ce,
            number_in => input_number_to_digit,
            digit_out => digit_out_signal);
    --===========================================================
    Nbit_divider_inst : Nbit_divider
        generic map(
            WIDTH => 6
        )
        port map(
            clk    => clk,
            reset  => reset,
            ce     => ce,
            init   => '0',
            incr   => INCR_CPT_Y,
            load   => '0',
            input  => (OTHERS => '0'),
            output => output_divider_colonne
        );
    --===========================================================
    counter_colonne : Nbit_counter
        GENERIC MAP(
            WIDTH => 4
        )
        PORT MAP(
            clk    => clk,
            reset  => reset,
            ce     => ce,
            init   => '0',
            incr   => output_divider_colonne,
            load   => '0',
            input  => (OTHERS => '0'),
            output => output_counter_colonne);
    --===========================================================
    input_number_to_digit <= "0000" & prime_data_in;
    --mux pour le bon chiffre
    --y decale en meme temps que le changement d'addresse prime
    INCR_CPT_Y            <= INCR_CPT_PRIME;
    --x decale par le counter boucle

    maj_chiffres : PROCESS(output_counter_boucle, digit_out_signal)
    BEGIN
        CASE output_counter_boucle IS
            WHEN "011" =>
                digit_to_display <= digit_out_signal(3 DOWNTO 0);
            WHEN "010" =>
                digit_to_display <= digit_out_signal(7 DOWNTO 4);
            WHEN "001" =>
                digit_to_display <= digit_out_signal(11 DOWNTO 8);
            WHEN "000" =>
                digit_to_display <= digit_out_signal(15 DOWNTO 12);
            WHEN OTHERS =>
                digit_to_display <= STD_LOGIC_VECTOR(to_unsigned(60, digit_to_display'length));
        END CASE;
    END PROCESS maj_chiffres;

    --==========================================================
    --creation de la data graphic
    data_graphic(47 DOWNTO 45) <= (OTHERS => '0');
    data_graphic(44)           <= '1';
    data_graphic(43 DOWNTO 24) <= (OTHERS => '0');
    data_graphic(23 DOWNTO 20) <= digit_to_display; --digit
    data_graphic(19 DOWNTO 10) <= output_counter_y; --y
    data_graphic(9 DOWNTO 0)   <=x_for_calc;--x

    x_for_calc<= STD_LOGIC_VECTOR(resize(unsigned(output_counter_boucle) * 6 + x_offset_graphic + (unsigned("000000" & output_counter_colonne) * 50), 10)); --x
    --==========================================================
    --CONNECTIONS
    address_graphic            <= output_counter_graphic;
    address_prime              <= output_counter_prime;
END Behavioral;
