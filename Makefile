##############
# Shell Setup
##############
.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -euox pipefail -c

#############################
# Path And Environment Setup
#############################
WORKSPACE := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
INSTALL_DIR := $(WORKSPACE)/install
SRC_DIR := $(WORKSPACE)/src

export PKG_CONFIG_PATH := $(INSTALL_DIR)/lib/pkgconfig:$(INSTALL_DIR)/share/pkgconfig:$(PKG_CONFIG_PATH)
export CMAKE_PREFIX_PATH := $(INSTALL_DIR):$(CMAKE_PREFIX_PATH)
export LD_LIBRARY_PATH := $(INSTALL_DIR)/lib:$(INSTALL_DIR)/lib64:$(LD_LIBRARY_PATH)
export PATH := $(INSTALL_DIR)/bin:$(PATH)

DEPS := hyprwayland-scanner hyprutils hyprgraphics hyprcursor hyprwire hyprland-qtutils aquamarine

.PHONY: all sync build deps hyprland clean $(DEPS)

####################
# Top Level Targets
####################
all: sync build

build: deps hyprland

############################
# Submodule Synchronization
############################
sync:
	@echo "=========================================="
	@echo " Initializing And Updating Git Submodules "
	@echo "=========================================="

	git submodule update --init --recursive

	@echo "========================================"
	@echo " SUBMODULE SYNCHRONIZATION COMPLETE !!! "
	@echo "========================================"

#########################
# Dependency Compilation
#########################
hyprgraphics: hyprutils

hyprcursor: hyprutils

hyprwire: hyprutils

hyprland-qtutils: hyprutils

aquamarine: hyprwayland-scanner hyprutils

deps: $(DEPS)

$(DEPS):
	@echo "==============================================="
	@echo " Building Dependency: $@                       "
	@echo "==============================================="

	mkdir -p "$(INSTALL_DIR)"
	cd "$(SRC_DIR)/$@"

	cmake -S . -B build/ -G Ninja \
		-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
		-DCMAKE_BUILD_TYPE=Debug \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON

	ninja -C build/
	ninja -C build/ install

	@echo "============================================================"
	@echo " BUILD COMPLETE SUCCESSFULLY !!!                            "
	@echo " Nested Library At: $(INSTALL_DIR)/                         "
	@echo "============================================================"

#######################
# Hyprland Compilation
#######################
hyprland: deps
	@echo "==================="
	@echo " Building Hyprland "
	@echo "==================="

	@mkdir -p "$(INSTALL_DIR)"
	cd "$(SRC_DIR)/hyprland"

	cmake -S . -B build/ -G Ninja \
		-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
		-DCMAKE_BUILD_TYPE=Debug \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON

	ninja -C build/

	@echo "============================================================"
	@echo " BUILD COMPLETE SUCCESSFULLY !!!                            "
	@echo " Nested Binary At: $(SRC_DIR)/hyprland/build/Hyprland       "
	@echo "============================================================"

############################
# Build And Install Cleanup
############################
clean:
	@echo "======================================"
	@echo " Cleaning Build And Install Artifacts "
	@echo "======================================"

	rm -rf "$(INSTALL_DIR)"
	for dep in $(DEPS) hyprland; do
		rm -rf "$(SRC_DIR)/$$dep/build";
	done

	@echo "======================"
	@echo " CLEANUP COMPLETE !!! "
	@echo "======================"
