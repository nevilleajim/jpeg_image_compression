library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

package dct_package is
    constant m  : integer := 8;
    constant n  : integer := 8;
    constant PI : real    := 3.14159265358979323846;
    
    subtype fp16 is real;
    type cos_array is array (0 to m-1, 0 to n-1) of fp16;
    
    function make_cos_x return cos_array;
    function make_cos_y return cos_array;
    
end package;

package body dct_package is
    function make_cos_x return cos_array is
        variable cos_x : cos_array;
    begin
        for i in 0 to m-1 loop
            for x in 0 to m-1 loop
                cos_x(i, x) := cos((2.0 * real(x) + 1.0) * real(i) * PI / (2.0 * real(m)));
            end loop;
        end loop;
        return cos_x;
    end function;
    
    function make_cos_y return cos_array is
        variable cos_y : cos_array;
    begin
        for j in 0 to n-1 loop
            for y in 0 to n-1 loop
                cos_y(j, y) := cos((2.0 * real(y) + 1.0) * real(j) * PI / (2.0 * real(n)));
            end loop;
        end loop;
        return cos_y;
    end function;

end package body;