#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SCRIPT_DIR" || exit 1

arquivo="$SCRIPT_DIR/Set_Modelo_paraVCD.tcl"
arquivo_TCL="$SCRIPT_DIR/Set_multiplicador.tcl"
pasta="$ROOT_DIR"
ORIGEM="$SCRIPT_DIR"
LATENCY=1
TOPLEVEL="${1:-fft16_hls}"

if [ ! -f "$arquivo" ]; then
    echo "ERRO: TCL principal n�o encontrado: $arquivo"
    exit 1
fi

if [ ! -f "$arquivo_TCL" ]; then
    echo "ERRO: TCL p�s-VCD n�o encontrado: $arquivo_TCL"
    exit 1
fi

if [ ! -f "gera_tb_generico.py" ]; then
    echo "ERRO: gera_tb_generico.py n�o encontrado."
    exit 1
fi

chmod +x gera_tb_generico.py

for arquivo_vhd in "$pasta/${TOPLEVEL}.vhd"; do

    if [ ! -f "$arquivo_vhd" ]; then
        echo "ERRO: arquivo VHDL nao encontrado: $arquivo_vhd"
        exit 1
    fi

    nome_arquivo=$(basename "$arquivo_vhd")
    design="${nome_arquivo%.vhd}"

    echo "=========================================="
    echo "Processando design: $design"
    echo "=========================================="

    DESTINO="$ORIGEM/$design"
    mkdir -p "$DESTINO"

    rm -f saida_*.txt
    rm -f filtros.vcd
    rm -f testbench_auto.v
    rm -f xrun.log
    rm -f genus.log
    rm -f sdf.log

    sed -i -E "s/^[[:space:]]*set[[:space:]]+DESIGN[[:space:]].*/set DESIGN $design/" "$arquivo"
    sed -i -E "s/^[[:space:]]*set[[:space:]]+DESIGN[[:space:]].*/set DESIGN $design/" "$arquivo_TCL"

    echo "DESIGN no TCL principal:"
    grep -n "set DESIGN" "$arquivo"

    echo "DESIGN no TCL pos-VCD:"
    grep -n "set DESIGN" "$arquivo_TCL"

    echo "Gerando testbench automatico..."
    python3 gera_tb_generico.py "$arquivo_vhd" "$LATENCY"

    if [ ! -f testbench_auto.v ]; then
        echo "ERRO: testbench_auto.v nao foi gerado para $design"
        continue
    fi

    cp testbench_auto.v "$DESTINO/testbench_${design}.v"

    echo "Executando sintese inicial no Genus..."
    genus -legacy_ui -files "$arquivo" | tee "$DESTINO/genus_pre_vcd_${design}.log"

    if [ ! -f "${design}_martool.v" ]; then
        echo "ERRO: ${design}_martool.v nao foi gerado."
        echo "Pulando simulacao para $design."
        continue
    fi

    echo "Compilando SDF..."
    if [ -f barreira.sdf ]; then
        ncsdfc barreira.sdf | tee "$DESTINO/ncsdfc_${design}.log"
    else
        echo "ATENCAO: barreira.sdf nao encontrado."
    fi

    echo "Executando simulacao no Xcelium..."
    xrun -64bit \
        -top testbench_auto \
        testbench_auto.v \
        CORE65LPSVT.v \
        "${design}_martool.v" \
        -access +rw \
        -sdf_cmd_file sdf_cmd_file.in \
        | tee "$DESTINO/xrun_${design}.log"

    if ls saida_*.txt >/dev/null 2>&1; then
        mv saida_*.txt "$DESTINO/"
        echo "Arquivos saida_*.txt movidos para $DESTINO"
    else
        echo "ATENCAO: nenhum arquivo saida_*.txt foi gerado para $design"
    fi

    if [ -f filtros.vcd ]; then
        mv filtros.vcd "$DESTINO/"
        echo "Arquivo filtros.vcd movido para $DESTINO"
    else
        echo "ATENCAO: filtros.vcd nao foi gerado para $design"
    fi

    if [ -f sdf.log ]; then
        mv sdf.log "$DESTINO/sdf_${design}.log"
    fi

    echo "Executando sintese pos-VCD no Genus..."
    genus -legacy_ui -files "$arquivo_TCL" | tee "$DESTINO/genus_pos_vcd_${design}.log"

    echo "Processo concluido para: $design"
    echo ""

done