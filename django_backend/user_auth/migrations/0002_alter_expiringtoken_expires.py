# Generated by Django 3.2.20 on 2024-02-18 21:56

import datetime
from django.db import migrations, models
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('user_auth', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='expiringtoken',
            name='expires',
            field=models.DateTimeField(default=datetime.datetime(2024, 2, 19, 21, 56, 32, 591730, tzinfo=utc)),
        ),
    ]