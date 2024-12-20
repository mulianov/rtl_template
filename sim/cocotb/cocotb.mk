COCOTB_BUILD_DIR = $(CUR_DIR)/build/cocotb
COCOTB_SRC_DIR = $(CUR_DIR)/sim/cocotb

.EXPORT_ALL_VARIABLES:
PYTHONPYCACHEPREFIX=$(COCOTB_BUILD_DIR)

cocotb.tb:
	mkdir -p $(COCOTB_BUILD_DIR)
	cd $(COCOTB_BUILD_DIR); python3 -m pytest $(COCOTB_SRC_DIR)

cocotb.clean:
	rm -rf $(COCOTB_BUILD_DIR)
