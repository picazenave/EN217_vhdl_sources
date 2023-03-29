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

ENTITY top_level_test_vga IS
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
END top_level_test_vga;
ARCHITECTURE Behavioral OF top_level_test_vga IS
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
      --=========================================================
      -- COMPONENT glyph_memory
      --       PORT (
      --             clk : IN STD_LOGIC;
      --             ce : IN STD_LOGIC;
      --             number : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      --             data_out : OUT STD_LOGIC_VECTOR (39 DOWNTO 0));
      -- END COMPONENT;
      --=========================================================
      -- component number2vga
      --         port (clk         : in std_logic;
      --               ce          : in std_logic;
      --               enable      : in std_logic;
      --               x           : in std_logic_vector (10 downto 0);
      --               y           : in std_logic_vector (10 downto 0);
      --               number_in   : in std_logic_vector (31 downto 0);
      --               chiffre_out : out std_logic_vector (3 downto 0);
      --               glyph_in    : in std_logic_vector (39 downto 0);
      --               address_out : out std_logic_vector (18 downto 0);
      --               data_out    : out std_logic_vector(0 downto 0);
      --               ready       : out std_logic);
      --     end component;
      COMPONENT drawing_entity
            PORT (
                  clk : IN STD_LOGIC;
                  ce : IN STD_LOGIC;
                  enable : IN STD_LOGIC;
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
                  ce2hz : OUT STD_LOGIC;
                  AN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                  Sseg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                  LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                  LEDg : OUT STD_LOGIC);
      END COMPONENT;
      --=========================================================
      SIGNAL sig_clk : STD_LOGIC;
      SIGNAL ce2hz : STD_LOGIC;
      SIGNAL ce1s : STD_LOGIC;
      SIGNAL ce25M : STD_LOGIC;
      SIGNAL sig_ce : STD_LOGIC;
      SIGNAL LEDg : STD_LOGIC;
      SIGNAL sig_locked : STD_LOGIC;
      SIGNAL sig_reset : STD_LOGIC;

      SIGNAL sig_chiffre_to_glyph : STD_LOGIC_VECTOR(3 DOWNTO 0);
      SIGNAL sig_data_glyph_out : STD_LOGIC_VECTOR(39 DOWNTO 0);

      SIGNAL sig_address_vga : STD_LOGIC_VECTOR(18 DOWNTO 0);
      SIGNAL sig_data_vga : STD_LOGIC_VECTOR(0 DOWNTO 0);

BEGIN

      -- glyph_bank : glyph_memory
      -- PORT MAP(
      --       clk => sig_clk,
      --       ce => sig_ce,
      --       number => sig_chiffre_to_glyph,
      --       data_out => sig_data_glyph_out);
      --=========================================================             
      -- gpu : number2vga
      --     port map (clk         => sig_clk,
      --               ce          => sig_ce,
      --               enable      => '1',
      --               x           => std_logic_vector(to_unsigned(200 , 11)),
      --               y           => std_logic_vector(to_unsigned(10 , 11)),
      --               number_in   => std_logic_vector(to_unsigned(1234567890 , 32)),
      --               chiffre_out => sig_chiffre_to_glyph,
      --               glyph_in    => sig_data_glyph_out,
      --               address_out => sig_address_vga,
      --               data_out    => sig_data_vga,
      --               ready       => open);
      drawer : drawing_entity
      PORT MAP(
            clk => sig_clk,
            ce => sig_ce,
            enable => '1',
            mode => '0',--0 means primitive
            x => std_logic_vector(to_unsigned(10 , 10)),
            y => std_logic_vector(to_unsigned(10 , 10)),
            x2 => std_logic_vector(to_unsigned(400 , 10)),
            y2 => std_logic_vector(to_unsigned(240 , 10)),
            address_out => sig_address_vga,
            data_out => sig_data_vga,
            ready => open);
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
            data_write => '1',
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
            ce2hz,
            AN,
            Sevenseg,
            LED,
            LEDg);

      sig_ce <= ce25M;
      sig_reset <= NOT (reset);
      sig_clk <= clk100M;
END Behavioral;