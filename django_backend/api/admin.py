from django.contrib import admin

# Register your models here.

from .models import Habit, HabitRecord, Tag
admin.site.register(Habit)
admin.site.register(HabitRecord)
admin.site.register(Tag)