------ This is the speed calculation module ------
-- as the name suggests it calculates the speed --

-- speed = m/m == meters per minute
-- radius of wheel 6cm to m = 0.06
-- circumference of wheel = 0.06 * 2 * pi
-- speed = circumference of wheel * RPM
-- speed = all values except the period are constant = constant / period

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity speed_calc is
port 
(
	clk			: in std_logic;
	speed 		: out integer range 0 to 3000;
	pulse_I 	: in std_logic);
end entity;

architecture measure_speed of speed_calc is
constant nBits3 : integer := 28;
signal period	    : integer range 0 to 2000000000;


---DIVIDER SIGNALS
constant Dividend 	: std_logic_vector(nBits3-1 downto 0) := "1000011011000001000100100000"; -- = 141 300 000
signal Divisor 		: std_logic_vector(nBits3-1 downto 0) := (others => '0');
signal Start 		: std_logic := '0';
signal Quotient 	: std_logic_vector(nBits3-1 downto 0) := (others => '0');
signal Remainder 	: std_logic_vector(nBits3-1 downto 0) := (others => '0');
signal Done 		: std_logic;

begin

PeriodMeasurement : entity work.pulseM
	port map(
		DAT_O => period,
        Pulse_I => pulse_I,
		clk => clk);
		
DividingforSpeed : entity work.divider 
   generic map (N => nBits3)
   port map(
		Dividend => Dividend,
		Divisor => Divisor,
		Start => Start,
		clk => clk,
		Quotient => Quotient,
		Remainder => Remainder,
		Done => Done);
		
SpeedGauge:	process (clk)
	begin
	if rising_edge(clk) then
		if (period > 0) then -- if period is measured, calculate the speed in m/m
				Divisor <= std_logic_vector(to_unsigned(period,Divisor'length));
			if (Divisor = std_logic_vector(to_unsigned(period,Divisor'length))) then
				Start <= '1';
			elsif (Done = '1') then
				Start <= '0';
			end if;
		else
			Start <= '0';
			speed <= 0;
		end if;
		if (Done = '1') then
		speed <= to_integer(unsigned(Quotient));
		end if;
		
	end if;
end process;
end measure_speed;