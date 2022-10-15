-- Testing Beach dos somadores

library ieee;
use ieee.std_logic_1164.all;

entity tb_bcdadder is
    -- Entidade vazia
end entity;

architecture tb_bcdadder_arch of tb_bcdadder is -- Declaração da arquitetura usando os componentes do BCDADDER de 4 BITS
    component bcdadder4 is
		port(
	        A, B : in  std_logic_vector (15 downto 0);    -- Declaração de A e B
	        Cin  : in  std_logic;                         -- Transporte de entrada
	        S    : out std_logic_vector (15 downto 0);    -- Saída
            Cout : out std_logic                          -- Transporte de saída
        );
    end component;
    signal sinal_a, sinal_b, sinal_s : std_logic_vector (15 downto 0); -- Declaração dos sinais de entradas que serão mostrados no GTK
    signal sinal_cin, sinal_cout : std_logic;                          -- Declaração dos sinais de saída que serão mostrados no GTK
begin
    bcdadder : bcdadder4
    port map(sinal_a, sinal_b, sinal_cin, sinal_s, sinal_cout);

    -- Os testes que serão calculados 
    process begin 
        sinal_a   <= x"0404"; --Primeiro teste
        sinal_b   <= x"0328";
        sinal_cin <= '0';
        wait for 10 ns;

        sinal_a   <= x"9998"; --Segundo teste
        sinal_b   <= x"0004";
        sinal_cin <= '0';
        wait for 10 ns;

        sinal_a   <= x"0404"; --Terceiro teste
        sinal_b   <= x"0328";
        sinal_cin <= '0';
        wait for 10 ns;

        sinal_a   <= x"0815"; --Quarta teste
        sinal_b   <= x"0899";
        sinal_cin <= '0';
        wait for 10 ns; 

        wait;
    end process;
end architecture;