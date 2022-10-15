-- BCDADDER -> somador decimal de 1 dígito

library ieee;
use ieee.std_logic_1164.all;

entity bcdadder is -- Declaração do BCDADDER DE 1 dígito
	port(
		A, B : in  std_logic_vector (3 downto 0);  -- Declaração de A, B
		Cin  : in  std_logic;                      -- Transporte de entrada
		S    : out std_logic_vector (3 downto 0);  -- Saída
        Cout : out std_logic                       -- Transporte de saída
	);
end entity;

architecture bcdadder_arch of bcdadder is
    component fadder is
        port(
		    A, B : in  std_logic_vector (3 downto 0);     -- Declaração de A, B
		    Cin  : in  std_logic;                         -- Transporte de entrada
		    S    : out std_logic_vector (3 downto 0);     -- Saída
            Cout : out std_logic                          -- Transporte de saída
	    );
    end component;

    signal sinal_s_fadder_1, sinal_s_fadder_2 : std_logic_vector (3 downto 0);                                      -- Declaração de entrada
    signal sinal_excede, sinal_cout_fadder_1, sinal_cout_fadder_2, candidato_a_oito, candidato_a_nove : std_logic;  -- Declaração de saída
begin
    -- Seletores
    S    <= sinal_s_fadder_1   when sinal_excede = '0' else sinal_s_fadder_2;
    Cout <= sinal_cout_fadder_1 when sinal_excede = '0' else '1';

    -- Parte da verificação se 8 ou se 9
    candidato_a_oito <= (not sinal_s_fadder_1(2)) and ((not sinal_s_fadder_1(1)) and (not sinal_s_fadder_1(0)));
    candidato_a_nove <= (not sinal_s_fadder_1(2)) and ((not sinal_s_fadder_1(1)) and sinal_s_fadder_1(0));

    --  Verifica se o resultado de fadder_1 excede 9
    sinal_excede <= sinal_cout_fadder_1 or (sinal_s_fadder_1(3) and (not (candidato_a_oito or candidato_a_nove)));

    -- Conexão com os somadores
    fadder_1 : fadder
    port map(A, B, Cin, sinal_s_fadder_1, sinal_cout_fadder_1);

    fadder_2 : fadder
    port map("0110", sinal_s_fadder_1, '0', sinal_s_fadder_2, sinal_cout_fadder_2);
end architecture;

-- BCDADDER -> somador decimal de 4 dígitos

library ieee;
use ieee.std_logic_1164.all;

entity bcdadder4 is -- Declaração do BCDADDER DE 4 dígito
	port(
		A, B : in  std_logic_vector (15 downto 0);  -- Declaração de A, B
		Cin  : in  std_logic;                       -- Transporte de entrada
        S    : out std_logic_vector (15 downto 0);  -- Saída
        Cout : out std_logic                        -- Transporte de saída
	);
end entity;

architecture bcdadder4_arch of bcdadder4 is
    component bcdadder is
        port(
		    A, B : in  std_logic_vector (3 downto 0);  -- Declaração de A, B
		    Cin  : in  std_logic;                      -- Transporte de entrada
		    S    : out std_logic_vector (3 downto 0);  -- Saída
            Cout : out std_logic                       -- Transporte de saída
	    );
    end component;

    signal carry : std_logic_vector (2 downto 0);
begin
    bcdadder0 : bcdadder
    port map(A(3 downto 0), B(3 downto 0), Cin, S(3 downto 0), carry(0));

    bcdadder1 : bcdadder
    port map(A(7 downto 4), B(7 downto 4), carry(0), S(7 downto 4), carry(1));

    bcdadder2 : bcdadder
    port map(A(11 downto 8), B(11 downto 8), carry(1), S(11 downto 8), carry(2));

    bcdadder3 : bcdadder
    port map(A(15 downto 12), B(15 downto 12), carry(2), S(15 downto 12), Cout);
end architecture;