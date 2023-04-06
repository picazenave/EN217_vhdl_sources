----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.02.2023 16:16:50
-- Design Name: 
-- Module Name: drawing_entity - Behavioral
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

ENTITY drawing_entity IS
        PORT (
                clk : IN STD_LOGIC;
                ce : IN STD_LOGIC;
                enable : IN STD_LOGIC;
                reset : IN STD_LOGIC;
                mode : IN STD_LOGIC;--1=character 0=drawing
                x : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
                y : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
                x2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
                y2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
                address_out : OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
                data_out : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
                ready : OUT STD_LOGIC);
END drawing_entity;

ARCHITECTURE Behavioral OF drawing_entity IS
        --================================================================
        COMPONENT glyph_memory
                PORT (
                        clk : IN STD_LOGIC;
                        ce : IN STD_LOGIC;
                        number : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
                        data_out : OUT STD_LOGIC_VECTOR (39 DOWNTO 0));
        END COMPONENT;
        --================================================================
        COMPONENT glyph_drawing
                PORT (
                        clk : IN STD_LOGIC;
                        ce : IN STD_LOGIC;
                        enable : IN STD_LOGIC;
                        reset : IN STD_LOGIC;
                        x : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                        y : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                        glyph_data_in : IN STD_LOGIC_VECTOR (39 DOWNTO 0);
                        address_out : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                        data_out : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
                        ready : OUT STD_LOGIC);
        END COMPONENT;
        --================================================================
        COMPONENT primitive_drawing
                PORT (
                        clk : IN STD_LOGIC;
                        ce : IN STD_LOGIC;
                        enable : IN STD_LOGIC;
                        x : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                        y : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                        x2 : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                        y2 : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
                        address_out : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
                        data_out : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
                        ready : OUT STD_LOGIC);
        END COMPONENT;
        --================================================================
        SIGNAL sig_glyph_index : STD_LOGIC_VECTOR(5 DOWNTO 0);
        SIGNAL sig_glyph_data : STD_LOGIC_VECTOR(39 DOWNTO 0);

        SIGNAL sig_address_vga : STD_LOGIC_VECTOR(18 DOWNTO 0);
        SIGNAL sig_data_vga : STD_LOGIC_VECTOR(0 DOWNTO 0);

        SIGNAL sig_address_out_glyph : STD_LOGIC_VECTOR(18 DOWNTO 0);
        SIGNAL sig_data_out_glyph : STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIGNAL sig_address_out_primitive : STD_LOGIC_VECTOR(18 DOWNTO 0);
        SIGNAL sig_data_out_primitive : STD_LOGIC_VECTOR(0 DOWNTO 0);

        SIGNAL ready_glyph:STD_LOGIC:='0';
        SIGNAL ready_primitive:STD_LOGIC:='0';

        SIGNAL enable_glyph:STD_LOGIC:='0';
        SIGNAL enable_primitive:STD_LOGIC:='0';
BEGIN
        --================================================================
        glyph_drawer : glyph_drawing
        PORT MAP(
                clk => clk,
                ce => ce,
                enable => enable_glyph,
                reset => reset,
                x => x,
                y => y,
                glyph_data_in => sig_glyph_data,
                address_out => sig_address_out_glyph,
                data_out => sig_data_out_glyph,
                ready => ready_glyph);
        --================================================================
        primitive_drawer : primitive_drawing
        PORT MAP(
                clk => clk,
                ce => ce,
                enable => enable_primitive,
                x => x,
                y => y,
                x2 => x2,
                y2 => y2,
                address_out => sig_address_out_primitive,
                data_out => sig_data_out_primitive,
                ready => ready_primitive);
        --================================================================
        glyph_bank : glyph_memory
        PORT MAP(
                clk => clk,
                ce => ce,
                number => x2(5 DOWNTO 0),
                data_out => sig_glyph_data);

        --================================================================
process(mode,ready_glyph,ready_primitive,enable,sig_data_out_glyph,sig_address_out_glyph,sig_address_out_primitive,sig_data_out_primitive) is
    begin
        case( mode ) is
                when '1' =>
                address_out<= sig_address_out_glyph;
                data_out <=sig_data_out_glyph;
                ready<=ready_glyph;
                enable_primitive<='0';
                enable_glyph<=enable;
                when '0' =>
                address_out<= sig_address_out_primitive;
                data_out <=sig_data_out_primitive;
                ready<=ready_primitive;
                enable_primitive<=enable;
                enable_glyph<='0';
                when others => 
                address_out<= "0000000000000000000";
                data_out <="0";
                enable_primitive<='0';
                enable_glyph<='0';
        end case ;
 end process;

 


END Behavioral;