from pathlib import Path
import numpy as np
import pandas as pd

BASE_DIR = Path(r"F:/github_projects/codigo_modificado_c_ferreirinha")
INPUT_DIR = BASE_DIR / "entradas_tb" / "inputs"

# Ajuste se seus arquivos estiverem como input_0r.txt, sem "s".
PREFIX = "inputs_"

NUM_POINTS = 16
NUM_FRAMES_TO_CHECK = 3

# CSV gerado pelo testbench HLS, no formato:
# frame,k,outRe_hex,outIm_hex
HLS_CSV = BASE_DIR / "fft16_hls_outputs.csv"


def bin_to_signed(value: str, bits: int = 16) -> int:
    """
    Converte string binária em inteiro com sinal.
    Exemplo:
    0000000000000001 -> 1
    1111111111111111 -> -1
    """
    value = value.strip()

    # Alguns arquivos podem ter 15 bits quando o valor é zero.
    # Nesse caso, completa à esquerda com zeros.
    value = value.zfill(bits)

    unsigned = int(value, 2)
    if unsigned >= (1 << (bits - 1)):
        unsigned -= (1 << bits)
    return unsigned


def signed_to_hex16(value: int) -> str:
    """
    Converte inteiro com sinal para hexadecimal de 16 bits.
    """
    return f"{value & 0xFFFF:04X}"


def read_sample(point: int, part: str, frame: int) -> int:
    """
    Lê uma amostra de um arquivo:
    inputs_0r.txt, inputs_0i.txt, ..., inputs_15r.txt, inputs_15i.txt
    """
    filename = INPUT_DIR / f"{PREFIX}{point}{part}.txt"

    with open(filename, "r", encoding="utf-8") as f:
        lines = f.readlines()

    raw = lines[frame].strip()
    return bin_to_signed(raw, bits=16)


def read_frame(frame: int):
    """
    Monta um frame completo da FFT:
    Xr[0..15] e Xi[0..15]
    """
    xr = np.array([read_sample(k, "r", frame) for k in range(NUM_POINTS)], dtype=float)
    xi = np.array([read_sample(k, "i", frame) for k in range(NUM_POINTS)], dtype=float)
    x = xr + 1j * xi
    return xr, xi, x


def calculate_fft_reference(x):
    """
    Calcula FFT matemática de referência.
    Arredonda para inteiro para facilitar comparação com hardware.
    """
    y = np.fft.fft(x, n=NUM_POINTS)
    re = np.rint(y.real).astype(int)
    im = np.rint(y.imag).astype(int)
    return re, im


def load_hls_csv():
    if not HLS_CSV.exists():
        print(f"CSV do HLS não encontrado: {HLS_CSV}")
        return None

    df = pd.read_csv(HLS_CSV)

    # Normaliza hexadecimal para maiúsculo.
    df["outRe_hex"] = df["outRe_hex"].astype(str).str.upper().str.zfill(4)
    df["outIm_hex"] = df["outIm_hex"].astype(str).str.upper().str.zfill(4)

    return df


def hex16_to_signed(hex_value: str) -> int:
    unsigned = int(hex_value, 16)
    if unsigned >= 0x8000:
        unsigned -= 0x10000
    return unsigned


def main():
    hls_df = load_hls_csv()

    rows = []

    for frame in range(NUM_FRAMES_TO_CHECK):
        xr, xi, x = read_frame(frame)
        ref_re, ref_im = calculate_fft_reference(x)

        print(f"\n===== FRAME {frame} =====")
        print("Xr:", [int(v) for v in xr])
        print("Xi:", [int(v) for v in xi])
        print("Soma Xr / DC real esperado:", int(np.sum(xr)))
        print("Soma Xi / DC imag esperado:", int(np.sum(xi)))

        for k in range(NUM_POINTS):
            ref_re_hex = signed_to_hex16(ref_re[k])
            ref_im_hex = signed_to_hex16(ref_im[k])

            hls_re_hex = None
            hls_im_hex = None
            hls_re_int = None
            hls_im_int = None

            if hls_df is not None:
                match = hls_df[(hls_df["frame"] == frame) & (hls_df["k"] == k)]
                if not match.empty:
                    hls_re_hex = match.iloc[0]["outRe_hex"]
                    hls_im_hex = match.iloc[0]["outIm_hex"]
                    hls_re_int = hex16_to_signed(hls_re_hex)
                    hls_im_int = hex16_to_signed(hls_im_hex)

            rows.append({
                "frame": frame,
                "k": k,
                "python_re_int": int(ref_re[k]),
                "python_im_int": int(ref_im[k]),
                "python_re_hex": ref_re_hex,
                "python_im_hex": ref_im_hex,
                "hls_re_int": hls_re_int,
                "hls_im_int": hls_im_int,
                "hls_re_hex": hls_re_hex,
                "hls_im_hex": hls_im_hex,
                "diff_re": None if hls_re_int is None else hls_re_int - int(ref_re[k]),
                "diff_im": None if hls_im_int is None else hls_im_int - int(ref_im[k]),
            })

    result_df = pd.DataFrame(rows)

    output_csv = BASE_DIR / "fft_python_vs_hls_3frames.csv"
    result_df.to_csv(output_csv, index=False)

    print(f"\nArquivo gerado: {output_csv}")
    print("\nPrimeiras linhas da comparação:")
    print(result_df.head(20).to_string(index=False))


if __name__ == "__main__":
    main()