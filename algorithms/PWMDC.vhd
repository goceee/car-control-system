---- This is the PWM generation module -----
-- it generates a PWM signal that depends --
------ on a variable duty cycle value ------

-- For a 50MHz clock the refresh rate of 16ms is 800000 --
------ 1ms is 50000, 1.5ms is 75000, 2ms is 100000 -------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pwm is
port 
(
	clk			: in std_logic;
	pwm_out 	: out std_logic;
	duty_cycle  : in integer range 0 to 200000
);

end entity;

architecture pwm_generator of pwm is

begin
Motor:	process (clk)
	variable count1 : integer range 0 to 799999;
	begin
		if (rising_edge(clk)) then
			count1:= count1+1;

			if (std_logic_vector(to_unsigned(count1, 20)) = duty_cycle) then -- when duty cycle value is reached set output to low
				pwm_out <= '0';
			end if;

			if (count1 = 799999) then -- the refresh rate, max time is reached generate another PWM signal 
				pwm_out <= '1';
				count1:= 0;
			end if;	
		end if;
	end process;

end pwm_generator;