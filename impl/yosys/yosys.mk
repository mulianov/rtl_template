YOSYS_BUILD_DIR = $(CUR_DIR)/build/yosys

# hierarchy_opts = -top $(top_module)
#-p "proc; opt; memory; opt; fsm; opt" \

yosys.elaborate:
	mkdir -p $(YOSYS_BUILD_DIR)
	cd $(YOSYS_BUILD_DIR); yosys -p "plugin -i slang" \
		-p "read_slang $(RTL_SOURCES)" \
		-p "show -colors 42 -stretch -format svg -prefix $(top_module)_elab show top"

yosys.synth:
	mkdir -p $(YOSYS_BUILD_DIR)
	cd $(YOSYS_BUILD_DIR); yosys -p "plugin -i slang" \
		-p "read_slang $(RTL_SOURCES)" \
		-p "synth_xilinx -family xc7 -top $(top_module) -flatten" \
		-p "write_json $(top_module)_synth.json"; \
		netlistsvg -o $(top_module)_synth.svg $(top_module)_synth.json

yosys.clean:
	rm -rf $(YOSYS_BUILD_DIR)
