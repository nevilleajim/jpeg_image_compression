----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/21/2025 12:30:55 PM
-- Design Name: 
-- Module Name: rgb_to_ycbcr_converter - rtl
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

entity rgb_to_ycbcr_converter is
  Port (
    clk     : in std_logic;
    reset   : in std_logic;
    R       : in std_logic_vector(7 downto 0);
    G       : in std_logic_vector(7 downto 0);
    B       : in std_logic_vector(7 downto 0);
    p_valid : in std_logic;
    i_valid : in std_logic;
    Y       : out std_logic_vector(7 downto 0);
    Cb      : out std_logic_vector(7 downto 0);
    Cr      : out std_logic_vector(7 downto 0)
   );
end rgb_to_ycbcr_converter;

architecture rtl of rgb_to_ycbcr_converter is

begin
    process(clk, reset)
        variable r_integer, g_integer, b_integer   : integer;
        variable y_integer, cb_integer, cr_integer : integer;
    
    begin
        if reset = '1' then
            Y  <= (others => '0');
            Cb <= (others => '0');
            Cr <= (others => '0');
                    
        elsif rising_edge(clk) then 
            
            if i_valid = '1' then
                Y  <= (others => '0');
                Cb <= (others => '0');
                Cr <= (others => '0');
            end if;
            
            if p_valid = '1' then
                r_integer := to_integer(unsigned(R));
                g_integer := to_integer(unsigned(G));
                b_integer := to_integer(unsigned(B));
                 
                y_integer  := 16 + (((65 * r_integer) +  (129 * g_integer) + (25 * b_integer) ) / 256);
                cb_integer := 128 - (((37 * r_integer) +  (74 * g_integer) - (112 * b_integer) ) / 256);
                cr_integer := 128 + (((112 * r_integer) -  (94 * g_integer) - (18 * b_integer) ) / 256);
                
                if y_integer < 0 
                    then y_integer := 0;
                elsif y_integer > 255
                    then y_integer := 255;
                end if;
                
                if cb_integer < 0 
                    then cb_integer := 0;
                elsif cb_integer > 255
                    then cb_integer := 255;
                end if;
                
                if cr_integer < 0 
                    then cr_integer := 0;
                elsif cr_integer > 255
                    then cr_integer := 255;
                end if;
                
                Y  <= std_logic_vector(to_unsigned(y_integer, 8));
                Cb <= std_logic_vector(to_unsigned(cb_integer, 8));
                Cr <= std_logic_vector(to_unsigned(cr_integer, 8));
            end if;
         end if;
    end process;
end rtl;
