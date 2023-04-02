----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2023 10:51:42
-- Design Name: 
-- Module Name: top_level_test_vga - Behavioral
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

ENTITY top_level_complet IS
    PORT (
        reset : IN STD_LOGIC;
        clk100M : IN STD_LOGIC;
        AN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Sevenseg : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        LED : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        VGA_HS : OUT STD_LOGIC; -- horisontal vga syncr.
        VGA_VS : OUT STD_LOGIC; -- vertical vga syncr.
        VGA_R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- red output
        VGA_G : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- green output
        VGA_B : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- blue output
    );
END top_level_complet;

ARCHITECTURE Behavioral OF top_level_complet IS
    -- attribute mark_debug : string;
    --=========================================================
    TYPE etat IS(mode_graphic,
    mode_text);
    --=========================================================
    COMPONENT VGA_bitmap_640x480
        GENERIC (
            bit_per_pixel : INTEGER RANGE 1 TO 12 := 1; -- number of bits per pixel
            grayscale : BOOLEAN := false); -- should data be displayed in grayscale
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            VGA_hs : OUT STD_LOGIC; -- horisontal vga syncr.
            VGA_vs : OUT STD_LOGIC; -- vertical vga syncr.
            VGA_red : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- red output
            VGA_green : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- green output
            VGA_blue : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- blue output
            ADDR : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(bit_per_pixel - 1 DOWNTO 0);
            data_write : IN STD_LOGIC;
            data_out : OUT STD_LOGIC_VECTOR(bit_per_pixel - 1 DOWNTO 0));
    END COMPONENT;
    COMPONENT drawing_entity
        PORT (
            clk : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            mode : IN STD_LOGIC;
            x : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            y : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            x2 : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            y2 : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            address_out : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
            ready : OUT STD_LOGIC);
    END COMPONENT;
    --=========================================================   
    COMPONENT acces_carte
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            AdrLSB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            AdrMSB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            DataLSB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            DataMSB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            DataInMem : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            ce1s : OUT STD_LOGIC;
            ce25M : OUT STD_LOGIC;
            cemodif : OUT STD_LOGIC;
            AN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            Sseg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            LEDg : OUT STD_LOGIC);
    END COMPONENT;
    --=========================================================
    COMPONENT FSM_GPU
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR (47 DOWNTO 0);
            ready_drawing_entity : IN STD_LOGIC;
            enable_drawing : OUT STD_LOGIC;
            address : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
    END COMPONENT;
    --=========================================================
    COMPONENT graphic_memory IS
        PORT (
            clk : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            rw : IN STD_LOGIC;--R/=0 W=1
            address_read_only : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            input : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
            data_out_read_only : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
    END COMPONENT;
    --=========================================================
    COMPONENT prime_converter
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            prime_data_in : IN STD_LOGIC_VECTOR (27 DOWNTO 0);
            address_graphic : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
            address_prime : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            r_w_graphic : OUT STD_LOGIC;
            data_graphic : OUT STD_LOGIC_VECTOR (47 DOWNTO 0));
    END COMPONENT;
    --=========================================================
    SIGNAL sig_clk : STD_LOGIC;
    SIGNAL cemodif : STD_LOGIC;
    SIGNAL ce1s : STD_LOGIC;
    SIGNAL ce25M : STD_LOGIC;
    SIGNAL sig_ce : STD_LOGIC;
    SIGNAL LEDg : STD_LOGIC;
    SIGNAL sig_locked : STD_LOGIC;
    SIGNAL sig_reset : STD_LOGIC;

    SIGNAL sig_address_vga : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL sig_data_vga : STD_LOGIC_VECTOR(0 DOWNTO 0);

    SIGNAL sig_ready_drawing_entity : STD_LOGIC;
    SIGNAL sig_enable_drawing : STD_LOGIC;

    SIGNAL sig_address_to_memory : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL sig_data_from_memory : STD_LOGIC_VECTOR(47 DOWNTO 0);

    SIGNAL prime_data_in : STD_LOGIC_VECTOR (27 DOWNTO 0);--TODO remplace CPU
    SIGNAL address_graphic : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL address_prime : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL r_w_graphic : STD_LOGIC;
    SIGNAL data_graphic : STD_LOGIC_VECTOR (47 DOWNTO 0);

    -- attribute mark_debug of sig_ready_drawing_entity : signal is "true";
    -- attribute mark_debug of sig_enable_drawing : signal is "true";
    -- attribute mark_debug of sig_data_from_memory : signal is "true";

    --========================================================
    --DEBUT COEUR CPU
    --========================================================
    COMPONENT Memory
        PORT (
            clk : IN STD_LOGIC;
            ce : IN STD_LOGIC;
            rw : IN STD_LOGIC;--R/=0 W=0
            enable : IN STD_LOGIC;
            address_read_only : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
            address : IN STD_LOGIC_VECTOR(27 DOWNTO 0);
            input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            output_read_only : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;

    COMPONENT CPU
        PORT (
            CLK : IN STD_LOGIC;
            RST : IN STD_LOGIC;
            CE : IN STD_LOGIC;
            DATA_FROM_MEMORY : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            DATA_TO_MEMORY : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            ADR_MEM : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
            RW_MEMORY : OUT STD_LOGIC;
            ENABLE_MEMORY : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL data_from_memory : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL data_to_memory : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL adr_mem : STD_LOGIC_VECTOR (27 DOWNTO 0);
    SIGNAL rw_memory : STD_LOGIC;
    SIGNAL enable_memory : STD_LOGIC;

    SIGNAL address_read_only : STD_LOGIC_VECTOR (27 DOWNTO 0);
    SIGNAL output_read_only : STD_LOGIC_VECTOR (31 DOWNTO 0);

    --========================================================
    --FIN COEUR CPU
    --========================================================

BEGIN
    --========================================================= 
    graphic_memory_component : graphic_memory
    PORT MAP(
        clk => sig_clk,
        ce => sig_ce,
        rw => r_w_graphic, --R/=0 W=1
        input => data_graphic,
        address_read_only => sig_address_to_memory,
        address => address_graphic,
        data_out_read_only => sig_data_from_memory,
        data_out => OPEN);
    --=========================================================  
    fsm : FSM_GPU
    PORT MAP(
        clk => sig_clk,
        reset => sig_reset,
        ce => sig_ce,
        data_in => sig_data_from_memory,
        ready_drawing_entity => sig_ready_drawing_entity,
        enable_drawing => sig_enable_drawing,
        address => sig_address_to_memory);
    --=========================================================          
    drawer : drawing_entity
    PORT MAP(
        clk => sig_clk,
        ce => sig_ce,
        enable => sig_enable_drawing,
        reset => sig_reset,
        mode => sig_data_from_memory(44), --0 means primitive / 1 text
        x => sig_data_from_memory(9 DOWNTO 0),
        y => sig_data_from_memory(19 DOWNTO 10),
        x2 => sig_data_from_memory(29 DOWNTO 20),
        y2 => sig_data_from_memory(39 DOWNTO 30),
        address_out => sig_address_vga,
        data_out => sig_data_vga,
        ready => sig_ready_drawing_entity);
    --=========================================================
    VGA_out : VGA_bitmap_640x480
    GENERIC MAP(
        bit_per_pixel => 1,
        grayscale => false)
    PORT MAP(
        clk => sig_clk,
        reset => sig_reset,
        VGA_hs => VGA_HS,
        VGA_vs => VGA_VS,
        VGA_red => VGA_R,
        VGA_green => VGA_G,
        VGA_blue => VGA_B,
        ADDR => sig_address_vga,
        data_in => sig_data_vga,
        data_write => sig_enable_drawing,
        data_out => OPEN);
    --=========================================================
    Peripheriques : acces_carte
    PORT MAP(
        sig_clk,
        sig_reset,
        "0000",
        "00",
        "0000",
        "0000",
        "00000000",
        ce1s,
        ce25M,
        cemodif,
        AN,
        Sevenseg,
        LED,
        LEDg);
    --=========================================================
    prime_to_memory : prime_converter
    PORT MAP(
        clk => sig_clk,
        reset => sig_reset,
        ce => sig_ce,
        prime_data_in => output_read_only(27 DOWNTO 0),
        address_graphic => address_graphic,
        address_prime => address_prime,
        r_w_graphic => r_w_graphic,
        data_graphic => data_graphic);
    --=========================================================   
    -- fake_memory : PROCESS (address_prime)
    -- BEGIN
    --     IF (unsigned(address_prime) < 2) THEN
    --         prime_data_in <= STD_LOGIC_VECTOR(to_unsigned(1234, 28));
    --     END IF;
    -- END PROCESS fake_memory;
    --=========================================================
    --=========================================================
    coeur_cpu : CPU
    PORT MAP(
        CLK => sig_clk,
        RST => sig_reset,
        CE => sig_ce,
        DATA_FROM_MEMORY => data_from_memory,
        DATA_TO_MEMORY => data_to_memory,
        ADR_MEM => adr_mem,
        RW_MEMORY => rw_memory,
        ENABLE_MEMORY => enable_memory);

    Memory_CPU : Memory
    PORT MAP(
        clk => sig_clk,
        ce => sig_ce,
        rw => rw_memory,
        enable => enable_memory,
        address_read_only => x"00000" & address_prime,
        address => adr_mem,
        input => data_to_memory,
        output_read_only => output_read_only,
        output => data_from_memory);
    --=========================================================
    --=========================================================
    --address_read_only<=x"00000" & address_prime;
    --output_read_only<=x"0" & prime_data_in;

    --sig_ce <= cemodif;
    sig_ce <= ce25M;
    --sig_ce <= '1';
    sig_reset <= NOT (reset);
    sig_clk <= clk100M;

END Behavioral;