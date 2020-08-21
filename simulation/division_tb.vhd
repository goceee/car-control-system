library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;

entity divider_tb is     
end divider_tb;

architecture Behavioral of divider_tb is

constant CLK_PERIOD : time := 20 ns;

component divider is
    generic(N: integer := 9);
    port ( Dividend : in std_logic_vector(N-1 downto 0);
           Divisor : in std_logic_vector(N-1 downto 0);
           Start :   in std_logic;
           Clk :     in std_logic;
           Quotient :  out std_logic_vector(N-1 downto 0);
           Remainder :    out std_logic_vector(N-1 downto 0);
           Done : out std_logic);
	end component;
constant nBitsT : integer := 9;
signal Dividend 	: std_logic_vector(nBitsT-1 downto 0);
signal Divisor 		: std_logic_vector(nBitsT-1 downto 0);
signal Start 		: std_logic := '0';
signal Clk 			: std_logic;
signal Quotient 	: std_logic_vector(nBitsT-1 downto 0);
signal Remainder 	: std_logic_vector(nBitsT-1 downto 0);
signal Done 		: std_logic;

Begin

Division : divider -- component instantiation
   generic map (N => nBitsT)
   port map(
      Dividend => Dividend, -- signal mappings
      Divisor => Divisor,
      Start => Start,
      Clk => Clk,
      Quotient => Quotient,
	  Remainder => Remainder,
	  Done => Done);
	  
clk_generation : process
begin
Clk <= '1';
wait for CLK_PERIOD/2;
Clk <= '0';
wait for CLK_PERIOD/2;
end process clk_generation;

simulation : process
begin
Dividend <= "110011100";
Divisor  <= "000101001";
wait for 20 ms;
Start <= '1';
if (Done = '1') then
Start <= '0';
end if;
end process;



end architecture Behavioral;