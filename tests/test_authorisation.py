from __future__ import annotations
from typing import Dict, List, Tuple, Union
import pytest

import okta_jwt_verifier

from oktagon_python.authorisation import AuthorisationManager, InvalidTokenException

ClaimsType = Dict[str, Union[str, List[str]]]


class FakeJWTVerifier:
    def __init__(self, claims: ClaimsType) -> None:
        self.claims = claims

    def __call__(self, issuer: str, audience: str) -> FakeJWTVerifier:
        return self

    async def verify_access_token(self, access_token: str) -> None:
        pass

    def parse_token(self, access_token: str) -> Tuple[None, ClaimsType, None, None]:
        return (None, self.claims, None, None)


@pytest.mark.asyncio
async def test_no_token_provided():
    auth_manager = AuthorisationManager("service", "https://issuer", "audience")

    with pytest.raises(InvalidTokenException):
        await auth_manager.is_user_authorised(allowed_groups=[], resource_name="resource", cookies={})


@pytest.mark.asyncio
async def test_token_verification_failure():
    auth_manager = AuthorisationManager("service", "https://issuer", "audience")

    with pytest.raises(InvalidTokenException):
        await auth_manager.is_user_authorised(
            allowed_groups=[],
            resource_name="resource",
            cookies={"oktagon_access_token": "fakish_token"},
        )


@pytest.mark.asyncio
async def test_token_with_no_groups(monkeypatch):
    fake_verifier = FakeJWTVerifier(claims={"sub": "username@mail.com"})
    monkeypatch.setattr(okta_jwt_verifier, "BaseJWTVerifier", fake_verifier)
    auth_manager = AuthorisationManager("service", "https://issuer", "audience")

    with pytest.raises(InvalidTokenException):
        await auth_manager.is_user_authorised(
            allowed_groups=[],
            resource_name="resource",
            cookies={"oktagon_access_token": "fakish_token"},
        )


@pytest.mark.asyncio
async def test_user_is_not_authorised_to_access_resource(monkeypatch):
    fake_verifier = FakeJWTVerifier(claims={"sub": "username@mail.com", "groups": ["group-1", "group-2"]})
    monkeypatch.setattr(okta_jwt_verifier, "BaseJWTVerifier", fake_verifier)
    auth_manager = AuthorisationManager("service", "https://issuer", "audience")

    assert not await auth_manager.is_user_authorised(
        allowed_groups=["group-3"],
        resource_name="resource",
        cookies={"oktagon_access_token": "fakish_token"},
    ), "Expected user not to be authorised but it is!"


@pytest.mark.asyncio
async def test_user_is_authorised_to_access_resource(monkeypatch):
    fake_verifier = FakeJWTVerifier(claims={"sub": "username@mail.com", "groups": ["group-1", "group-2"]})
    monkeypatch.setattr(okta_jwt_verifier, "BaseJWTVerifier", fake_verifier)
    auth_manager = AuthorisationManager("service", "https://issuer", "audience")

    assert await auth_manager.is_user_authorised(
        allowed_groups=["group-2"],
        resource_name="resource",
        cookies={"oktagon_access_token": "fakish_token"},
    ), "Expected user to be authorised but it is not!"
