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
        code        : std_logic_vector(15 downto 0);
        length      : integer range 0 to 16;
    end record;
    
    type dc_huff_array is array (0 to 11) of dc_code_type;
    
    constant DC_LUMA_HUFF : dc_huff_array   := (
        0   => (code => "0000000000000000", length => 2),
        1   => (code => "0100000000000000", length => 3),
        2   => (code => "0110000000000000", length => 3),
        3   => (code => "1000000000000000", length => 3),
        4   => (code => "1010000000000000", length => 3),
        5   => (code => "1100000000000000", length => 3),
        6   => (code => "1110000000000000", length => 4),
        7   => (code => "1111000000000000", length => 5),
        8   => (code => "1111100000000000", length => 6),
        9   => (code => "1111110000000000", length => 7),
        10  => (code => "1111111000000000", length => 8),
        11  => (code => "1111111100000000", length => 9)
    );
    
    type ac_code_type is record
        code        : std_logic_vector(15 downto 0);
        length      : integer range 0 to 16;
    end record;
    
    type ac_huff_array is array (0 to 15, 0 to 10) of ac_code_type;
    
    constant AC_LUMA_HUFF : ac_huff_array   := (
        0  => (
            0  => (code => "1010000000000000", length => 4),  
            1  => (code => "0000000000000000", length => 2), 
            2  => (code => "0100000000000000", length => 2),
            3  => (code => "1000000000000000", length => 3), 
            4  => (code => "1011000000000000", length => 4),  
            5  => (code => "1101000000000000", length => 5),  
            6  => (code => "1111000000000000", length => 7),  
            7  => (code => "1111100000000000", length => 8),  
            8  => (code => "1111111000000000", length => 10), 
            9  => (code => "1111111100000000", length => 16), 
            10 => (code => "1111111110000000", length => 16)   
        ),
        -- run=1
        1  => (
            0  => (code => "0000000000000000", length => 0),  
            1  => (code => "1100000000000000", length => 4), 
            2  => (code => "1101100000000000", length => 5), 
            3  => (code => "1111001000000000", length => 7), 
            4  => (code => "1111101000000000", length => 9), 
            5  => (code => "1111110100000000", length => 11),
            6  => (code => "1111111010000000", length => 16),
            7  => (code => "1111111011000000", length => 16),
            8  => (code => "1111111100000000", length => 16),
            9  => (code => "1111111101000000", length => 16),
            10 => (code => "1111111110000000", length => 16)  
        ),
        -- run=2
        2  => (
            0  => (code => "0000000000000000", length => 0),  
            1  => (code => "1110000000000000", length => 5), 
            2  => (code => "1111010000000000", length => 8), 
            3  => (code => "1111110000000000", length => 10),
            4  => (code => "1111110110000000", length => 12),
            5  => (code => "1111111100000000", length => 16),
            6  => (code => "1111111101000000", length => 16),
            7  => (code => "1111111110000000", length => 16),
            8  => (code => "1111111110100000", length => 16),
            9  => (code => "1111111111000000", length => 16),
            10 => (code => "1111111111010000", length => 16)  
        ),
        -- run=3
        3  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1110100000000000", length => 6),   
            2  => (code => "1111011000000000", length => 9),   
            3  => (code => "1111110111000000", length => 12),  
            4  => (code => "1111111100000000", length => 16),  
            5  => (code => "1111111101000000", length => 16),
            6  => (code => "1111111110000000", length => 16),
            7  => (code => "1111111110100000", length => 16),
            8  => (code => "1111111111000000", length => 16),
            9  => (code => "1111111111010000", length => 16),
            10 => (code => "1111111111100000", length => 16)
        ),
        -- run=4
        4  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111000000000000", length => 6),   
            2  => (code => "1111100000000000", length => 10),  
            3  => (code => "1111111000000000", length => 16),
            4  => (code => "1111111001000000", length => 16),
            5  => (code => "1111111010000000", length => 16),
            6  => (code => "1111111011000000", length => 16),
            7  => (code => "1111111100000000", length => 16),
            8  => (code => "1111111101000000", length => 16),
            9  => (code => "1111111110000000", length => 16),
            10 => (code => "1111111110100000", length => 16)
        ),
        -- run=5
        5  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111010000000000", length => 7),   
            2  => (code => "1111110000000000", length => 11),  
            3  => (code => "1111111100000000", length => 16),
            4  => (code => "1111111101000000", length => 16),
            5  => (code => "1111111110000000", length => 16),
            6  => (code => "1111111110100000", length => 16),
            7  => (code => "1111111111000000", length => 16),
            8  => (code => "1111111111010000", length => 16),
            9  => (code => "1111111111100000", length => 16),
            10 => (code => "1111111111110000", length => 16)
        ),
        -- run=6
        6  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111011000000000", length => 7),   
            2  => (code => "1111110100000000", length => 12),  
            3  => (code => "1111111101000000", length => 16),
            4  => (code => "1111111110000000", length => 16),
            5  => (code => "1111111110100000", length => 16),
            6  => (code => "1111111111000000", length => 16),
            7  => (code => "1111111111010000", length => 16),
            8  => (code => "1111111111100000", length => 16),
            9  => (code => "1111111111110000", length => 16),
            10 => (code => "1111111111111000", length => 16)
        ),
        -- run=7
        7  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111100000000000", length => 8),   
            2  => (code => "1111111000000000", length => 12),  
            3  => (code => "1111111110000000", length => 16),
            4  => (code => "1111111110100000", length => 16),
            5  => (code => "1111111111000000", length => 16),
            6  => (code => "1111111111010000", length => 16),
            7  => (code => "1111111111100000", length => 16),
            8  => (code => "1111111111110000", length => 16),
            9  => (code => "1111111111111000", length => 16),
            10 => (code => "1111111111111100", length => 16)
        ),
        -- run=8
        8  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111100100000000", length => 9),  
            2  => (code => "1111111001000000", length => 15), 
            3  => (code => "1111111111000000", length => 16),
            4  => (code => "1111111111010000", length => 16),
            5  => (code => "1111111111100000", length => 16),
            6  => (code => "1111111111110000", length => 16),
            7  => (code => "1111111111111000", length => 16),
            8  => (code => "1111111111111100", length => 16),
            9  => (code => "1111111111111110", length => 16),
            10 => (code => "1111111111111111", length => 16)
        ),
        -- run=9
        9  => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111101000000000", length => 9),  
            2  => (code => "1111111010000000", length => 16),
            3  => (code => "1111111011000000", length => 16),
            4  => (code => "1111111100000000", length => 16),
            5  => (code => "1111111101000000", length => 16),
            6  => (code => "1111111110000000", length => 16),
            7  => (code => "1111111110100000", length => 16),
            8  => (code => "1111111111000000", length => 16),
            9  => (code => "1111111111010000", length => 16),
            10 => (code => "1111111111100000", length => 16)
        ),
        -- run=10
        10 => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111101100000000", length => 10),  
            2  => (code => "1111111100000000", length => 16),
            3  => (code => "1111111101000000", length => 16),
            4  => (code => "1111111110000000", length => 16),
            5  => (code => "1111111110100000", length => 16),
            6  => (code => "1111111111000000", length => 16),
            7  => (code => "1111111111010000", length => 16),
            8  => (code => "1111111111100000", length => 16),
            9  => (code => "1111111111110000", length => 16),
            10 => (code => "1111111111111000", length => 16)
        ),
        -- run=11
        11 => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111110000000000", length => 10),  
            2  => (code => "1111111101000000", length => 16),
            3  => (code => "1111111110000000", length => 16),
            4  => (code => "1111111110100000", length => 16),
            5  => (code => "1111111111000000", length => 16),
            6  => (code => "1111111111010000", length => 16),
            7  => (code => "1111111111100000", length => 16),
            8  => (code => "1111111111110000", length => 16),
            9  => (code => "1111111111111000", length => 16),
            10 => (code => "1111111111111100", length => 16)
        ),
        -- run=12
        12 => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111110100000000", length => 11),  
            2  => (code => "1111111110000000", length => 16),
            3  => (code => "1111111110100000", length => 16),
            4  => (code => "1111111111000000", length => 16),
            5  => (code => "1111111111010000", length => 16),
            6  => (code => "1111111111100000", length => 16),
            7  => (code => "1111111111110000", length => 16),
            8  => (code => "1111111111111000", length => 16),
            9  => (code => "1111111111111100", length => 16),
            10 => (code => "1111111111111110", length => 16)
        ),
        -- run=13
        13 => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111111000000000", length => 11),  
            2  => (code => "1111111110100000", length => 16),
            3  => (code => "1111111111000000", length => 16),
            4  => (code => "1111111111010000", length => 16),
            5  => (code => "1111111111100000", length => 16),
            6  => (code => "1111111111110000", length => 16),
            7  => (code => "1111111111111000", length => 16),
            8  => (code => "1111111111111100", length => 16),
            9  => (code => "1111111111111110", length => 16),
            10 => (code => "1111111111111111", length => 16)
        ),
        -- run=14
        14 => (
            0  => (code => "0000000000000000", length => 0),
            1  => (code => "1111111001000000", length => 12),  
            2  => (code => "1111111111000000", length => 16),
            3  => (code => "1111111111010000", length => 16),
            4  => (code => "1111111111100000", length => 16),
            5  => (code => "1111111111110000", length => 16),
            6  => (code => "1111111111111000", length => 16),
            7  => (code => "1111111111111100", length => 16),
            8  => (code => "1111111111111110", length => 16),
            9  => (code => "1111111111111111", length => 16),
            10 => (code => "1111111111111111", length => 16)
        ),
        15 => (
            0  => (code => "1111111010000000", length => 11),  
            1  => (code => "1111111010100000", length => 16),  
            2  => (code => "1111111111010000", length => 16),
            3  => (code => "1111111111100000", length => 16),
            4  => (code => "1111111111110000", length => 16),
            5  => (code => "1111111111111000", length => 16),
            6  => (code => "1111111111111100", length => 16),
            7  => (code => "1111111111111110", length => 16),
            8  => (code => "1111111111111111", length => 16),
            9  => (code => "1111111111111111", length => 16),
            10 => (code => "1111111111111111", length => 16)
        )
    );
    
    function category(val : integer) 
        return integer;
    
    function value_bits(val : integer; cat: integer)
        return std_logic_vector;

end package jpeg_type_pkg;

package body jpeg_type_pkg is 
    function category(val : integer) return integer is
        variable absval     : integer;
        variable cat        : integer;
        
        begin
            if val = 0 then
                return 0;
            end if;
            
            if val < 0 then
                absval := -val;
            else
                absval := val;
            end if;
            
            cat := 0;
            for i in 0 to 14 loop
                if absval > 0 then
                    absval := absval / 2;
                    cat    := cat + 1;
                end if;
            end loop;
            
            return cat;
     end function category;
     
     function value_bits(val : integer; cat: integer) return std_logic_vector is
        variable encoded    : integer;
        variable mask       : integer;
        variable result     : std_logic_vector(14 downto 0);
        
        begin
            result  := (others => '0');
            
            if val = 0 or cat = 0 then
                return result;
            end if;
            
            if val > 0 then
                encoded := val;
            else
                mask := 1;
                for k in 1 to 15 loop
                    if k <= cat then
                        mask := mask * 2;
                    end if;
                end loop;
                encoded := val + mask - 1;
            end if;
            
            for b in 0 to 14 loop
                if b < cat then
                    if (encoded / (2**b)) mod 2 = 1 then
                        result(14 - b) := '1';
                    end if;
                end if;
            end loop;
            
            result := std_logic_vector(
                shift_left(unsigned(result), 15 -cat)
            );
            
            return result;
        end function value_bits;

end package body jpeg_type_pkg;