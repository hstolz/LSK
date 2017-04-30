# -*- coding: utf-8 -*-
# Generated by Django 1.11 on 2017-04-28 05:20
from __future__ import unicode_literals

from django.conf import settings
import django.contrib.auth.models
import django.contrib.auth.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0008_alter_user_username_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.ASCIIUsernameValidator()], verbose_name='username')),
                ('first_name', models.CharField(blank=True, max_length=30, verbose_name='first name')),
                ('last_name', models.CharField(blank=True, max_length=30, verbose_name='last name')),
                ('email', models.EmailField(blank=True, max_length=254, verbose_name='email address')),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('known_lang', models.CharField(choices=[(b'en', b'English'), (b'zh', b'Chinese'), (b'es', b'Spanish'), (b'ar', b'Arabic'), (b'pt', b'Portuguese'), (b'ru', b'Russian'), (b'fr', b'French'), (b'ja', b'Japanese'), (b'it', b'Italian'), (b'cs', b'Czech'), (b'de', b'German'), (b'he', b'Hebrew'), (b'hi', b'Hindi'), (b'ko', b'Korean'), (b'el', b'Greek'), (b'fa', b'Persian'), (b'sw', b'Swahili'), (b'tr', b'Turkish'), (b'tw', b'Twi'), (b'ur', b'Urdu'), (b'pl', b'Polish')], default=b'', max_length=100)),
                ('learn_lang', models.CharField(choices=[(b'en', b'English'), (b'zh', b'Chinese'), (b'es', b'Spanish'), (b'ar', b'Arabic'), (b'pt', b'Portuguese'), (b'ru', b'Russian'), (b'fr', b'French'), (b'ja', b'Japanese'), (b'it', b'Italian'), (b'cs', b'Czech'), (b'de', b'German'), (b'he', b'Hebrew'), (b'hi', b'Hindi'), (b'ko', b'Korean'), (b'el', b'Greek'), (b'fa', b'Persian'), (b'sw', b'Swahili'), (b'tr', b'Turkish'), (b'tw', b'Twi'), (b'ur', b'Urdu'), (b'pl', b'Polish')], default=b'', max_length=100)),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.Group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.Permission', verbose_name='user permissions')),
            ],
            options={
                'ordering': ('username',),
                'db_table': 'profiles',
            },
            managers=[
                ('objects', django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name='Match',
            fields=[
                ('match_id', models.AutoField(primary_key=True, serialize=False)),
                ('time_1', models.DateTimeField(null=True)),
                ('time_2', models.DateTimeField(null=True)),
                ('time_3', models.DateTimeField(null=True)),
                ('status_code', models.IntegerField(default=b'0')),
                ('user_id1', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='initiator', to=settings.AUTH_USER_MODEL)),
                ('user_id2', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='acceptor', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ('match_id',),
                'db_table': 'matches',
            },
        ),
    ]
