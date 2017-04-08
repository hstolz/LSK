# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

# Register your models here.
from fishes.models import Fish
admin.site.register(Fish)
