import logging

import okta_jwt_verifier

from okta_jwt_verifier.exceptions import JWTValidationException
from starlette.requests import Request


logger = logging.getLogger(__name__)


class InvalidTokenException(Exception):
    pass


class AuthorisationManager:
    def __init__(
        self,
        allowed_groups: list,
        resource_name: str,
        service_name: str,
        okta_issuer: str,
        okta_audience: str,
    ):
        self._allowed_groups = allowed_groups
        self._resource_name = resource_name
        self._service_name = service_name
        self._okta_audience = okta_audience
        self._okta_issuer = okta_issuer

    def _get_access_token(self, request):
        pass

    async def is_user_authorised(self, request: Request):
        access_token = self._get_access_token(request)

        try:
            jwt_verifier = okta_jwt_verifier.BaseJWTVerifier(issuer=self._okta_issuer, audience=self._okta_audience)
            await jwt_verifier.verify_access_token(access_token)
        except JWTValidationException as exc:
            logger.error(f"Failed to validate access token: {exc}")
            raise InvalidTokenException from JWTValidationException

        decoded_claims = jwt_verifier.parse_token(access_token)[1]

        try:
            return self.does_user_have_required_group(
                user_groups=decoded_claims["groups"],
                username=decoded_claims["sub"],
            )
        except KeyError as exc:
            raise InvalidTokenException("Groups or sub claims are not provided!") from exc

    def does_user_have_required_group(self, user_groups: list, username: str) -> bool:
        if not any(allowed_group in user_groups for allowed_group in self._allowed_groups):
            logger.info(f"{username} is not allowed to access resource: {self._resource_name} in {self._service_name}")
            return False

        logger.info(f"{username} is allowed to access resource: {self._resource_name} in {self._service_name}")
        return True


class StarletteAuthorisationManager(AuthorisationManager):
    def __init__(
        self,
        allowed_groups: list,
        resource_name: str,
        service_name: str,
        okta_issuer: str,
        okta_audience: str,
    ):
        super().__init__(allowed_groups, resource_name, service_name, okta_issuer, okta_audience)

    def _get_access_token(self, request: Request):
        try:
            return request.cookies["access_token"]
        except KeyError:
            raise InvalidTokenException("No token provided!")
