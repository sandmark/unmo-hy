import pytest
import shutil

@pytest.fixture(scope="session", autouse=True)
def scope_session ():
    shutil.rmtree("tests/__pycache__")
    yield
