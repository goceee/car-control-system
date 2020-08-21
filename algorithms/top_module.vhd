---- This is the final control module  ----
--- it uses all the sensors outputs and ---
----- controls the motors accordingly -----

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.all;


entity top is
port(
	clk 		: in std_logic; -- replace with sysclk when programming the FPGA to use 50MHz clock
	rx          : in  std_logic;
	pwm_DC      : out std_logic;
	pwm_SERVO   : out std_logic;
	pulse_I		: in  std_logic;
	trig  		: out std_logic;
	echo  		: in  std_logic;
	trig2 		: out std_logic;
	echo2  		: in  std_logic
);
end entity;

architecture Behavioral of top is
--Clock
-- signal clk : std_logic; -for FPGA programming with 50MHz clock

--FSM 
type stateType is (idle, incSpeed, waitCommand, turn, emStop, goBack, stopSlowly);
signal nextState : stateType := idle;

--ULTRASONIC DISTANCE Signal
signal distS : std_logic_vector(23 downto 0);
signal distS2 : std_logic_vector(23 downto 0);
signal distance : integer range 0 to 6000000;
signal distance2 : integer range 0 to 6000000;

--DUTY CYCLE - 1ms = 50000, 1.5ms = 75000, 2ms = 100000
signal duty_cycle1  :  integer range 0 to 200000;
signal duty_cycle2  :  integer range 0 to 200000;
signal duty_cycle3  :  integer range 0 to 200000;

--SPEED signals
signal getSpeedData    			 : std_logic_vector(7 downto 0);
signal speed 						 : integer range 0 to 3000;

--UART Signals
signal rxDataValid     : std_logic;
signal rxData   		 : std_logic_vector(7 downto 0);


--Timers for speed delay
signal timer1, timer2 : integer range 0 to 50000000;
  
Begin

	-- clockman : entity work.clk_wiz_0 --50Mhz clock for FPGA programming
	 -- port map(
	 -- clk_out1 => clk,
	 -- -- Status and control signals
	 -- reset => '0',
	 -- locked => open,
	 -- -- Clock in ports
	 -- clk_in1 => sysclk
	 -- ); 

	PWM_DCM : entity work.pwm
	 port map(
	 clk => clk,
	 pwm_out => pwm_DC,
	 duty_cycle => duty_cycle1
	 );
	PWM_SERVOM : entity work.pwm
	 port map (
	 clk => clk,
	 pwm_out => pwm_SERVO,
	 duty_cycle => duty_cycle2
	 );

	UART_RX_Inst : entity work.UART_RX
	 generic map (
	 delay => 5208)            -- 50,000,000 / 9,600
	 port map (
	 clk => clk,
	 I_rx => rx,
	 O_rxDataValid => rxDataValid,
	 O_rxData => rxData
	 );
	 
	Ultra: entity work.ultrasonic
	port map(
	clk => clk,
	trig => trig,
	echo => echo,
	dist => distS
	);
	
	Ultra2: entity work.ultrasonic
	port map(
	clk => clk,
	trig => trig2,
	echo => echo2,
	dist => distS2
	);
	 
	 SpeedCalc: entity work.speed_calc
	 port map(
	 clk	 => clk,
	 speed 	 => speed,
	 pulse_I => pulse_I
	 );
	
	
	---HEX VALUES USED IN ASCII---
		---X"73" = s
		---X"71" = q
		---X"61" = a
	------------------------------
	
Command : process(clk)
variable counterr : integer range 0 to 36000000;

begin
  if rising_edge(clk) then
  distance <= to_integer(unsigned(distS(23 downto 0)));
  distance2 <= to_integer(unsigned(distS2(23 downto 0)));
  case nextState is
  
  when idle => -- set initial values for both motors
  duty_cycle1 <= 75000;
  duty_cycle2 <= 75000;
  nextState <= waitCommand;
  
  
  when waitCommand =>
  if (distance < 80000 or distance2 < 80000) then -- if distance is less than 24cm stop the car
  nextState <= emStop;
  elsif (distance < 320000 or distance2 < 320000) then -- if distance is less than 96cm start slowing down
	  nextState <= stopSlowly;
  elsif ((distance > 320000 or distance2 > 320000) and duty_cycle1 < duty_cycle3 and duty_cycle1 > 76250) then -- if no obstructions return to original speed
	  duty_cycle1 <= duty_cycle3;
	  nextState <= waitCommand;
  else
  if(rxDataValid = '1') then
  if (rxData = X"73") then -- if command is 's'
  nextState <= incSpeed;
  elsif (rxData = X"71") then -- if command is 'q'
  nextState <= idle;
  elsif (rxData = X"61") then -- if command is 'a'
  nextState <= turn;
  else
  nextState <= waitCommand;
  end if;
  end if;
  end if;
  
   when stopSlowly =>
	  if ((distance > 80000 or distance2 > 80000) and duty_cycle1 >= 75900) then
		if (counterr = 5000000) then -- delay of 1 second when reducing speed
		counterr := 0;
		duty_cycle1 <= duty_cycle1 - 250; --- reduce by 1% duty cycle each second
		nextState <= waitCommand;
		else
		counterr := counterr + 1;
		nextState <= stopSlowly;
		end if;
	  else
	  nextState <= waitCommand;
	  end if;
  
  
  when incSpeed => -- get up to desired speed
  if (rxDataValid = '1' and rxData /= X"73") then
	getSpeedData <= rxData;
	if (rxData = X"61") then
	nextState <= turn;
	else
		if (getSpeedData > speed and duty_cycle1 < 85000) then
			if (timer1 = 23000000) then
				duty_cycle1 <= duty_cycle1 + 75;				-- add 0.1% every 0.4s
				nextState <= incSpeed;
			else
				timer1 <= timer1 + 1;
				nextState <= incSpeed;
			end if;
		elsif (duty_cycle1 >= 85000) then -- if maximum use maximum
			duty_cycle1 <= 85000;
			nextState <= waitCommand;
		elsif (getSpeedData < speed and duty_cycle1 > 75000) then
			if (timer2 = 23000000) then
				duty_cycle1 <= duty_cycle1 - 75; -- decrease 0.1% every 0.4s
				nextState <= incSpeed;
			else
				timer2 <= timer2 + 1;
				nextState <= incSpeed;
			end if;
		elsif (duty_cycle1 <= 75000) then --- if stopped, stop
			duty_cycle1 <= 75000;
			nextState <= waitCommand;
		elsif (getSpeedData+10 > speed and getSpeedData-10 < speed) then -- if within range keep value
				duty_cycle1 <= duty_cycle1;
				nextState <= waitCommand;
		else
				duty_cycle1 <= duty_cycle1;
				nextState <= incSpeed;
		end if;
	end if;
 else
	nextState <= incSpeed;
end if;
			
  when turn => -- turn , use 0 for max left, 100 for center, 200 for max right or all values in between respectively
  if (rxDataValid = '1' and rxData /= X"61") then
  duty_cycle2 <= 50000 + (to_integer(unsigned(rxData(7 downto 0)))*250);
  nextState <= waitCommand;
  else
  nextState <= turn;
  end if;
  
   when emStop => -- stop the car, since it is an emergency stop go back to get some distance for the object avoidance
   duty_cycle1 <= 75000;
   duty_cycle2 <= 75000;
   if (counterr = 125000000) then
   counterr := 0;
   nextState <= goBack;
   else
   counterr := counterr + 1;
   nextState <= emStop;
   end if;
  
  when goBack => -- go back, if speed is 0, increase the duty cycle to the slowest speed value
  duty_cycle1 <= 75000 + (-8*250);
  if (speed = 0) then
  duty_cycle1 <= 75000 + (-9*250);
  end if;
  if (distance < 80000 or distance2 < 80000) then -- until there is enough distance from the object go back
  nextState <= goBack;
  else
  nextState <= idle;
  end if;
	  
  when others =>
  nextState <= idle;
  
  
  end case;
  end if;
	end process;
	  --------------------------------------------
	  
end Behavioral;