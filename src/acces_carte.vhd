LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY acces_carte IS
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

END acces_carte;

ARCHITECTURE acces_carte_a OF acces_carte IS

	SIGNAL AdrMSB_4bits : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ssegAdrLSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL ssegAdrMSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL ssegDataInMemLSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL ssegDataInMemMSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL ssegDataLSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL ssegDataMSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL commande_mux8_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL ce195k : STD_LOGIC;

	CONSTANT tiret : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0111111";
	COMPONENT Bin27s IS
		PORT (
			BIN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			SevenS : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;

	COMPONENT mux8_1 IS
		PORT (
			E1 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E2 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E3 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E4 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E5 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E6 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			E8 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			COMMANDE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT modulo8
		PORT (
			clk : IN STD_LOGIC;
			raz : IN STD_LOGIC;
			ce : IN STD_LOGIC;
			sortie : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			parallel : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT gen_ce IS
		PORT (
			H : IN STD_LOGIC;
			raz : IN STD_LOGIC;
			S_8 : OUT STD_LOGIC;
			S_1 : OUT STD_LOGIC;
			S_25 : OUT STD_LOGIC);
	END COMPONENT;
BEGIN

	AdrMSB_4bits <= "00" & AdrMSB;

	i_Bin27s_AdrLSB : Bin27s PORT MAP(AdrLSB, ssegAdrLSB);
	i_Bin27s_AdrMSB : Bin27s PORT MAP(AdrMSB_4bits, ssegAdrMSB);
	i_Bin27s_DataInMemLSB : Bin27s PORT MAP(DataInMem(3 DOWNTO 0), ssegDataInMemLSB);
	i_Bin27s_DataInMemMSB : Bin27s PORT MAP(DataInMem(7 DOWNTO 4), ssegDataInMemMSB);
	i_Bin27s_DataLSB : Bin27s PORT MAP(DataLSB, ssegDataLSB);
	i_Bin27s_DataMSB : Bin27s PORT MAP(DataMSB, ssegDataMSB);
	--i_mux4_1 : mux4_1 port map(ssegDataMSB,ssegDataLSB,ssegAdrMSB,ssegAdrLSB,commande_mux4_1,Sseg);
	--i_mux4_1 : mux4_1 port map(ssegDataMSB,ssegDataLSB,ssegDataInMemMSB,ssegDataInMemLSB,commande_mux4_1,Sseg);
	i_mux8_1 : mux8_1 PORT MAP(tiret, ssegAdrMSB, ssegAdrLSB, tiret, ssegDataInMemMSB, ssegDataInMemLSB, ssegDataMSB, ssegDataLSB, commande_mux8_1, Sseg);
	i_modulo8 : modulo8 PORT MAP(clk, reset, ce195k, commande_mux8_1, AN);
	i_gen_ce : gen_ce PORT MAP(clk, reset, cemodif, ce25M, ce1s);

	--LED <= not DataInMem(7) & not DataInMem(6) & not DataInMem(5) & not DataInMem(4) & not DataInMem(3) & not DataInMem(2) & not DataInMem(1) & not DataInMem(0);
	--LED <= DataInMem;
	--LED <= AdrMSB_4bits&AdrLSB;
	LED <= DataMSB & DataLSB;
	LEDg <= '1';
END acces_carte_a;

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Bin27s IS
	PORT (
		BIN : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		SevenS : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END Bin27s;

ARCHITECTURE Behavioral OF Bin27s IS

	-- Sseg:  (dp)(g f e d c b a)
BEGIN
	WITH BIN SELECT
		SevenS <= "1111001" WHEN "0001", --1 	
		"0100100" WHEN "0010", --2
		"0110000" WHEN "0011", --3
		"0011001" WHEN "0100", --4
		"0010010" WHEN "0101", --5
		"0000010" WHEN "0110", --6
		"1111000" WHEN "0111", --7
		"0000000" WHEN "1000", --8
		"0010000" WHEN "1001", --9
		"0001000" WHEN "1010", --A
		"0000011" WHEN "1011", --b
		"1000110" WHEN "1100", --C
		"0100001" WHEN "1101", --d
		"0000110" WHEN "1110", --E
		"0001110" WHEN "1111", --F
		"1000000" WHEN OTHERS; --0

END Behavioral;

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux8_1 IS
	PORT (
		E1 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E2 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E3 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E4 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E5 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E6 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		E8 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		COMMANDE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));

END mux8_1;

ARCHITECTURE a_mux8_1 OF mux8_1 IS
BEGIN
	PROCESS (E1, E2, E3, E4, E5, E6, E7, E8, COMMANDE)

	BEGIN
		CASE COMMANDE IS
			WHEN "000" => S <= '1' & E1;
			WHEN "001" => S <= '1' & E2;
			WHEN "010" => S <= '1' & E3;
			WHEN "011" => S <= '1' & E4;
			WHEN "100" => S <= '1' & E5;
			WHEN "101" => S <= '0' & E6;
			WHEN "110" => S <= '1' & E7;
			WHEN OTHERS => S <= '0' & E8;
		END CASE;

	END PROCESS;
END a_mux8_1;

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY modulo8 IS
	PORT (
		clk : IN STD_LOGIC;
		raz : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		sortie : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		parallel : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END modulo8;
ARCHITECTURE modulo8_a OF modulo8 IS

	SIGNAL cpt_val : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN -- compteur_a

	mod8 : PROCESS (clk)

	BEGIN -- process cpt

		IF clk'event AND clk = '1' THEN

			IF raz = '1' THEN
				cpt_val <= "000";

			ELSIF ce = '1' THEN
				IF cpt_val = "111" THEN
					cpt_val <= "000";
				ELSE
					cpt_val <= cpt_val + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS mod8;

	sortie <= cpt_val;

	parallel_p : PROCESS (cpt_val)
	BEGIN
		CASE cpt_val IS
			WHEN "000" => parallel <= "11111110";
			WHEN "001" => parallel <= "11111101";
			WHEN "010" => parallel <= "11111011";
			WHEN "011" => parallel <= "11110111";
			WHEN "100" => parallel <= "11101111";
			WHEN "101" => parallel <= "11011111";
			WHEN "110" => parallel <= "10111111";
			WHEN OTHERS => parallel <= "01111111";
		END CASE;

	END PROCESS parallel_p;

END modulo8_a;

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY gen_ce IS
	PORT (
		H : IN STD_LOGIC;
		raz : IN STD_LOGIC;
		S_8 : OUT STD_LOGIC;
		S_1 : OUT STD_LOGIC;
		S_25 : OUT STD_LOGIC);
END gen_ce;

ARCHITECTURE Behavioral OF gen_ce IS
	SIGNAL compt : STD_LOGIC_VECTOR (25 DOWNTO 0);
BEGIN
	P1 : PROCESS (H, raz)
	BEGIN
		IF raz = '1' THEN
			compt <= (OTHERS => '0');
		ELSIF H = '1' AND H'event THEN
			compt <= compt + 1;
		END IF;
	END PROCESS;

	P2 : PROCESS (compt)
	BEGIN--10hz
		IF (compt(6 DOWNTO 0) = "1000000") THEN
			S_8 <= '1';
		ELSE
			S_8 <= '0';
		END IF;
		IF (compt(0) = '1') THEN
			S_1 <= '1';
		ELSE
			S_1 <= '0';
		END IF;
		IF (compt = ((2 ** 25) - 1)) THEN
			S_25 <= '1';
		ELSE
			S_25 <= '0';
		END IF;
	END PROCESS;

END Behavioral;