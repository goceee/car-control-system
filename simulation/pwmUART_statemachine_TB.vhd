LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY tbU IS
END tbU;
ARCHITECTURE behavior OF tbU IS 
   --Inputs
   signal rxData_option: std_logic_vector(7 downto 0) := (others => '0');
   signal pwm_DC : std_logic;
   signal pwm_SERVO : std_logic;
   signal clk : std_logic := '0';
   -- Clock period definitions
   constant clk_period : time := 20 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: entity work.top
		 port map(
		 clk => clk,
		 rxData_percentage => rxData_option,
		 pwm_out1 => pwm_DC,
		 pwm_out2 => pwm_SERVO
		 );
   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin
	wait for 3 ms;
	rxData_option <= X"73";
	wait for 5 ms;
	rxData_option <= X"14";
	wait for 25 ms;
	rxData_option <= X"61";
	wait for 5 ms;
	rxData_option <= X"C8";
	wait for 10 ms;
	rxData_option <= X"12";
	wait for 5 ms;
	rxData_option <= X"61";
	wait for 5 ms;
	rxData_option <= X"32";
	wait for 10 ms;
	rxData_option <= X"71";
	wait for 7 ms;
	rxData_option <= X"99";
	wait;
   end process;
END;
