library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package dct_package is
    constant M : integer := 8;
    constant N : integer := 8;

    subtype fixed16 is signed(15 downto 0);
    type cos_matrix is array (0 to M-1, 0 to N-1) of fixed16;

    --  Cosine lookup table
    constant COS_X : cos_matrix := (
        0 => (to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16)),
        1 => (to_signed(32138, 16), to_signed(27245, 16), to_signed(18204, 16), to_signed(6392, 16), to_signed(-6392, 16), to_signed(-18204, 16), to_signed(-27245, 16), to_signed(-32138, 16)),
        2 => (to_signed(30273, 16), to_signed(12539, 16), to_signed(-12539, 16), to_signed(-30273, 16), to_signed(-30273, 16), to_signed(-12539, 16), to_signed(12539, 16), to_signed(30273, 16)),
        3 => (to_signed(27245, 16), to_signed(-6392, 16), to_signed(-32138, 16), to_signed(-18204, 16), to_signed(18204, 16), to_signed(32138, 16), to_signed(6392, 16), to_signed(-27245, 16)),
        4 => (to_signed(23170, 16), to_signed(-23170, 16), to_signed(-23170, 16), to_signed(23170, 16), to_signed(23170, 16), to_signed(-23170, 16), to_signed(-23170, 16), to_signed(23170, 16)),
        5 => (to_signed(18204, 16), to_signed(-32138, 16), to_signed(6392, 16), to_signed(27245, 16), to_signed(-27245, 16), to_signed(-6392, 16), to_signed(32138, 16), to_signed(-18204, 16)),
        6 => (to_signed(12539, 16), to_signed(-30273, 16), to_signed(30273, 16), to_signed(-12539, 16), to_signed(-12539, 16), to_signed(30273, 16), to_signed(-30273, 16), to_signed(12539, 16)),
        7 => (to_signed(6392, 16), to_signed(-18204, 16), to_signed(27245, 16), to_signed(-32138, 16), to_signed(32138, 16), to_signed(-27245, 16), to_signed(18204, 16), to_signed(-6392, 16))
    );
    
    constant COS_Y : cos_matrix := (
        0 => (to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16), to_signed(32768, 16)),
        1 => (to_signed(32138, 16), to_signed(27245, 16), to_signed(18204, 16), to_signed(6392, 16), to_signed(-6392, 16), to_signed(-18204, 16), to_signed(-27245, 16), to_signed(-32138, 16)),
        2 => (to_signed(30273, 16), to_signed(12539, 16), to_signed(-12539, 16), to_signed(-30273, 16), to_signed(-30273, 16), to_signed(-12539, 16), to_signed(12539, 16), to_signed(30273, 16)),
        3 => (to_signed(27245, 16), to_signed(-6392, 16), to_signed(-32138, 16), to_signed(-18204, 16), to_signed(18204, 16), to_signed(32138, 16), to_signed(6392, 16), to_signed(-27245, 16)),
        4 => (to_signed(23170, 16), to_signed(-23170, 16), to_signed(-23170, 16), to_signed(23170, 16), to_signed(23170, 16), to_signed(-23170, 16), to_signed(-23170, 16), to_signed(23170, 16)),
        5 => (to_signed(18204, 16), to_signed(-32138, 16), to_signed(6392, 16), to_signed(27245, 16), to_signed(-27245, 16), to_signed(-6392, 16), to_signed(32138, 16), to_signed(-18204, 16)),
        6 => (to_signed(12539, 16), to_signed(-30273, 16), to_signed(30273, 16), to_signed(-12539, 16), to_signed(-12539, 16), to_signed(30273, 16), to_signed(-30273, 16), to_signed(12539, 16)),
        7 => (to_signed(6392, 16), to_signed(-18204, 16), to_signed(27245, 16), to_signed(-32138, 16), to_signed(32138, 16), to_signed(-27245, 16), to_signed(18204, 16), to_signed(-6392, 16))
    );


end package;
