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
    
    type dc_luma_array is array(0 to 11) of dc_code_type;
    constant DC_LUMA_HUFF  : dc_luma_array := (
        (code => "00",          length => 2),
        (code => "010",         length => 3),
        (code => "011",         length => 3),
        (code => "100",         length => 3),
        (code => "101",         length => 3),
        (code => "110",         length => 3),
        (code => "1110",        length => 4),
        (code => "11110",       length => 5),
        (code => "111110",      length => 6),
        (code => "1111110",     length => 7),
        (code => "11111110",    length => 8),
        (code => "111111110",   length => 9)
    );
    
    type ac_code_type is record
        code   : std_logic_vector(15 downto 0);
        length : integer range 0 to 16;
    end record;
    
    type ac_luma_array is array(0 to 15, 0 to 10) of ac_code_type;
    constant AC_LUMA_HUFF : ac_luma_array := (
    0 => (
        0  => (code => "1010",             length => 4),
        1  => (code => "00",               length => 2),
        2  => (code => "01",               length => 2),
        3  => (code => "100",              length => 3),
        4  => (code => "1011",             length => 4),
        5  => (code => "11010",            length => 5),
        6  => (code => "1111000",          length => 7),
        7  => (code => "11111000",         length => 8),
        8  => (code => "1111110110",       length => 10),
        9  => (code => "1111111110000010", length => 16),
        10 => (code => "1111111110000011", length => 16),
        
        others => (code => (others => '0'), length => 0)  
    ),
    1 => (
        1  => (code => "1100",             length => 4),
        2  => (code => "11011",            length => 5),
        3  => (code => "1111001",          length => 7),
        4  => (code => "111110110",        length => 9),
        5  => (code => "11111110110",      length => 11),
        6  => (code => "1111111110000100", length => 16),
        7  => (code => "1111111110000101", length => 16),
        8  => (code => "1111111110000110", length => 16),
        9  => (code => "1111111110000111", length => 16),
        10 => (code => "1111111110001000", length => 16),
        
        others => (code => (others => '0'), length => 0)
    ),
    2 => (
        1  => (code => "11100",            length => 5),
        2  => (code => "11111001",         length => 8),
        3  => (code => "1111110111",       length => 10),
        4  => (code => "111111110100",     length => 12),
        5  => (code => "1111111110001001", length => 16),
        6  => (code => "1111111110001010", length => 16),
        7  => (code => "1111111110001011", length => 16),
        8  => (code => "1111111110001100", length => 16),
        9  => (code => "1111111110001101", length => 16),
        10 => (code => "1111111110001110", length => 16),
        
        others => (code => (others => '0'), length => 0)
    ),
    3 => (
        1  => (code => "111010",           length => 6),
        2  => (code => "111110111",        length => 9),
        3  => (code => "111111110101",     length => 12),
        4  => (code => "1111111110001111", length => 16),
        5  => (code => "1111111110010000", length => 16),
        6  => (code => "1111111110010001", length => 16),
        7  => (code => "1111111110010010", length => 16),
        8  => (code => "1111111110010011", length => 16),
        9  => (code => "1111111110010100", length => 16),
        10 => (code => "1111111110010101", length => 16),

        others => (code => (others => '0'), length => 0)
    ),
    4 => (
        1  => (code => "111011",           length => 6),
        2  => (code => "1111111000",       length => 10),
        3  => (code => "1111111110010110", length => 16),
        4  => (code => "1111111110010111", length => 16),
        5  => (code => "1111111110011000", length => 16),
        6  => (code => "1111111110011001", length => 16),
        7  => (code => "1111111110011010", length => 16),
        8  => (code => "1111111110011011", length => 16),
        9  => (code => "1111111110011100", length => 16),
        10 => (code => "1111111110011101", length => 16),

        others => (code => (others => '0'), length => 0)
    ),
    5 => (
        1  => (code => "1111010",          length => 7),
        2  => (code => "11111110111",      length => 11),
        3  => (code => "1111111110011110", length => 16),
        4  => (code => "1111111110011111", length => 16),
        5  => (code => "1111111110100000", length => 16),
        6  => (code => "1111111110100001", length => 16),
        7  => (code => "1111111110100010", length => 16),
        8  => (code => "1111111110100011", length => 16),
        9  => (code => "1111111110100100", length => 16),
        10 => (code => "1111111110100101", length => 16),
        
        others => (code => (others => '0'), length => 0)
    ),
    6 => (
        0  => (code => (others=>'0'), length => 0),
        1  => (code => "1111011",          length => 7),
        2  => (code => "111111110110",     length => 12),
        3  => (code => "1111111110100110", length => 16),
        4  => (code => "1111111110100111", length => 16),
        5  => (code => "1111111110101000", length => 16),
        6  => (code => "1111111110101001", length => 16),
        7  => (code => "1111111110101010", length => 16),
        8  => (code => "1111111110101011", length => 16),
        9  => (code => "1111111110101100", length => 16),
        10 => (code => "1111111110101101", length => 16),
        others => (code => (others=>'0'), length => 0)
     ),
     7 => (
        0  => (code => (others=>'0'), length => 0),
        1  => (code => "11111010", length => 8),
        2  => (code => "111111110111", length => 12),
        3  => (code => "1111111110101110", length => 16),
        4  => (code => "1111111110101111", length => 16),
        5  => (code => "1111111110110000", length => 16),
        6  => (code => "1111111110110001", length => 16),
        7  => (code => "1111111110110010", length => 16),
        8  => (code => "1111111110110011", length => 16),
        9  => (code => "1111111110110100", length => 16),
        10 => (code => "1111111110110101", length => 16),
        others => (code => (others=>'0'), length => 0)
      ),
      8 => (
        0  => (code => (others=>'0'), length => 0),
        1  => (code => "111111000", length => 10),
        2  => (code => "111111111000000", length => 15),
        3  => (code => "1111111110110110", length => 16),
        4  => (code => "1111111110110111", length => 16),
        5  => (code => "1111111110111000", length => 16),
        6  => (code => "1111111110111001", length => 16),
        7  => (code => "1111111110111010", length => 16),
        8  => (code => "1111111110111011", length => 16),
        9  => (code => "1111111110111100", length => 16),
        10 => (code => "1111111110111101", length => 16),
        others => (code => (others=>'0'), length => 0)
      ),
      9 => (
        0  => (code => (others=>'0'), length => 0),
        1  => (code => "111111001", length => 10),
        2  => (code => "1111111110111110", length => 16),
        3  => (code => "1111111110111111", length => 16),
        4  => (code => "1111111111000000", length => 16),
        5  => (code => "1111111111000001", length => 16),
        6  => (code => "1111111111000010", length => 16),
        7  => (code => "1111111111000011", length => 16),
        8  => (code => "1111111111000100", length => 16),
        9  => (code => "1111111111000101", length => 16),
        10 => (code => "1111111111000110", length => 16),
        others => (code => (others=>'0'), length => 0)
      ),
      10 => (
         0  => (code => (others=>'0'), length => 0),
         1  => (code => "111111010", length => 10),
         2  => (code => "1111111111000111", length => 16),
         3  => (code => "1111111111001000", length => 16),
         4  => (code => "1111111111001001", length => 16),
         5  => (code => "1111111111001010", length => 16),
         6  => (code => "1111111111001011", length => 16),
         7  => (code => "1111111111001100", length => 16),
         8  => (code => "1111111111001101", length => 16),
         9  => (code => "1111111111001110", length => 16),
         10 => (code => "1111111111001111", length => 16),
         others => (code => (others=>'0'), length => 0)
      ),
      11 => (
         0  => (code => (others=>'0'), length => 0),
         1  => (code => "1111111001", length => 10),
         2  => (code => "1111111111010000", length => 16),
         3  => (code => "1111111111010001", length => 16),
         4  => (code => "1111111111010010", length => 16),
         5  => (code => "1111111111010011", length => 16),
         6  => (code => "1111111111010100", length => 16),
         7  => (code => "1111111111010101", length => 16),
         8  => (code => "1111111111010110", length => 16),
         9  => (code => "1111111111010111", length => 16),
         10 => (code => "1111111111011000", length => 16),
         others => (code => (others=>'0'), length => 0)
      ),
      12 => (
            0  => (code => (others=>'0'), length => 0),
            1  => (code => "1111111010", length => 10),
            2  => (code => "1111111111011001", length => 16),
            3  => (code => "1111111111011010", length => 16),
            4  => (code => "1111111111011011", length => 16),
            5  => (code => "1111111111011100", length => 16),
            6  => (code => "1111111111011101", length => 16),
            7  => (code => "1111111111011110", length => 16),
            8  => (code => "1111111111011111", length => 16),
            9  => (code => "1111111111100000", length => 16),
            10 => (code => "1111111111100001", length => 16),
            others => (code => (others=>'0'), length => 0)
      ),
      13 => (
            0  => (code => (others=>'0'), length => 0),
            1  => (code => "11111111000", length => 11),
            2  => (code => "1111111111100010", length => 16),
            3  => (code => "1111111111100011", length => 16),
            4  => (code => "1111111111100100", length => 16),
            5  => (code => "1111111111100101", length => 16),
            6  => (code => "1111111111100110", length => 16),
            7  => (code => "1111111111100111", length => 16),
            8  => (code => "1111111111101000", length => 16),
            9  => (code => "1111111111101001", length => 16),
            10 => (code => "1111111111101010", length => 16),
            others => (code => (others=>'0'), length => 0)
      ),
      14 => (
            0  => (code => (others=>'0'), length => 0),
            1  => (code => "1111111111101011", length => 16),
            2  => (code => "1111111111101100", length => 16),
            3  => (code => "1111111111101101", length => 16),
            4  => (code => "1111111111101110", length => 16),
            5  => (code => "1111111111101111", length => 16),
            6  => (code => "1111111111110000", length => 16),
            7  => (code => "1111111111110001", length => 16),
            8  => (code => "1111111111110010", length => 16),
            9  => (code => "1111111111110011", length => 16),
            10 => (code => "1111111111110100", length => 16),
            others => (code => (others=>'0'), length => 0)
      ),
     15 => (
        0 => (code => "11111111001", length => 11),
        1 => (code => "1111111111110101", length => 16),
        2 => (code => "1111111111110110", length => 16),
        3 => (code => "1111111111110111", length => 16),
        4 => (code => "1111111111111000", length => 16),
        5 => (code => "1111111111111001", length => 16),
        6 => (code => "1111111111111010", length => 16),
        7 => (code => "1111111111111011", length => 16),
        8 => (code => "1111111111111100", length => 16),
        9 => (code => "1111111111111101", length => 16),
        10 => (code => "1111111111111110", length => 16),
        
        others => (code => (others => '0'), length => 0)
     )
    );
    
    function category(value: integer) return integer;
    
    function value_bits(value: integer; size: integer) return std_logic_vector;

end package;

package body jpeg_type_pkg is
       
       function category(value : integer) return integer is
            variable v : integer := abs(value);
            variable c : integer := 0;
       begin
            if value = 0 then
                return 0;
            end if;
            while v > 0 loop
                v := v / 2;
                c := c + 1;
            end loop;
            return c;
       end function;
       
       function value_bits(value: integer; size: integer) return std_logic_vector is
            variable bits : std_logic_vector(size-1 downto 0);
            variable mask : integer := (2 ** size) - 1;
       begin 
            if size = 0 then
                return (others => '0');
            end if;
            if value >= 0 then
                bits := std_logic_vector(to_unsigned(value, size));
            else
                bits := std_logic_vector(to_unsigned(value + (2**size)-1, size));
            end if;
            return bits;
       end function;

end package body;