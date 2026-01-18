----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2026 10:49:20 AM
-- Design Name: 
-- Module Name: quant_block_buf - rtl
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

entity quant_block_buf is
 Port (
    clk         : in std_logic;
    reset       : in std_logic;
    
    quant_in    : in std_logic_vector(15 downto 0);
    u_in        : in std_logic_vector(2 downto 0);
    v_in        : in std_logic_vector(2 downto 0);
    in_valid    : in std_logic;
    
    block_out   : out block8x8;
    block_valid : out std_logic
   );

end quant_block_buf;

architecture rtl of quant_block_buf is
    signal quant_buf    : block8x8;
    signal q_count      : integer range 0 to 63 := 0;
begin
    
    process(clk)
        variable u  : integer;
        variable v  : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                q_count     <= 0;
                block_valid <= '0';
            
            elsif in_valid = '1' then
                u := to_integer(unsigned(u_in));
                v := to_integer(unsigned(v_in));
                
                quant_buf(u, v) <= (signed(quant_in));
                
                if q_count = 63 then
                    block_valid <= '1';
                    q_count     <= 0;
                else
                    q_count     <= q_count+1;
                    block_valid <= '0';
                end if;
            else
                block_valid  <= '0';
            end if;
       end if;
   end process;
   
   block_out <= quant_buf;


end rtl;
