#########################################################################
# Simple makefile for Roku app use
#
# Makefile Usage:
# > make
# > make install
# > make remove
#
# Makefile Less Common Usage:
# > make art-opt
# > make pkg
# > make install_native
# > make remove_native
# > make tr
#
#
# Important Notes:
# To use the "install" and "remove" targets to install your
# application directly from the shell, you must do the following:
#
# 1) Make sure that you have the curl command line executable in your path
# 2) Set the variable ROKU_DEV_TARGET in your environment to the IP
#    address of your Roku box. (e.g. export ROKU_DEV_TARGET=192.168.1.1.
#    Set in your this variable in your shell startup (e.g. .bashrc)
# 3) Set ROKU_DEVPASSWORD to roku dev sideload password
# 4) Set ROKU_DEVID to the generated Roku Dev ID (for keyed boxes)
# 5) Set ROKU_PKG_PASSWORD to the Roku Dev Password (for keyed boxes)
##########################################################################
APPNAME = Requests
VERSION = 0.1.0

ZIP_EXCLUDE = -x .\* -x \*\# -x xml/* -x artwork/* -x \*.pkg -x *.md -x storeassets\* -x keys\* -x README* -x CHANGELOG* -x LICENSE -x VERSION-x requirements* -x apps\* -x app.mk -x dist\* -x *.py -x *.DS_Store
TEST_MAX_RUN = 3
include ./app.mk

# Smash the library down to one file
BLANK_LINES_RE="/^[ \t]*'.*/d"
COMMENT_LINES_RE="/^[ ]*$$/d"
LEADING_WHITESPACE_RE="s/^[ \t]*//"

.PHONY: dist
dist:
	@if [ ! -d $(DISTREL) ]; \
	then \
		mkdir -p $(DISTREL); \
	fi
	sed "s/^/' VERSION: $(APPNAME) /g" ./VERSION > $(DISTREL)/$(APPNAME).cat.brs
	sed "s/^/' LICENSE: /g" ./LICENSE >> $(DISTREL)/$(APPNAME).cat.brs
	cd src && ls | xargs -J % sed -E -e ${COMMENT_LINES_RE} -e ${BLANK_LINES_RE} % >> ../$(DISTREL)/$(APPNAME).cat.brs
	cp $(DISTREL)/$(APPNAME).cat.brs source

test: dist remove install
	echo "Running tests"
	curl -d '' "http://${ROKU_DEV_TARGET}:8060/keypress/home"
	curl -d '' "http://${ROKU_DEV_TARGET}:8060/launch/dev?RunTests=true&logLevel=4"
	#sleep ${TEST_MAX_RUN} | telnet ${ROKU_DEV_TARGET} 8085

testFailures: remove install
	echo "Running tests - only showing failures"
	curl -d '' "http://${ROKU_DEV_TARGET}:8060/keypress/home"
	curl -d '' "http://${ROKU_DEV_TARGET}:8060/launch/dev?RunTests=true&showOnlyFailures=true&logLevel=4"
	#sleep ${TEST_MAX_RUN} | telnet ${ROKU_DEV_TARGET} 8085

ci: remove install
	echo "Running Rooibos Unit Tests"
	curl -d '' "http://${ROKU_DEV_TARGET}:8060/keypress/home"
	curl -d '' "http://${ROKU_DEV_TARGET}:8060/launch/dev?RunTests=true&testId=${GITCOMMIT}"
	-sleep ${TEST_MAX_RUN} | telnet ${ROKU_DEV_TARGET} 8085 | tee ${DISTREL}/test.log
	echo "=================== CI TESTS FINISHED =================== "

	if tail -2 ${DISTREL}/test.log | head | grep -q "RESULT: Success"; then echo "SUCCESS"; else exit -1; fi

screenshot: screenshot-png