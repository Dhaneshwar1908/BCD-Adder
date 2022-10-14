# Somador BCD8421

>Colaboradores: Heloisa Alves ([Github Profile](https://github.com/Helogizzy)), Ellen Bonafin ([GitHub Profile](https://github.com/EllenBonafin)) e Gabriel Mazzuco ([Github Profile](https://github.com/gabrielmazz))

## Descrição do Problema
Implementação de um somador BCD8421 para palavras com 4 dígitos (16 bits).

## Sistema Geral
Entradas:
- A: um vetor de 4 bits que representa o primeiro dígito a ser somado.
- B: um vetor de 4 bits que representa o segundo dígito a ser somado.
- Carry In (Cin): um bit que indica se a soma anterior causou overflow.

Saídas:
- S: um vetor de 4 bits que representa o resultado da soma.
- Carry Out (Cout): um bit que indica se a soma causou um overflow.

![img1](./folder/img1.PNG)


## Código Fadder
O Fadder é o somador, ele está dividi o em dois módulos:

### Módulo somador de 1 bit.
É realizado a soma das entradas A, B e o Carry de entrada. Ele resulta a saída S (que é o resultado da soma), caso estoure o tamanho vai resultar saída para o Cout. Utiliza-se as expressões retiradas das tabelas de Karnaugh.

### Módulo somador de 4 bits.
Apenas as conexões com os fios.

## Código BCDadder
As saídas S e Cout irão receber o sinal do fadder 1 quando o sinal de exceder  for zero, senão vai receber o sinal de fadder 2, como mostra a figura.

Onde, o quadrado fadder4 a esquerda representa o Fadder 1, e o quadro fadder4 ajuste a direita representa o Fadder 2.

![img2](./folder/img2.PNG)

Essa parte do código (linha 27) já pré-supõe que temos os resultados do Fadder 1, pois como o VHDL executa em paralelo e tudo está ocorrendo ao mesmo tempo não há ordem para os testes.

```
begin
    -- Seletores
    S    <= sinal_s_fadder_1   when sinal_excede = '0' else sinal_s_fadder_2;
    Cout <= sinal_cout_fadder_1 when sinal_excede = '0' else '1';
```

Foi feita uma mini tabela de Van Karnaugh para a representação dos números em binário.

0 -> 0000

1 -> 0001

2 -> 0010

3 -> 0011

4 -> 0100

5 -> 0101

6 -> 0110

7 -> 0111

8 -> 1000

9 -> 1001

10 -> 1010

Note que a maioria dos números possuem o primeiro dígito igual a zero, com exceção do 8 e 9. Por isso, basta apenas verificar se há um número 1 no último dígito para confirmar.

A expressão NOT na frente do sinal significa que ele é zero (linha 33).

```
    -- Parte da verificação se 8 ou se 9

    candidato_a_oito <= (not sinal_s_fadder_1(2)) and ((not sinal_s_fadder_1(1)) and (not sinal_s_fadder_1(0)));

    candidato_a_nove <= (not sinal_s_fadder_1(2)) and ((not sinal_s_fadder_1(1)) and sinal_s_fadder_1(0));
```

O seguinte teste (linha 37) verifica todos os números que começam com 1, com excessão do 8 e 9. É analisado se excede 9, se exceder vai emitir o valor 1.

```
 --  Verifica se o resultado de fadder_1 excede 9

    sinal_excede <= sinal_cout_fadder_1 or (sinal_s_fadder_1(3) and (not (candidato_a_oito or candidato_a_nove)));
```

Cada fadder vai retornar um número de 0 a 9 em decimal. Ao invés de representar apenas um dígito será apresentado 4, como mostra a figura a seguir:

![img3](./folder/img3.PNG)

A partir da linha 72 temos a expansão para 4 dígitos:

```
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
```

## Código Teste Bench (TB_BCDadder)
Aqui é atribuído os valores de teste e realizada a soma dos números (linha 26).

A letra X é um indicador para o núemro hexadecimal.

```
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
```
