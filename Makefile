
HASH = $(shell git rev-parse --short HEAD)
BRANCH_NAME ?= $(shell git symbolic-ref --short -q HEAD)
BUILD_NUMBER ?= 0
export BUILD_VERSION ?= $(BRANCH_NAME).$(BUILD_NUMBER).$(HASH)


get-hash:
	echo $(HASH)

get-version:
	echo $(BUILD_VERSION)

get-desc:
	echo $(HASH)@$(BRANCH_NAME) build number $(BUILD_NUMBER)


install: 
	pip install -e .[tests,versioneer]


black-check:  CHECK = --check
black-check:  _black  ## run just black

black:  CHECK =
black:  _black ## make the code pretty using black

_black:
	black src/ tests/ $(CHECK)

isort:  CHECK
isort: _isort

isort:  CHECK = --check
isort-check: _isort

_isort: 
	isort src/ tests/ $(CHECK)


pylint:  ## runs just pylint
	pylint -j 0 src/ tests/

test:
	pytest

test-coverage:
	pytest --cov-report xml --cov=. --showlocals -vv --cov-append

coverage-report:
	coverage report -m

publish-test:
	pip install --upgrade twine
	twine upload --repository testpypi dist/*

# publish:
# 	pip install --upgrade twine
# 	twine upload dist/*

publish:
	pip install autopub


check-release:
	autopub check 

pre-release:
	autopub prepare
	# poetry version $(poetry version -s).dev.$(HASH)
	# poetry build
	# poetry publish --username __token__
	echo "::set-output name=version::$(poetry version -s)"

clear-dist:
	rm -rf dist

