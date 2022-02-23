install-packages:
	pip install .
	pip install -r requirements.txt

test:
	pytest

build:
	pip install --upgrade build
	python -m build

publish-test:
	pip install --upgrade twine
	twine upload --repository testpypi dist/*

publish:
	pip install --upgrade twine
	twine upload dist/*

clear-dist:
	rm -rf dist
