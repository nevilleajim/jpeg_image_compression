----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2025 11:07:49 AM
-- Design Name: 
-- Module Name: dct_transform_tb - rtl
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

entity dct_transform_tb is
--  Port ( );
end dct_transform_tb;

architecture rtl of dct_transform_tb is

  signal clk     : std_logic := '0';
  signal reset   : std_logic := '0';
  signal start   : std_logic := '0';
  signal done    : std_logic;
  
--  type pixel_matrix is array(0 to 7, 0 to 7) of signed(15 downto 0);
  signal data_in : cos_matrix := (others => (others => to_signed(0, 16)));
  signal dct_out : cos_matrix; 

begin
    
    DUT: entity work.dct_transform
        port map(
            clk     => clk,
            reset   => reset,
            start   => start,
            data_in => data_in,
            dct_out => dct_out,
            done    => done
        );
        
    clock_process: process
    begin
        clk <= '0';
        wait for 10ns;
        
        clk <= '1';
        wait for 10ns;
    end process;
    
    stim_process: process
    begin
        reset <= '1';
        wait for 20ns;
        
        reset <= '0';
        wait for 20ns;
        
        for x in 0 to 7 loop
            for y in 0 to 7 loop
                data_in(x, y) <= to_signed(x*16 + y*2, 16);
            end loop;
        end loop;
        
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';
        
        wait until done = '1';
        wait until rising_edge(clk);
        
--        report "==== DCT Transform Completed ====";

--        for i in 0 to 7 loop
--            constant row_string : string(1 to 200);
--            variable idx : integer := 1;

--            row_string := (others => ' ');

--            for j in 0 to 7 loop
--                -- convert signed number to readable string
--                variable sval : integer := to_integer(dct_out(i,j));
--                variable t : string(1 to 12);

--                write(t, sval);
--                for k in t'range loop
--                    row_string(idx) := t(k);
--                    idx := idx + 1;
--                end loop;

--                row_string(idx) := ' ';
--                idx := idx + 1;
--            end loop;

--            report row_string;
--        end loop;
       wait;
    end process;

end rtl;

--read_control: process(clk)
--    begin
--        if rising_edge(clk) then
--            if reset = '1' then
--                block_row <= "000";
--                block_col <= "000";
--                rd_active <= '0';
--            else
--                -- Start reading as soon as we have data (you can add delay if needed)
--                rd_active <= '1';

--                if block_col = 7 and block_row = 7 then
--                    block_row <= "000";
--                    block_col <= "000";                    -- next block
--                elsif block_col = 7 then
--                    block_row <= block_row + 1;
--                    block_col <= "000";                    -- next row
--                else
--                    block_col <= block_col + 1;            -- next pixel in row
--                end if;
--            end if;
--        end if;
--    end process;

--    -- Read address = current ROW in the 8x8 block
--    -- All 8 RAMs output their pixel from this row ? full 8-pixel row
--    ram_addr_rd <= std_logic_vector(block_row);

--    -- Mux: pick the correct RAM output based on current column
--    dct_pixel <= ram_dout( 8*to_integer(block_col)+7 downto 8*to_integer(block_col) );

--    -- Valid signal: high whenever we output a real pixel
--    block_valid <= rd_active;
