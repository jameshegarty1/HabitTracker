from pytest_factoryboy import register

from .factories import HabitFactory, HabitRecordFactory, TagFactory


register(HabitFactory)
register(HabitRecordFactory)
register(TagFactory)