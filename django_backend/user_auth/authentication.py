from rest_framework.authentication import TokenAuthentication
from rest_framework.exceptions import AuthenticationFailed
from django.utils.translation import gettext_lazy as _
from .models import ExpiringToken

class ExpiringTokenAuthentication(TokenAuthentication):
    model = ExpiringToken

    def authenticate_credentials(self, key):
        model = self.get_model()
        try:
            token = model.objects.select_related('user').get(key=key)
            if not token.user.is_active or token.has_expired():
                raise AuthenticationFailed(_("User inactive or token expired."))
        except model.DoesNotExist:
            raise AuthenticationFailed(_("Invalid token."))

        return (token.user, token)
