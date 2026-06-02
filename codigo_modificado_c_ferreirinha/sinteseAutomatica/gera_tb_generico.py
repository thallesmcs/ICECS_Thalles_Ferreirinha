#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import sys
from pathlib import Path

CLK_NAMES = {"clk", "clock", "ap_clk"}
RST_NAMES = {"rst", "reset", "reset_n", "rst_n", "ap_rst", "ap_rst_n"}

def remove_comments(text):
    return re.sub(r"--.*", "", text)

def find_balanced_block(text, keyword):
    m = re.search(keyword + r"\s*\(", text, re.IGNORECASE)
    if not m:
        return None

    start = text.find("(", m.start())
    depth = 0

    for i in range(start, len(text)):
        if text[i] == "(":
            depth += 1
        elif text[i] == ")":
            depth -= 1
            if depth == 0:
                return text[start + 1:i]

    return None

def parse_generics(text):
    generics = {}
    block = find_balanced_block(text, r"generic")

    if not block:
        return generics

    for item in block.split(";"):
        item = item.strip()

        m = re.match(
            r"(\w+)\s*:\s*\w+\s*:=\s*(\d+)",
            item,
            re.IGNORECASE
        )

        if m:
            generics[m.group(1).lower()] = int(m.group(2))

    return generics

def eval_expr(expr, generics):
    expr = expr.strip().lower()

    for name, value in generics.items():
        expr = re.sub(r"\b" + re.escape(name) + r"\b", str(value), expr)

    if not re.fullmatch(r"[0-9+\-*/()\s]+", expr):
        return None

    try:
        return int(eval(expr, {"__builtins__": None}, {}))
    except Exception:
        return None

def get_width(vtype, generics):
    t = vtype.lower()
    t = re.sub(r"\s+", " ", t)

    m = re.search(
        r"(std_logic_vector|signed|unsigned)\s*\(\s*(.*?)\s+downto\s+(.*?)\s*\)",
        t,
        re.IGNORECASE
    )

    if m:
        left = eval_expr(m.group(2), generics)
        right = eval_expr(m.group(3), generics)

        if left is not None and right is not None:
            return abs(left - right) + 1

    m = re.search(
        r"(std_logic_vector|signed|unsigned)\s*\(\s*(.*?)\s+to\s+(.*?)\s*\)",
        t,
        re.IGNORECASE
    )

    if m:
        left = eval_expr(m.group(2), generics)
        right = eval_expr(m.group(3), generics)

        if left is not None and right is not None:
            return abs(left - right) + 1

    if re.search(r"\bstd_logic\b", t):
        return 1

    return 1

def parse_entity(vhdl_file):
    text = Path(vhdl_file).read_text(encoding="utf-8", errors="ignore")
    text = remove_comments(text)

    ent = re.search(r"entity\s+(\w+)\s+is", text, re.IGNORECASE)

    if not ent:
        raise RuntimeError("Entidade VHDL nao encontrada.")

    entity = ent.group(1)
    generics = parse_generics(text)

    port_block = find_balanced_block(text, r"port")

    if not port_block:
        raise RuntimeError("Bloco port nao encontrado.")

    ports = []

    for item in port_block.split(";"):
        item = item.strip()

        if not item:
            continue

        m = re.match(
            r"([\w\s,]+)\s*:\s*(in|out|inout|buffer)\s+(.+)",
            item,
            re.IGNORECASE | re.DOTALL
        )

        if not m:
            continue

        names = [x.strip() for x in m.group(1).split(",")]
        direction = m.group(2).lower()
        vtype = m.group(3).strip()
        width = get_width(vtype, generics)

        if direction == "buffer":
            direction = "out"

        for name in names:
            ports.append({
                "name": name,
                "direction": direction,
                "width": width
            })

    return entity, ports

def decl_signal(port):
    kind = "reg" if port["direction"] in {"in", "inout"} else "wire"

    if port["width"] == 1:
        return f"  {kind} {port['name']};"

    return f"  {kind} [{port['width'] - 1}:0] {port['name']};"

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 gera_tb_generico.py arquivo.vhd [latency]")
        sys.exit(1)

    vhdl_file = sys.argv[1]
    latency = int(sys.argv[2]) if len(sys.argv) > 2 else 1

    entity, ports = parse_entity(vhdl_file)

    inputs = [p for p in ports if p["direction"] in {"in", "inout"}]
    outputs = [p for p in ports if p["direction"] == "out"]

    clk = next(
        (p["name"] for p in inputs if p["name"].lower() in CLK_NAMES),
        None
    )

    rst_ports = [
        p for p in inputs
        if p["name"].lower() in RST_NAMES
    ]

    data_inputs = [
        p for p in inputs
        if p["name"].lower() not in CLK_NAMES
        and p["name"].lower() not in RST_NAMES
    ]

    max_width = max([p["width"] for p in data_inputs], default=1)

    num_samples = min((2 ** max_width) - 1, 1000)

    tb = []

    tb.append("`timescale 1ns/1ps")
    tb.append("")
    tb.append("module testbench_auto;")
    tb.append("")
    tb.append(f"  localparam integer LATENCY = {latency};")
    tb.append(f"  localparam integer NUM_SAMPLES = {num_samples};")
    tb.append("")
    tb.append("  integer i;")

    for p in outputs:
        tb.append(f"  integer f_{p['name']};")

    tb.append("")

    for p in ports:
        tb.append(decl_signal(p))

    tb.append("")
    tb.append(f"  {entity} uut (")
    tb.append(",\n".join([f"    .{p['name']}({p['name']})" for p in ports]))
    tb.append("  );")
    tb.append("")

    if clk:
        tb.append(f"  always #10 {clk} = ~{clk};")
        tb.append("")

    tb.append("  initial begin")

    for p in inputs:
        name = p["name"]
        lname = name.lower()

        if lname in CLK_NAMES:
            tb.append(f"    {name} = 0;")
        elif lname in RST_NAMES:
            if lname.endswith("_n"):
                tb.append(f"    {name} = 0;")
            else:
                tb.append(f"    {name} = 1;")
        else:
            tb.append(f"    {name} = 0;")

    tb.append("")

    for p in outputs:
        tb.append(f'    f_{p["name"]} = $fopen("saida_{p["name"]}.txt","w");')

    tb.append("")
    tb.append('    $dumpfile("filtros.vcd");')
    tb.append("    $dumpvars(0, testbench_auto);")
    tb.append("")

    if clk:
        for p in rst_ports:
            lname = p["name"].lower()
            tb.append(f"    repeat(2) @(posedge {clk});")

            if lname.endswith("_n"):
                tb.append(f"    {p['name']} = 1;")
            else:
                tb.append(f"    {p['name']} = 0;")

        tb.append(f"    repeat(2) @(posedge {clk});")
    else:
        tb.append("    #20;")

    tb.append("")
    tb.append("    for(i=1;i<=NUM_SAMPLES;i=i+1) begin")

    for idx, p in enumerate(data_inputs):
        tb.append(f"      {p['name']} = i[{p['width'] - 1}:0] + {idx};")

    if clk:
        tb.append(f"      @(posedge {clk});")
        tb.append(f"      repeat(LATENCY) @(posedge {clk});")
    else:
        tb.append("      #20;")

    for p in outputs:
        tb.append(f'      $fwrite(f_{p["name"]}, "%b\\n", {p["name"]});')

    tb.append("    end")
    tb.append("")

    for p in outputs:
        tb.append(f"    $fclose(f_{p['name']});")

    tb.append("    $finish;")
    tb.append("  end")
    tb.append("")
    tb.append("endmodule")
    tb.append("")

    Path("testbench_auto.v").write_text("\n".join(tb), encoding="utf-8")

    print("Testbench gerado.")
    print("Entidade:", entity)
    print("Portas detectadas:")

    for p in ports:
        print(f"  {p['name']} {p['direction']} width={p['width']}")

if __name__ == "__main__":
    main()