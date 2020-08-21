--- This is a D-type flip flop ---
------ it is used to detect ------
----- rising edge of signals -----

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity edge_detector is
port (
  clk                         : in  std_logic;
  i_pulse                     : in  std_logic;
  o_pulse                     : out std_logic);
end edge_detector;
architecture flipflop of edge_detector is

signal a                           : std_logic := '0';
signal b                           : std_logic := '0';
begin
RisingEdgeProc : process(clk)
begin
  if(rising_edge(clk)) then
    a           <= i_pulse;
    b           <= a;
  end if;
end process RisingEdgeProc;
o_pulse            <= (not b) and a;
end flipflop;