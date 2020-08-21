---- This is a N-bit sequential divider ----
---- divides two positive integers with ----
---- equal number of bits sequentially -----
----- in clock cycles = number of bits -----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
	generic(N: integer := 28);
    port ( Dividend : in std_logic_vector(N-1 downto 0) := (others => '0');
           Divisor : in std_logic_vector(N-1 downto 0) := (others => '0');
           Start :   in std_logic := '0';
           Clk :     in std_logic;
           Quotient :  out std_logic_vector(N-1 downto 0);
           Remainder :    out std_logic_vector(N-1 downto 0);
           Done : out std_logic);
end divider;

architecture Behavioral of divider is
   signal Q:     std_logic_vector(N*2-1 downto 0) := (others => '0');
   signal Diff:  std_logic_vector(N downto 0) := (others => '0');
   signal Count: integer range 0 to N+1;
begin
   Diff <= ('0'&Q(N*2-2 downto N-1)) - ('0'&Divisor);
   
	process(Clk, Start)
	begin
      if Start = '0' then
		   Q <= conv_std_logic_vector(0,N) & Dividend;
		elsif Rising_edge( Clk) then
		   if Count<N then
		      if Diff(N)='1' then
               Q <= Q(N*2-2 downto 0) & '0';
			   else
			      Q <= Diff(N-1 downto 0) & Q(N-2 downto 0) & '1';
				end if;
			end if;
		end if;
	end process;

   process(Clk)
	begin
	   if Start = '0' then
		   Count <= 0;
		elsif Rising_edge(Clk) then
		   if Count<N then
			   Count <= Count+1;
			end if;
		end if;
	end process;

   Quotient <= Q(N-1 downto 0);
	Remainder   <= Q(N*2-1 downto N);
	
	Done <= '1' when Count=N else '0';
end Behavioral;
