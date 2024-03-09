from django.utils import timezone
from datetime import date, time, timedelta
import pytest
from api.models import HabitTypeChoices, PriorityChoices

pytestmark = pytest.mark.django_db

class TestHabitModel:

    def test_habit_creation(self, habit_factory):
        habit = habit_factory()
        assert habit.name.startswith("habit_")
        assert isinstance(habit.description, str)
        assert habit.habit_type in [choice[0] for choice in HabitTypeChoices.choices()]
        assert habit.execution_quantity == 0
        assert isinstance(habit.start_date, date)
        assert isinstance(habit.end_date, date)
        assert isinstance(habit.notification_time, time)
        assert habit.priority in [choice[0] for choice in PriorityChoices.choices()]
        assert habit.updated <= timezone.now()
        assert habit.created <= timezone.now()
        assert str(habit) == habit.name

    def test_habit_with_parent(self, habit_factory):
        
        parent_habit = habit_factory()

        # Create a habit with a parent habit
        child_habit = habit_factory(parent_habit=parent_habit)

        assert child_habit.parent_habit == parent_habit

    def test_habit_with_tags(self, habit_factory, tag_factory):
        # Create some tags
        tag1 = tag_factory()
        tag2 = tag_factory()

        # Create a habit with tags
        habit_with_tags = habit_factory()
        habit_with_tags.tags.set([tag1, tag2])

        assert list(habit_with_tags.tags.all()) == [tag1, tag2]

    def test_habit_string_representation(self, habit_factory):
        habit_name = "Read a Book"
        habit = habit_factory(name=habit_name)
        assert str(habit) == habit_name

    def test_habit_goal_quantity(self, habit_factory):
        finite_habit = habit_factory(habit_type=HabitTypeChoices.FINITE.value)
        infinite_habit = habit_factory(habit_type=HabitTypeChoices.INFINITE.value)

        assert finite_habit.goal_quantity is not None
        assert infinite_habit.goal_quantity is None

    def test_habit_date_fields(self, habit_factory):
        today = date.today()
        future_date = today + timedelta(days=10)

        habit = habit_factory(start_date=today, end_date=future_date)

        
        assert habit.start_date == today
        assert habit.end_date == future_date

        assert habit.end_date >= habit.start_date

    def test_habit_date_fields_no_end_date(self, habit_factory):
        today = date.today()

        habit = habit_factory(start_date=today, end_date=None)

        assert habit.start_date == today
        assert habit.end_date is None

    def test_habit_date_fields_no_start_date(self, habit_factory):
        future_date = date.today() + timedelta(days=10)

        habit = habit_factory(start_date=None, end_date=future_date)

        
        assert habit.start_date is None
        assert habit.end_date == future_date


class TestHabitRecordModel:
    def test_habit_record_creation(self, habit_factory, habit_record_factory):
        habit = habit_factory()
        initial_quantity = habit.execution_quantity

        habit_record = habit_record_factory(habit=habit)

        # Check if the HabitRecord is associated with the correct Habit
        assert habit_record.habit == habit

        # Check if the execution_date is set (auto_now_add)
        assert habit_record.execution_date is not None

        # Refresh the habit to get updated data
        habit.refresh_from_db()

        # Check if the execution_quantity of the Habit is incremented
        assert habit.execution_quantity == initial_quantity + 1

    def test_habit_record_with_notes(self, habit_factory, habit_record_factory):
        notes_text = "Completed 5 pages of reading."
        habit_record = habit_record_factory(notes=notes_text)

        # Check if notes are set correctly
        assert habit_record.notes == notes_text


class TestTagModel():
    def test_tag_creation(self, tag_factory):
        tag = tag_factory()

        # Test basic attributes
        assert tag.name is not None
        assert isinstance(tag.name, str)
        assert isinstance(tag.description, (str, type(None)))

    def test_tag_string_representation(self, tag_factory):
        tag_name = "Fitness"
        tag = tag_factory(name=tag_name)

        assert str(tag) == tag_name

    def test_tag_with_description(self, tag_factory):
        tag_description = "A tag related to fitness activities."
        tag = tag_factory(description=tag_description)

        assert tag.description == tag_description
