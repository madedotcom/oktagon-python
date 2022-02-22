import setuptools


setuptools.setup(
    name="oktagon-python",
    version="0.0.1",
    author="Boron Squad",
    author_email="andrii.piratovskyi@made.com",
    description="Python utility package for verifying & decoding OKTA tokens",
    package_dir={"": "src"},
    packages=setuptools.find_packages(where="src"),
    python_requires=">=3.6",
)
