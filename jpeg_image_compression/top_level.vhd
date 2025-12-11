----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2025 07:20:38 PM
-- Design Name: 
-- Module Name: top_level - rtl
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

entity top_level is
  generic(
    DATA_WIDTH  : integer := 8;
    LINE_LENGTH : integer := 256
  );
  
  Port ( 
    clk         : in std_logic;
    reset       : in std_logic;
    
    R           : in std_logic_vector(7 downto 0);
    G           : in std_logic_vector(7 downto 0);
    B           : in std_logic_vector(7 downto 0); 
    
    p_valid     : in std_logic;
    i_valid     : in std_logic;
    
    out_valid    : out std_logic;
    quant_out    : out std_logic_vector(15 downto 0)
  
  );
end top_level;

architecture rtl of top_level is

    signal Y           : std_logic_vector(7 downto 0);
    signal pixel_out   : std_logic_vector(7 downto 0);
    signal pixel_valid : std_logic;
    signal dct_start   : std_logic := '0';
    signal dct_coeff   : std_logic_vector(15 downto 0);
    signal coeff_u     : std_logic_vector(2 downto 0);
    signal coeff_v     : std_logic_vector(2 downto 0);
    signal coeff_valid : std_logic;
    
    component quantization
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
   end component;

begin

    U_CONV : entity work.rgb_to_ycbcr_converter
        port map(
            clk     => clk,
            reset   => reset,
            R       => R,
            G       => G,
            B       => B,
            p_valid => p_valid,
            i_valid => i_valid,
            Y       => Y,
            Cb      => open,
            Cr      => open
        );
    
    U_MEM : entity work.memory_controller
        generic map (
            DATA_WIDTH  => 8,
            LINE_LENGTH => 256
        )
        port map (
            clk         => clk,
            reset       => reset,  
            pixel_in    => Y,
            p_valid     => p_valid,
            i_valid     => i_valid,
       
            pixel_out   => pixel_out,
            pixel_valid => pixel_valid
        );
        
    U_DCT : entity work.dct_transform_streaming
       port map (
         clk   => clk,
         reset => reset,
                
         pixel_in     => pixel_out,
         pixel_valid  => pixel_valid,
                
         dct_coeff    => dct_coeff,
         coeff_u      => coeff_u,
         coeff_v      => coeff_v,
         coeff_valid  => coeff_valid
      );
      
      U_QUANTIZATION: quantization
        port map(
            clk        => clk,
            reset      => reset,
            
            dct_in     => dct_coeff,
            u_dct      => coeff_u,
            v_dct      => coeff_v,
            in_valid   => coeff_valid,
            out_valid  => out_valid,
            quant_out  => quant_out
        );

end rtl;
