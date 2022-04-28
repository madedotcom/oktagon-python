
SOURCES= src/ tests/ setup.py

install: 
	pip install -e .[tests,coverage,build]

install-tests: 
	pip install -e .[tests]

install-build: 
	pip install -e .[build]

install-coverage:
	pip install -e .[coverage]

black-check:  CHECK = --check
black-check:  _black  ## run just black

black:  CHECK =
black:  _black ## make the code pretty using black

_black:
	black --config pyproject.toml $(SOURCES) $(CHECK) -v


isort:  CHECK = --check
isort-check: _isort

isort:  CHECK = 
isort: _isort
_isort: 
	isort $(SOURCES) $(CHECK)


pylint:  ## runs just pylint
	pylint -j 0 $(SOURCES)


pretty: black isort pylint

pretty-check: black-check isort-check pylint

test:
	pytest

test-coverage:
	pytest --cov-report xml --cov=. --showlocals -vv --cov-append

coverage-report:
	coverage report -m

build:
	python -m build

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

