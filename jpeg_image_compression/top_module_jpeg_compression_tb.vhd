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
        quant_block  : in block8x8;
        block_in     : in block64;
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
        quant_block  => quant_block,
        block_in     => block_in,
        zigzag_valid => zigzag_valid,
        done         => done,
        zigzag_out   => zigzag_out
    );

end rtl;
