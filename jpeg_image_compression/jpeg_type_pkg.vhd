----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2025 02:18:41 PM
-- Design Name: 
-- Module Name: jpeg_type_pkg - rtl
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package jpeg_type_pkg is
    subtype coeff_t is signed(15 downto 0);
    type block8x8 is array (0 to 7, 0 to 7) of coeff_t;
    type block64 is array (0 to 63) of coeff_t;
    
    type dc_code_type is record 
        code   : std_logic_vector(8 downto 0);
        length : integer range 0 to 9;
    end record;

end package;