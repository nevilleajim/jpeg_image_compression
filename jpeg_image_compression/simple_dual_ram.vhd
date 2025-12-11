----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2025 06:47:42 PM
-- Design Name: 
-- Module Name: simple_dual_ram - rtl
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

entity simple_dual_ram is
  generic (
    DATA_WIDTH : integer := 8;
    ADDR_WIDTH : integer := 10
  );
  Port (
    clk     : in std_logic;
    
    write_a : in std_logic;
    addr_a  : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    din_a   : in std_logic_vector(DATA_WIDTH-1 downto 0);
    
    addr_b  : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    dout_b  : out std_logic_vector(DATA_WIDTH-1 downto 0)  
   );
end simple_dual_ram;

architecture rtl of simple_dual_ram is

    type ram_type is array (0 to (2**ADDR_WIDTH) - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    
    signal ram : ram_type := (others => (others => '0'));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if write_a = '1' then
                ram(to_integer(unsigned(addr_a))) <= din_a;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            dout_b <= ram(to_integer(unsigned(addr_b)));
        end if;
    end process;

end rtl;
