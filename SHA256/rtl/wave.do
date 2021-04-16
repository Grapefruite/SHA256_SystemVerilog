onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sha_top_tb/FINISH_FLAG
add wave -noupdate /sha_top_tb/Hash
add wave -noupdate /sha_top_tb/hash
add wave -noupdate /sha_top_tb/clk
add wave -noupdate /sha_top_tb/rst
add wave -noupdate /sha_top_tb/stop_sig
add wave -noupdate /sha_top_tb/st_tra
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -radix decimal /sha_top_tb/dut_sha_top/dut_data_preprocess/len
add wave -noupdate -radix decimal /sha_top_tb/dut_sha_top/dut_data_preprocess/len_frame
add wave -noupdate -radix decimal /sha_top_tb/dut_sha_top/dut_data_preprocess/len_rawdata
add wave -noupdate /sha_top_tb/dut_sha_top/dut_data_preprocess/st_pad
add wave -noupdate /sha_top_tb/dut_sha_top/dut_data_preprocess/st_pad1
add wave -noupdate /sha_top_tb/dut_sha_top/dut_data_preprocess/tra_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3596800 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 355
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10500 ns}
