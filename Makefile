
HASH = $(shell git rev-parse --short HEAD)
BRANCH_NAME ?= $(shell git symbolic-ref --short -q HEAD)
BUILD_NUMBER ?= 0
export BUILD_VERSION ?= $(BRANCH_NAME).$(BUILD_NUMBER).$(HASH)
SOURCES= src/ tests/ setup.py versioneer.py

get-hash:
	echo $(HASH)

get-version:
	echo $(BUILD_VERSION)

get-desc:
	echo $(HASH)@$(BRANCH_NAME) build number $(BUILD_NUMBER)


install: 
	pip install -r requirements.txt
	pip install -e .


black-check:  CHECK = --check
black-check:  _black  ## run just black

black:  CHECK =
black:  _black ## make the code pretty using black

_black:
	black $(SOURCES) $(CHECK)


isort:  CHECK = --check
isort-check: _isort

isort:  CHECK = 
isort: _isort
_isort: 
	isort $(SOURCES) $(CHECK)


pylint:  ## runs just pylint
	pylint -j 0 $(SOURCES)

test:
	pytest

test-coverage:
	pytest --cov-report xml --cov=. --showlocals -vv --cov-append

coverage-report:
	coverage report -m

build:
	python setup.py sdist


publish-test:
	pip install --upgrade twine
	twine upload --repository testpypi dist/*

publish:
	pip install --upgrade twine
	twine upload dist/*


version:
	python setup.py version | grep Version:

clear-dist:
	rm -rf dist

