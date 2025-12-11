----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/28/2025 12:30:46 PM
-- Design Name: 
-- Module Name: dct_transform - rtl
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
use IEEE.MATH_REAL.ALL;
use work.dct_package.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dct_transform is
  Port (
    clk     : in std_logic;
    reset   : in std_logic;
    start   : in std_logic;
    data_in : in cos_matrix;
    done    : out std_logic;
    dct_out : out cos_matrix
   );
end dct_transform;

architecture rtl of dct_transform is

    signal busy       : std_logic := '0';
    
    signal i, j, x, y   : integer range 0 to 7 := 0;
    signal i_reg, j_reg : integer range 0 to 7 := 0;
    
    constant CI0      : integer := 11585;
    constant CI1      : integer := 23170;
    
    signal acc        : integer := 0;
    signal acc1       : integer := 0;
    signal acc2       : integer := 0;
    signal acc_final  : integer := 0;
    
    signal stage      : integer range 0 to 7 := 0;
    
    function norm (i : integer) return integer is
    begin
        if i = 0 then return CI0; 
        else return CI1; 
        end if;
    end function;

begin

    process(reset, clk) 
    begin
        if reset = '1' then
            busy <= '0';
            done <= '0';
            i    <= 0;
            j    <= 0;
            x    <= 0;
            y    <= 0;
            acc  <= 0;
            stage<= 0;
        
        elsif rising_edge(clk) then
            if start = '1' and busy = '0' then
                busy <= '1';
                done <= '0';
                i    <= 0;
                j    <= 0;
                x    <= 0;
                y    <= 0;
                acc  <= 0;
                stage<= 0;
            
            elsif busy = '1' and stage = 0 then
                acc <= acc + (to_integer(data_in(x, y)) *
                             to_integer(COS_X(i, x)) *
                             to_integer(COS_Y(j, y))) / 32768;
                
                if y <= 7 then 
                    y <= y + 1;
                
                elsif x <= 7 then
                    x <= x+1;
                    y <= 0;
                
                else
                    i_reg <= i;
                    j_reg <= j;
                    stage <= 1;
                    end if;
                end if;
            end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if busy = '1' and stage = 1 then
                acc1  <= acc * norm(i);
                stage <= 2;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if busy = '1' and stage = 2 then
                acc2  <= acc1 * norm(j);
                stage <= 3;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if busy = '1' and stage = 3 then
                acc_final             <= (32768 * 32768);
                dct_out(i_reg, j_reg) <= to_signed(acc2 / acc_final, 16);
                
                acc <= 0;
                x <= 0;
                y <= 0;
                    
                if j < 7 then
                   j <= j + 1;   
                elsif i < 7 then
                   i <= i + 1;
                   j <= 0;
                else 
                   busy <= '0';
                   done <= '1';
                end if;
             end if;
         end if;
    end process;

end rtl;
