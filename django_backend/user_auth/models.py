from django.db import models
from django.utils import timezone
from datetime import timedelta
from rest_framework.authtoken.models import Token

class ExpiringToken(Token):
    # Set a default expiration time (e.g., 1 day from creation)
    expires = models.DateTimeField(default=timezone.now() + timedelta(days=1))

    def has_expired(self):
        return timezone.now() >= self.expires
