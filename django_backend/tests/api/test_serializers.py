'''
from django.test import TestCase
from api.models import Habit, HabitRecord, Tag
from api.serializers import TagSerializer, HabitRecordSerializer, HabitSerializer
from collections import OrderedDict

class TagSerializerTestCase(TestCase):
    def test_tag_serializer(self):
        tag = Tag.objects.create(name="Example")
        serializer = TagSerializer(tag)
        self.assertEqual(serializer.data, {'id': tag.id, 'name': "Example", 'description': None})

    def test_invalid_tag_name(self):
        """Test validation for invalid tag name."""
        data = {"name": ""}  # empty name
        serializer = TagSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertIn("name", serializer.errors)

class HabitRecordSerializerTestCase(TestCase):
    def setUp(self):
        self.habit = Habit.objects.create(name="Read a book")
        
    def test_habit_record_serializer(self):
        #ipdb.set_trace()
        print(self.habit.id)
        data = {
            "habit": self.habit.id,
            "notes": "Read a chapter of 'Django for beginners'."
        }
        serializer = HabitRecordSerializer(data=data)
        if not serializer.is_valid():
            print(serializer.errors)
        self.assertTrue(serializer.is_valid())
        serializer.save()
        self.assertEqual(HabitRecord.objects.first().notes, "Read a chapter of 'Django for beginners'.")

    def test_missing_habit_id(self):
        """Test validation for missing habitId."""
        data = {"notes": "Read a chapter."}
        serializer = HabitRecordSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertIn("habit", serializer.errors)

    def test_invalid_habit_id(self):
        """Test validation for invalid habitId."""
        data = {"habitId": 9999, "notes": "Read a chapter."}  # Assuming no Habit with id 9999
        serializer = HabitRecordSerializer(data=data)
        self.assertFalse(serializer.is_valid())
        self.assertIn("habit", serializer.errors)

class HabitSerializerTestCase(TestCase):
    def setUp(self):
        self.tag1 = Tag.objects.create(name="Morning")
        self.tag2 = Tag.objects.create(name="Evening")
        self.habit = Habit.objects.create(name="Workout", description="Daily workout session")
        self.habit.tags.set([self.tag1, self.tag2])
        
    def test_habit_serializer(self):
        serializer = HabitSerializer(self.habit)
        expected_data = {
            'id': self.habit.id,
            'name': 'Workout',
            'description': 'Daily workout session',
            'tags': [
                OrderedDict([('id', 4), ('name', 'Morning'), ('description', None)]), 
                OrderedDict([('id', 5), ('name', 'Evening'), ('description', None)])
            ], 
            'habit_type': 'Infinite',
            'goal_quantity': None,
            'current_quantity': 0,
            'start_date': None,
            'end_date': None,
            'notification_time': None,
            'priority': 'None',
            'parent_habit': None
        }
        print(serializer.data)
        print(expected_data)
        self.assertEqual(serializer.data, expected_data)

    def test_invalid_tags(self):
        """Test validation for invalid tags."""
        habit_data = {
            "name": "Test habit",
            "tags": [{"name": ""}]  # Invalid tag with empty name
        }
        serializer = HabitSerializer(data=habit_data)
        self.assertFalse(serializer.is_valid())
        self.assertIn("tags", serializer.errors)

    def test_missing_name(self):
        """Test validation for missing habit name."""
        habit_data = {}
        serializer = HabitSerializer(data=habit_data)
        self.assertFalse(serializer.is_valid())
        self.assertIn("name", serializer.errors)
'''