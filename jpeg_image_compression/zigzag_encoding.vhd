----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2025 01:46:12 PM
-- Design Name: 
-- Module Name: zigzag_encoding - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zigzag_encoding is
  Port (
    clk     : in std_logic;
    reset   : in std_logic;
    quant_block  : in std_logic_vector(63 downto 0);
    
    zigzag_out   : out std_logic_vector(63 downto 0)
    
   );
end zigzag_encoding;

architecture rtl of zigzag_encoding is

begin


end rtl;
