# oktagon-python package

[![PyPI](https://img.shields.io/pypi/v/oktagon-python?logo=pypi&logoColor=white&style=for-the-badge)](https://pypi.org/project/oktagon-python/)

This python package is a tiny utility for verifying & decoding OKTA tokens in python backend services.

For more details please see following [guide](https://github.com/madedotcom/oktagon/docs/oktagon_integration.md)

# Installation

    pip install oktagon-python

## Contributing

    git clone https://github.com/madedotcom/oktagon-python.git
    cd oktagon-python
    make install
    make tests

This will install all the dependencies (including dev ones) and run the tests.

### Run the formatters/linters

    make pretty

Will run all the formatters and linters (`black`, `isort` and `pylint`) in write mode.

    make pretty-check

Will run the formatters and linters in check mode.

You can also run them separtly with `make black`, `make isort`, `make pylint`.

## Realeses

Merging a PR into the `main` branch will trigger the GitHub `release` workflow. \
The following GitHub actions will be triggered:

- [github-tag-action](https://github.com/anothrNick/github-tag-action) will bump a new tag with `patch` version by default. Add `#major` or `#minor` to the merge commit message to bump a different tag;
- [gh-action-pypi-publish](https://github.com/pypa/gh-action-pypi-publish) will push the newly built package on PyPI;
- [action-automatic-releases](https://github.com/marvinpinto/action-automatic-releases) will create the GitHub release and tag it with `latest` as well.
