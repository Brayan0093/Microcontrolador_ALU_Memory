library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port(
        A     : in  std_logic_vector(7 downto 0);
        B     : in  std_logic_vector(7 downto 0);
        Sel   : in  std_logic;
        Y     : out std_logic_vector(7 downto 0);
        Carry : out std_logic;
        Ovf   : out std_logic;
        Neg   : out std_logic;
        Zero  : out std_logic
    );
end entity ALU;

architecture ARCH_ALU of ALU is
begin
    process(Sel, A, B)
        variable A_ext     : unsigned(8 downto 0);
        variable B_ext     : unsigned(8 downto 0);
        variable result_9  : unsigned(8 downto 0);
        variable Y_int     : std_logic_vector(7 downto 0);
        variable ovf_flag  : std_logic;
        variable zero_flag : std_logic;
        variable neg_flag  : std_logic;  -- NUEVA variable
    begin
        -- 1. Extender operandos
        A_ext := "0" & unsigned(A);
        B_ext := "0" & unsigned(B);

        -- 2. Operación aritmética
        if Sel = '0' then
            result_9 := A_ext + B_ext;
        else
            result_9 := A_ext - B_ext;
        end if;

        -- 3. Resultado (8 bits bajos)
        Y_int := std_logic_vector(result_9(7 downto 0));

        -- 4. Carry: solo aplica en suma
        if Sel = '0' then
            Carry <= result_9(8);
        else
            Carry <= '0';
        end if;

        -- 5. Overflow
        --    Suma: resultado supera 255 (bit 8 = 1)
        --    Resta: B > A (resultado negativo, underflow)
        if Sel = '0' then
            ovf_flag := result_9(8);         -- mismo que Carry en suma
        else
            if unsigned(B) > unsigned(A) then
                ovf_flag := '1';
            else
                ovf_flag := '0';
            end if;
        end if;

        -- 6. Zero
        if Y_int = x"00" then
            zero_flag := '1';
        else
            zero_flag := '0';
        end if;

        -- 7. Neg: M
         if unsigned(B) > unsigned(A) then
                neg_flag  := '1';
            else
                neg_flag  := '0';
            end if;

        -- 8. Asignar salidas
        Y    <= Y_int;
        Ovf  <= ovf_flag;
        Zero <= zero_flag;
        Neg  <= neg_flag;   -- CORREGIDO: era ovf_flag por error
    end process;
end architecture ARCH_ALU;