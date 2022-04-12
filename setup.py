from setuptools import setup
import sys

# This appears to be necessary so that versioneer works:
sys.path.insert(0, ".")  # noqa
import versioneer


setup(
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
)
