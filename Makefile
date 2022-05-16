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
	poetry version prerelease

release-tag:
	@[ "${RELEASE_TYPE}" ] || ( echo "Error: RELEASE_TYPE is not set"; exit 1 )
	@# TODO remove sed when poetry 1.2 is out and use --short --dry-run options
	git tag "v$(shell poetry version ${RELEASE_TYPE} | sed -e 's/.*to \(.*\)/\1/')"
	git push 

release:  
	@[ "${RELEASE_VERSION}" ] || ( echo "Error: RELEASE_VERSION is not set"; exit 1 )
	poetry version ${RELEASE_VERSION}
	

clear-dist:
	rm -rf dist

