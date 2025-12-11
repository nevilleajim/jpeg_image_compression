----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/03/2025 09:56:28 AM
-- Design Name: 
-- Module Name: quantization - rtl
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
use work.dct_package.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity quantization is
  Port (
    clk          : in std_logic;
    reset        : in std_logic;
    
    dct_in       : in std_logic_vector(15 downto 0);
    u_dct        : in std_logic_vector(2 downto 0);
    v_dct        : in std_logic_vector(2 downto 0);
    in_valid     : in std_logic;
    
    out_valid    : out std_logic;
    quant_out    : out std_logic_vector(15 downto 0)
   );
end quantization;

architecture rtl of quantization is

    type q_matrix_type is array (0 to 7, 0 to 7) of integer;
    
    constant quant_matrix : q_matrix_type := (
        (16, 11, 10, 16, 24, 40, 51, 61),
        (12, 12, 14, 19, 26, 58, 60, 55),
        (14, 13, 16, 24, 40, 57, 69, 56),
        (14, 17, 22, 29, 51, 87, 80, 62),
        (18, 22, 37, 56, 68,109,103, 77),
        (24, 35, 55, 64, 81,104,113, 92),
        (49, 64, 78, 87,103,121,120,101),
        (72, 92, 95, 98,112,100,103, 99)
    );
    
    function round_div(num : integer; denom : integer) return integer is 
        variable result : integer;
    begin
        if denom = 0 then
            return 0;
        end if;
        
        if num >= 0 then
            result := (num + denom/2) / denom;
        else
            result := (num - denom/2) / denom;
        end if;
        
        return result;
    end function;

begin

    process(clk)
        variable dct_val   : integer;
        variable q_val     : integer;
        variable quantized : integer;
    begin 
        if rising_edge(clk) then
            if reset = '1' then
                quant_out <= (others => '0');
                out_valid <= '0';
            
            elsif in_valid = '1' then
                dct_val := to_integer(signed(dct_in));
                q_val   := quant_matrix(to_integer(unsigned(u_dct)), to_integer(unsigned(v_dct)));
                
                quantized := round_div(dct_val, q_val);
                
                quant_out <= std_logic_vector(to_signed(quantized, 16));
                out_valid <= '1';
                
            else
                out_valid <= '0';
            end if;
        end if;
     end process;

end rtl;
