# My Golang Application Standard Makefile

SHELL:=/bin/bash
BASE_PATH:=$(shell dirname $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
BUILD_PATH:=$(BASE_PATH)/build

TITLE:=$(shell basename $(BASE_PATH))
VCS_INFO:=$(shell $(BUILD_PATH)/script/shell/vcs.sh)
BUILD_TIME:=$(shell date +%Y-%m-%d--%T)
APP_PKG:=$(shell $(BUILD_PATH)/script/shell/apppkg.sh)
ARES:=$(APP_PKG)/vendor/github.com/sevenNt/ares/application
LDFLAGS:="-X $(ARES).vcsInfo=$(VCS_INFO) -X $(ARES).buildTime=$(BUILD_TIME) -X $(ARES).name=$(APP_NAME) -X $(ARES).id=$(APP_ID)"

#all:print build zip
#alltar:print build tar
all:print fmt lint vet test build tar

print:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making print<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@echo SHELL:$(SHELL)
	@echo BASE_PATH:$(BASE_PATH)
	@echo BUILD_PATH:$(BUILD_PATH)
	@echo TITLE:$(TITLE)
	@echo VCS_INFO:$(VCS_INFO)
	@echo BUILD_TIME:$(BUILD_TIME)
	@echo APP_PKG:$(APP_PKG)
	@echo ARES:$(ARES)
	@echo BINS:$(BINS)
	@echo APP_NAME:$(APP_NAME)
	@echo LDFLAGS:$(LDFLAGS)
	@echo -e "\n"

fmt:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making fmt<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	go fmt $(TITLE)/app/...
	go fmt $(TITLE)/agent/...
	@echo -e "\n"

lint:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making lint<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@OUT=`$(GOPATH)/bin/golint $(BASE_PATH)/app/... | grep -v pb.go`;\
	if [ "$$OUT" != "" ]; then\
		echo $$OUT;\
		exit 1;\
	else\
		echo "lint success";\
	fi
	@echo -e "\n"

vet:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making vet<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@# 此处要加"2>&1"否则VETOUT变量获取不到vet输出信息
	@VETOUT=`go vet -v $(TITLE)/app/... 2>&1`;\
	if [ "$$VETOUT" != "" ]; then\
		echo $$VETOUT;\
		exit 1;\
	else\
		echo "vet success";\
	fi
	@echo -e "\n"

test:

build:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making build<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	chmod +x $(BUILD_PATH)/script/shell/*.sh
	$(BUILD_PATH)/script/shell/build.sh $(LDFLAGS) $(BINS)
	@echo -e "\n"

tar:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making tar<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	$(eval TAR=$(BASE_PATH)/$(TITLE)_$(VCS_INFO).tar.gz)
	@cd $(BASE_PATH) && tar zcf $(TAR) bin config build Gopkg.* >/dev/null
	@echo $(TAR)
	@echo -e "\n"

zip:
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>making zip<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@ZIP=`cd $(BASE_PATH) && zip -r $(PUB_ZIP) bin config build Gopkg.* >/dev/null`
	@if [ "$(PUB_ZIP)" == "" ]; then\
		echo "no pub zip";\
	else\
		echo $$ZIP;\
	fi
	@echo $(PUB_ZIP)
	@echo -e "\n"

