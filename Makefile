.PHONY: install pretty build

SOURCES= src/ tests/
CMD=poetry run
HASH=$(shell git rev-parse --short HEAD)

hash:
	@echo $(HASH)

install: 
	poetry install

install-package:
	poetry install --no-dev

black-check:  CHECK = --check
black-check:  _black  ## run just black

black:  CHECK =
black:  _black ## make the code pretty using black

_black:
	$(CMD) black --config pyproject.toml $(SOURCES) $(CHECK) -v


isort:  CHECK = --check
isort-check: _isort

isort:  CHECK = 
isort: _isort
_isort: 
	$(CMD) isort $(SOURCES) $(CHECK)


pylint:  ## runs just pylint
	$(CMD) pylint -j 0 $(SOURCES)


pretty: black isort pylint

pretty-check: black-check isort-check pylint

test:
	$(CMD) pytest

test-coverage:
	$(CMD) pytest --cov-report xml --cov=. --showlocals -vv --cov-append

coverage-report:
	$(CMD) coverage report -m

build:
	poetry build

publish-test:
	poetry config repositories.test-pypi https://test.pypi.org/legacy/
	poetry publish --repository test-pypi --username __token__ --password $(OKTAGON_TEST_PYPI_TOKEN) -vvv
	echo "::set-output name=version::$(shell make version)"

publish:
	poetry publish --username __token__ --password $(OKTAGON_PYPI_TOKEN)


version:
	@poetry version -s

pre-release:
	poetry version $(shell make version).dev.$(shell date '+%s')

release-tag:
	./scripts/pre-release.sh ${RELEASE_TYPE}

release:
	@[ "${RELEASE_VERSION}" ] || ( echo "Error: RELEASE_VERSION is not set"; exit 1 )
	poetry version ${RELEASE_VERSION}
	git add pyproject.toml
	git commit -m "Bump to version ${RELEASE_VERSION}"
	git push origin HEAD

clear-dist:
	rm -rf dist

