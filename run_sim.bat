@echo off
echo ============================================================
echo Compiling 5-Stage Pipelined RISC-V Processor
echo ============================================================

iverilog -o pipeline_sim.vvp ^
alu_full.v ^
reg_file.v ^
ctrl_main.v ^
ctrl_alu.v ^
ctrl_unit.v ^
sign_ext.v ^
branch_comp.v ^
hazard_unit.v ^
stage_if.v ^
stage_id.v ^
stage_ex.v ^
stage_mem.v ^
stage_wb.v ^
pipeline_top.v ^
tb_pipeline.v

if errorlevel 1 (
    echo Compilation FAILED!
    pause
    exit /b 1
)

echo Compilation SUCCESSFUL!
echo.
echo Running simulation...
vvp pipeline_sim.vvp

echo.
echo Opening GTKWave...
gtkwave pipeline_waves.vcd

pause