#!/usr/bin/env bash
set -e

echo "1. Компіляція та симуляція VHDL (GHDL)"
ghdl -a --std=08 uart_tx.vhd uart_rx.vhd uart_top.vhd uart_tb.vhd
ghdl -e --std=08 uart_tb
ghdl -r --std=08 uart_tb --vcd=wave.vcd --stop-time=2ms

echo "2. Синтез проєкту для ПЛІС та підрахунок LUT / Flip-Flops"
ghdl --synth --std=08 --out=verilog uart_tx.vhd uart_rx.vhd uart_top.vhd -e uart_top > uart_synth.v
yosys -q -p "read_verilog uart_synth.v; synth_ice40 -top uart_top -json uart_synth.json; stat" > resources.txt

echo "3. Часовий аналіз (Timing Analysis, Fmax)"
nextpnr-ice40 --hx8k --package ct256 --json uart_synth.json --asc uart_routed.asc > timing.txt 2>&1

# Прибираємо проміжні службові файли, щоб папка залишалася чистою
rm -f *.cf uart_synth.v uart_synth.json uart_routed.asc

echo "Готово! Створено файли: wave.vcd, resources.txt, timing.txt"