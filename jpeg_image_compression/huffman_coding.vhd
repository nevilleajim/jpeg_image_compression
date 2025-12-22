----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2025 02:13:07 PM
-- Design Name: 
-- Module Name: huffman_coding - rtl
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
use work.jpeg_type_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity huffman_coding is
  Port (
    clk          : in std_logic;
    reset        : in std_logic;
    start        : in std_logic;
    block_in     : in block64;
    last_dc      : in integer;
    stream_out   : out std_logic_vector(255 downto 0);
    coeff_valid  : out std_logic;
    done         : out std_logic
   );
end huffman_coding;

architecture rtl of huffman_coding is

    signal dc_diff      : integer;
    signal dc_cat       : integer;
    signal dc_bits      : std_logic_vector(8 downto 0);
    signal ac_run       : integer;
    signal ac_cat       : integer;
    signal ac_bits      : std_logic_vector(15 downto 0);

begin
    
    dc_process : process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                stream_out  <= (others => '0');
                coeff_valid <= '0';
                done        <= '0';
            elsif start = '1' then
                dc_diff  <= to_integer(block_in(0)) - last_dc;
                dc_cat  <= category(dc_diff);
                dc_bits <= DC_LUMA_HUFF(dc_cat).code & value_bits(dc_diff, dc_cat);
                stream_out(255 downto 255-dc_bits'length+1) <= dc_bits;
                coeff_valid <= '1';
            end if;
        end if;
    end process;

end rtl;
