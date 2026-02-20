----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2026 05:21:47 PM
-- Design Name: 
-- Module Name: top_module_jpeg_compression_tb - rtl
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
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use work.dct_package.ALL; 
use work.jpeg_type_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module_jpeg_compression_tb is
--  Port ( );
end top_module_jpeg_compression_tb;

architecture rtl of top_module_jpeg_compression_tb is

    signal clk          : std_logic; 
    signal reset        : std_logic; 
 
    signal R            : std_logic_vector(7 downto 0); 
    signal G            : std_logic_vector(7 downto 0); 
    signal B            : std_logic_vector(7 downto 0);
 
    signal p_valid      : std_logic; 
    signal i_valid      : std_logic; 

    signal start        : std_logic; 
    signal quant_block  : block8x8;
    signal block_in     : block64;
    
    signal zigzag_valid : std_logic; 
    signal done         : std_logic; 
    signal zigzag_out   : block64;
    
    constant Width  : integer := 8;
    constant Height : integer := 8;
    constant PIXELS : integer := Width * Height;

    type pixel_array is array (0 to PIXELS-1) of std_logic_vector(7 downto 0);
    signal red_data, green_data, blue_data : pixel_array;
    
    file red_file     : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/red_channel.txt";
    file green_file   : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/green_channel.txt";
    file blue_file    : text open read_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/blue_channel.txt";
    file zigzag_file  : text open write_mode is "C:/Users/hp/Documents/FGPA/mini_project/python_implementation/zigzag_output.txt";

    component top_module_jpeg_compression
    port (
        clk          : in std_logic; 
        reset        : in std_logic; 
        
        R            : in std_logic_vector(7 downto 0); 
        G            : in std_logic_vector(7 downto 0); 
        B            : in std_logic_vector(7 downto 0);
         
        p_valid      : in std_logic; 
        i_valid      : in std_logic; 
        
        start        : in std_logic; 
--        quant_block  : in block8x8;
--        block_in     : in block64;
        zigzag_valid : out std_logic; 
        done         : out std_logic; 
        zigzag_out   : out block64
    );
    end component;

begin

    U_TOPMODULE: top_module_jpeg_compression
    port map (
        clk          => clk,
        reset        => reset,
        R            => R,
        G            => G,
        B            => B,
        p_valid      => p_valid,
        i_valid      => i_valid,
        start        => start,
        zigzag_valid => zigzag_valid,
        done         => done,
        zigzag_out   => zigzag_out
    );
    
    read_files_proc : process
        variable L : line;
        variable value_int : integer;
    begin
        for i in 0 to PIXELS-1 loop
            if endfile(red_file) then
                exit;
            end if;
            readline(red_file, L);
            read(L, value_int);
            red_data(i) <= std_logic_vector(to_unsigned(value_int, 8));
        end loop;

        for i in 0 to PIXELS-1 loop
            if endfile(green_file) then
                exit;
            end if;
            readline(green_file, L);
            read(L, value_int);
            green_data(i) <= std_logic_vector(to_unsigned(value_int, 8));
        end loop;

        for i in 0 to PIXELS-1 loop
            if endfile(blue_file) then
                exit;
            end if;
            readline(blue_file, L);
            read(L, value_int);
            blue_data(i) <= std_logic_vector(to_unsigned(value_int, 8));
        end loop;

        report "Image data successfully loaded.";
        wait;
    end process read_files_proc;
    
    reset_proc: process
    begin
        reset <= '1';
        wait for 20ns;
        
        reset <= '0';
        wait for 20ns;
    end process reset_proc;
    
    stim_process: process
    
    variable L      : line;
    
    begin
        wait until rising_edge(clk);
       
        i_valid <= '1';
        
        for i in 0 to PIXELS-1 loop
            p_valid <= '1';
            R       <= red_data(i);
            G       <= green_data(i);
            B       <= blue_data(i);
            
            wait until rising_edge(clk);
        end loop;
        
        p_valid     <= '0';
        i_valid     <= '0';
        
        wait until done <= '1';
        report "JPEG Block Completed";
        
        for i in 0 to 63 loop
            write(L, to_integer(signed(zigzag_out(i))));
            writeline(zigzag_file, L);
        end loop;
    end process stim_process;

end rtl;
