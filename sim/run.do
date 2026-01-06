# Usage: do run <type> <width>
# Example: do run array 8
# Example: do run tree 16


# 1. Argument Parsing

# Check for Argument 1: Architecture Type (Default: array)
if { [info exists 1] } {
    set TYPE $1
} else {
    set TYPE "array"
}

# Check for Argument 2: Bit Width (Default: 8)
if { [info exists 2] } {
    set WIDTH $2
} else {
    set WIDTH 8
}


echo "Running Simulation for: #WIDTH-bit $TYPE multiplier"
flush stdout


  
# 2. Clean and Create Library

if {[file exists work]} {vdel -lib work -all}
vlib work



# 3. Compile Shared Files (Interface & TB)

echo "Compiling Shared Testbench Files..."
vlog -sv ../rtl/top_if.sv

# Compile the Package
vlog -sv +incdir+../tb ../tb/multiplier_pkg.sv

# Compile your Testbench
vlog -sv ../tb/tb_top.sv



# 4. Compile Specific Design

if {$TYPE == "array"} {
    echo "Compiling ARRAY Multiplier Source Files..."
    # Array dependencies
    vlog -sv ../rtl/array/full_adder.sv
    vlog -sv ../rtl/array/n_bit_adder.sv
    vlog -sv ../rtl/array/array_mult.sv
    # Array Wrapper
    vlog -sv ../rtl/array/top.sv

} elseif {$TYPE == "tree"} {
    echo "Compiling ADDER TREE Multiplier Source Files..."
    # Tree dependencies
    vlog -sv ../rtl/tree/adder_tree_mult.sv
    # Tree Wrapper
    vlog -sv ../rtl/tree/top.sv

} else {
    echo "ERROR: Unknown architecture type '$TYPE'. Please use 'array' or 'tree'."
    return
}



# 5. Load Simulation

vsim -voptargs=+acc -GN=$WIDTH work.tb_top


  
# 6. Setup Waves and Run

add wave -position insertpoint sim:/tb_top/intf/*
run -all
