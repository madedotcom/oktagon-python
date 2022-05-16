# oktagon-python

[![PyPI](https://img.shields.io/pypi/v/oktagon-python?logo=pypi&logoColor=white&style=for-the-badge)](https://pypi.org/project/oktagon-python/)

This python package is a tiny utility for verifying & decoding OKTA tokens in python backend services.

## Installation

```shell
pip install oktagon-python
```

## Getting Started

Let's say you have /consignments REST API endpoint which you'd like to make accessible only by logistics OKTA group. Then you would write something like this:

```pyhton
import os

from oktagon_python.authorisation import AuthorisationManager
from starlette.requests import Request

auth_manager = AuthorisationManager(
    service_name="your_service_name",
    okta_issuer=os.environ.get("OKTAGON_OKTA_ISSUER"),
    okta_audience=os.environ.get("OKTAGON_OKTA_AUDIENCE"),
)

async def is_authorised(request: Request):
    return await auth_manager.is_user_authorised(
        allowed_groups=["logistics"],
        resource_name="consignments",
        cookies=request.cookies
    )
```

This will create an `AuthorisationManager` instance that will check user's authorisation.

## Contributing

### Install Poetry Package Manager

We use [Poetry](https://python-poetry.org/docs/) Package Manager to manage the package.

To start, install poetry on your machine with this command:

```bash
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
```

See [Poetry Installation Guide](https://python-poetry.org/docs/#installation) for more information.

### Setting up the environment

```shell
git clone https://github.com/madedotcom/oktagon-python.git
cd oktagon-python
make install
make tests
```

`make install` will run `poetry install` for you, it will create the virtualenv and install the dependencies (including dev ones).

With `poetry` you don't need to activate the virtualenv to run the tests (or any other command) the poetry `run` command will execute the given command _inside_ the project’s virtualenv!

### Run the formatters/linters

```shell
make pretty
```

Will run all the formatters and linters (`black`, `isort` and `pylint`) in write mode.

```shell
make pretty-check
```

Will run the formatters and linters in check mode.

You can also run them separately with `make black`, `make isort`, `make pylint`.

## Releases

### PR Pre-releases

When a PR is created the `CI` workflow will be triggered: this will execute the tests and, if those are successful, will publish a pre-release on Test PyPI. If everything goes well you should see a new comment on the PR titled `Pre-release` telling you what version has been released and how to install it.

### Production Releases

Production releases are done manually. To trigger a production release run the following command with the semver rule you want to bump (usuallly `patch` for bug fixes, `minor` to add functionality and `major` for API changes are the most common). Check [poetry's version bump examples](https://python-poetry.org/docs/cli/#version) to see all the options.

```bash
make pre-release patch|minor|major|prepatch|preminor|premajor|prerelease
```

This will push a new tag with the new version and trigger the release workflow. It will update the version and publish it on PyPI.
