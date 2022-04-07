
HASH = $(shell git rev-parse --short HEAD)
BRANCH_NAME ?= $(shell git symbolic-ref --short -q HEAD)
BUILD_NUMBER ?= 0
export BUILD_VERSION ?= $(BRANCH_NAME).$(BUILD_NUMBER).$(HASH)
POETRY_RUNNER = poetry run


get-hash:
	echo $(HASH)

get-version:
	echo $(BUILD_VERSION)

get-desc:
	echo $(HASH)@$(BRANCH_NAME) build number $(BUILD_NUMBER)

install-poetry:
	@if which poetry &> /dev/null; \
	 	then echo "Poetry already installed"; \
	 else echo "Installing poetry"; \
	 	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - ; \
		poetry --version; \
	 fi

install-deps: install-poetry
	poetry install


build:
	poetry build


black-check:  CHECK = --check
black-check:  _black  ## run just black

black:  CHECK =
black:  _black ## make the code pretty using black

_black:
	$(POETRY_RUNNER) \
	black src/ tests/ $(CHECK)

isort:  CHECK
isort: _isort

isort:  CHECK = --check
isort-check: _isort

_isort: 
	$(POETRY_RUNNER) \
	isort src/ tests/ $(CHECK)


pylint:  ## runs just pylint
	$(POETRY_RUNNER) \
	pylint -j 0 src/ tests/

test:
	$(POETRY_RUNNER) pytest

test-coverage:
	$(POETRY_RUNNER) pytest --cov-report xml --cov=. --showlocals -vv 

coverage-report:
	$(POETRY_RUNNER) coverage report -m

publish-test:
	pip install --upgrade twine
	twine upload --repository testpypi dist/*

# publish:
# 	pip install --upgrade twine
# 	twine upload dist/*

publish:
	pip install autopub

install-autopub:
	$(POETRY_RUNNER) pip install autopub


check-release:
	$(POETRY_RUNNER) autopub check 

pre-release: check-release
	$(POETRY_RUNNER) autopub prepare
	poetry version $(poetry version -s).dev.$(HASH)
	poetry build
	# poetry publish  
	echo "version::$(poetry version -s)"

clear-dist:
	rm -rf dist

