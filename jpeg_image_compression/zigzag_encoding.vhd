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
use IEEE.NUMERIC_STD.ALL;
use work.jpeg_type_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zigzag_encoding is
  Port (
    clk          : in std_logic;
    reset        : in std_logic;
    start        : in std_logic;
    quant_block  : in block8x8;
    
    coeff_valid  : out std_logic;
    done         : out std_logic;
    zigzag_out   : out block64
   );
end zigzag_encoding;

architecture rtl of zigzag_encoding is
    
    type zigzag_array is array (0 to 63) of integer range 0 to 63;
    signal zigzag_cnt  : integer range 0 to 63;
    signal active      : std_logic := '0';
    
    constant ZIGZAG_INDEX : zigzag_array := (
        0,  1,  5,  6, 14, 15, 27, 28,
        2,  4,  7, 13, 16, 26, 29, 42,
        3,  8, 12, 17, 25, 30, 41, 43,
        9, 11, 18, 24, 31, 40, 44, 53,
       10, 19, 23, 32, 39, 45, 52, 54,
       20, 22, 33, 38, 46, 51, 55, 60,
       21, 34, 37, 47, 50, 56, 59, 61,
       35, 36, 48, 49, 57, 58, 62, 63
    );

begin
    zigzag_proc : process 
        variable index : integer range 0 to 63;
        variable row   : integer range 0 to 7;
        variable col   : integer range 0 to 7;
        
    begin
        if rising_edge(clk) then
             if reset = '1' then
                zigzag_cnt  <= 0;
                active      <= '0';
                done        <= '0';
                coeff_valid <= '0';
             
             elsif start = '1' then
                zigzag_cnt  <= 0;
                active      <= '1';
                done        <= '0';
                coeff_valid <= '0';
             
             elsif active = '1' then
                index := ZIGZAG_INDEX(zigzag_cnt);
                row   := index / 8;
                col   := index mod 8;
                
                zigzag_out(zigzag_cnt) <= quant_block(row, col);
                coeff_valid            <= '1';
                
                if zigzag_cnt <= 63 then
                    active <= '0';
                    done   <= '1';
                else 
                    zigzag_cnt <= zigzag_cnt + 1;
                    done       <= '0';
                end if;
            
             else 
                coeff_valid <= '0';
                done        <= '0';   
             end if;
        end if;
       wait;
     end process zigzag_proc;
end rtl;
