--Somador de 1 BIT
library ieee;
use ieee.std_logic_1164.all;

entity adder is -- Declaração do somador de 1 BITS
	port(
		A, B : in  std_logic;  -- Declaração de A, B
		Cin  : in  std_logic;  -- Transporte de entrada
		S    : out std_logic;  -- Saída
		Cout : out std_logic   -- Transporte de saída
	);
end entity;

architecture adder_arch of adder is --Somador
begin
	S    <= Cin xor (B xor A);
	Cout <= (A and B) or (Cin and (A or B));
end architecture;

--Somador de 4 BITS
library ieee;
use ieee.std_logic_1164.all;

entity fadder is -- Declaração do somador de 4 BITS
	port(
		A, B : in  std_logic_vector (3 downto 0);  -- Declaração de A, B
		Cin  : in  std_logic;                      -- Transporte de entrada
		S    : out std_logic_vector (3 downto 0);  -- Saída
		Cout : out std_logic                       -- Transporte de saída
	);
end entity;

architecture fadder_arch of fadder is --Declaração dos sinais do somador
    component adder is
        port(
		    A, B : in  std_logic;  -- Declaração de A, B
		    Cin  : in  std_logic;  -- Transporte de entradaa
		    S    : out std_logic;   -- Saída
			Cout : out std_logic   -- Transporte de saída
	    );
    end component;

    signal carry : std_logic_vector (2 downto 0);  
begin
	adder0 : adder                                 
    port map(A(0), B(0), Cin, S(0), carry(0));     

    adder1 : adder
    port map(A(1), B(1), carry(0), S(1), carry(1));

    adder2 : adder
    port map(A(2), B(2), carry(1), S(2), carry(2));

    adder3 : adder
    port map(A(3), B(3), carry(2), S(3), Cout);     
end architecture;