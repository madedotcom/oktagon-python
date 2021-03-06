# oktagon-python

[![PyPI](https://img.shields.io/pypi/v/oktagon-python?logo=pypi&logoColor=white&style=for-the-badge)](https://pypi.org/project/oktagon-python/)

This python package is a tiny utility for verifying & decoding OKTA tokens in python
backend services.

## Installation

```shell
pip install oktagon-python
```

## Getting Started

Let's say you have /consignments REST API endpoint which you'd like to make accessible
only by logistics OKTA group. Then you would write something like this:

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

This will create an `AuthorisationManager` instance that will check user's
authorisation.

## Getting user's email

There is `get_user_email` async method on AuthorisationManager to retrieve user's email. Usage:

```python
from starlette.requests import Request

cookies: Request.cookies = request.cookies
email = await auth_manager.get_user_email(cookies)
```

## Contributing

```shell
git clone https://github.com/madedotcom/oktagon-python.git
cd oktagon-python
make install
make tests
```

This will install all the dependencies (including dev ones) and run the tests.

### Run the formatters/linters

```shell
make pretty
```

Will run all the formatters and linters (`black`, `isort` and `pylint`) in write mode.

```shell
make pretty-check
```

Will run the formatters and linters in check mode.

You can also run them separtly with `make black`, `make isort`, `make pylint`.

## Realeses

Merging a PR into the `main` branch will trigger the GitHub `release` workflow. \
The following GitHub actions will be triggered:

- [github-tag-action](https://github.com/anothrNick/github-tag-action) will bump a new
  tag with `patch` version by default. Add `#major` or `#minor` to the merge commit
  message to bump a different tag;
- [gh-action-pypi-publish](https://github.com/pypa/gh-action-pypi-publish) will push the
  newly built package on PyPI;
- [action-automatic-releases](https://github.com/marvinpinto/action-automatic-releases)
  will create the GitHub release and tag it with `latest` as well.
