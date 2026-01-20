----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/20/2026 05:06:50 PM
-- Design Name: 
-- Module Name: top_module_jpeg_compression - rtl
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
use IEEE.MATH_REAL.ALL; 
use work.dct_package.ALL; 
use work.jpeg_type_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module_jpeg_compression is
    generic( 
        DATA_WIDTH   : integer := 8; 
        LINE_LENGTH  : integer := 256 
    );
    Port ( 
        clk          : in std_logic; 
        reset        : in std_logic; 
        
        R            : in std_logic_vector(7 downto 0); 
        G            : in std_logic_vector(7 downto 0); 
        B            : in std_logic_vector(7 downto 0);
         
        p_valid      : in std_logic; 
        i_valid      : in std_logic; 
        
        start        : in std_logic; 
        quant_block  : in block8x8; 
        -- start : in std_logic; 
        block_in     : in block64; 
        -- stream_out : out std_logic_vector(255 downto 0); 
        -- valid : out std_logic; 
        -- finish : out std_logic; 
        
        zigzag_valid : out std_logic; 
        done         : out std_logic; 
        zigzag_out   : out block64 
    );
end top_module_jpeg_compression;

architecture rtl of top_module_jpeg_compression is

    signal Y            : std_logic_vector(7 downto 0); 
    signal pixel_out    : std_logic_vector(7 downto 0); 
    signal pixel_valid  : std_logic; 
    signal dct_start    : std_logic := '0'; 
    signal dct_coeff    : std_logic_vector(15 downto 0); 
    signal coeff_u      : std_logic_vector(2 downto 0); 
    signal coeff_v      : std_logic_vector(2 downto 0); 
    signal coeff_valid  : std_logic; 
    -- signal zigzag_valid: std_logic; 
    signal quant_valid  : std_logic; 
    signal quant_out    : std_logic_vector(15 downto 0); 
    -- signal quant_coeff : std_logic_vector(15 downto 0); 
    signal block_out    : block8x8; 
    -- signal done : std_logic; 
    signal block_ready  : std_logic; 
    -- signal zigzag_out : block64;
    
    component quantization 
    Port ( 
        clk         : in std_logic; 
        reset       : in std_logic;
         
        dct_in      : in std_logic_vector(15 downto 0); 
        u_dct       : in std_logic_vector(2 downto 0); 
        v_dct       : in std_logic_vector(2 downto 0); 
        in_valid    : in std_logic; 
        
        out_valid   : out std_logic; 
        quant_out   : out std_logic_vector(15 downto 0) 
    ); 
    end component;
    
    component zigzag_encoding 
    Port ( 
        clk             : in std_logic; 
        reset           : in std_logic; 
        
        start           : in std_logic; 
        quant_block     : in block8x8; 
        
        zigzag_valid    : out std_logic; 
        done            : out std_logic; 
        zigzag_out      : out block64 
    ); 
    end component;
    
    component quant_block_buf
    port (
      clk         : in std_logic;
      reset       : in std_logic;
      
      quant_in    : in std_logic_vector(15 downto 0);
      u_in        : in std_logic_vector(2 downto 0);
      v_in        : in std_logic_vector(2 downto 0);
      in_valid    : in std_logic;
      
      block_out   : out block8x8;
      block_valid : out std_logic
    );
  end component;
  
  -- component huffman_coding 
  -- Port (
    -- clk : in std_logic; 
    -- reset : in std_logic; 
    -- start : in std_logic; 
    -- block_in : in block64; 
    -- stream_out : out std_logic_vector(255 downto 0); 
    -- valid : out std_logic; 
    -- finish : out std_logic 
  -- ); 
  -- end component;

begin

    U_CONV : entity work.rgb_to_ycbcr_converter
    port map (
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
      DATA_WIDTH  => DATA_WIDTH,
      LINE_LENGTH => LINE_LENGTH
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
      clk          => clk,
      reset        => reset,
      pixel_in     => pixel_out,
      pixel_valid  => pixel_valid,
      dct_coeff    => dct_coeff,
      coeff_u      => coeff_u,
      coeff_v      => coeff_v,
      coeff_valid  => coeff_valid
    );
    
    U_QUANT : quantization
    port map (
      clk        => clk,
      reset      => reset,
      dct_in     => dct_coeff,
      u_dct      => coeff_u,
      v_dct      => coeff_v,
      in_valid   => coeff_valid,
      out_valid  => quant_valid,
      quant_out  => quant_out
    );
    
    U_QBUF : quant_block_buf
    port map (
      clk         => clk,
      reset       => reset,
      quant_in    => quant_out,
      u_in        => coeff_u,
      v_in        => coeff_v,
      in_valid    => quant_valid,
      block_out   => block_out,
      block_valid => block_ready
    );
    
    U_ZIGZAG : zigzag_encoding
    port map (
      clk          => clk,
      reset        => reset,
      start        => block_ready,
      quant_block  => block_out,
      zigzag_valid => zigzag_valid,
      done         => done,
      zigzag_out   => zigzag_out
    );
    
    -- U_HUFFMANCODING: huffman_coding 
    -- port map( 
        -- clk => clk, 
        -- reset => reset, 
        -- start => done, 
        -- block_in => zigzag_out, 
        -- stream_out => stream_out, 
        -- valid => valid, 
        -- finish => finish 
    -- );

end rtl;
