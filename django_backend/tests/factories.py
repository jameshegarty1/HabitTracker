import factory
from factory.fuzzy import FuzzyChoice, FuzzyDate
from datetime import date
from api.models import Habit, HabitRecord, Tag, HabitTypeChoices, PriorityChoices

class TagFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Tag

    name = factory.Sequence(lambda n: f"tag_{n}")
    description = factory.Faker("text")

class HabitFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Habit

    # You can specify default values for fields here, or use factory helpers like Sequence
    name = factory.Sequence(lambda n: f"habit_{n}")
    description = factory.Faker("text")
    habit_type = FuzzyChoice(HabitTypeChoices.choices(), getter=lambda c: c[0])
    goal_quantity = factory.LazyAttribute(lambda o: 10 if o.habit_type == HabitTypeChoices.FINITE.value else None)
    current_quantity = 0
    start_date = FuzzyDate(start_date=date.today())
    end_date = FuzzyDate(start_date=date.today())
    notification_time = factory.Faker("time_object")
    priority = FuzzyChoice(PriorityChoices.choices(), getter=lambda c: c[0])

class HabitRecordFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = HabitRecord

    habit = factory.SubFactory(HabitFactory)
    notes = factory.Faker("text")
    # Add other fields with default values if necessary