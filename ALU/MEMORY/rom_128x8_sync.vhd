library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_128x8_sync is
    port (
        address  : in  STD_LOGIC_VECTOR(6 downto 0);  -- 128 posiciones
        clock    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end rom_128x8_sync;

architecture archrom of rom_128x8_sync is
    type rom_type is array (0 to 127) of STD_LOGIC_VECTOR(7 downto 0);
    constant ROM_MEM : rom_type := (
        0  => x"00",
        1  => x"11",
        2  => x"22",
		  3  => x"33",
        4  => x"44",
		  5  => x"55",
		  6  => x"66",
		  7  => x"77",
		  8  => x"88",
		  9  => x"99",
		  10  => x"AA",
		  11  => x"BB",
        others => x"00"
    );
begin
    process(clock)
    begin
        if rising_edge(clock) then
            data_out <= ROM_MEM(to_integer(unsigned(address)));
        end if;
    end process;
end archrom;