# -*- coding: utf-8 -*-
# Generated by Django 1.11 on 2017-04-21 03:28
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('demo', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='match',
            name='match_id',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
        migrations.AlterField(
            model_name='profile',
            name='user_id',
            field=models.AutoField(primary_key=True, serialize=False),
        ),
    ]
