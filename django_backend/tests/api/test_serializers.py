from api.serializers import HabitSerializer, HabitRecordSerializer, TagSerializer
from datetime import date, time, timedelta
import pytest

pytestmark = pytest.mark.django_db
class TestHabitSerializer:
    def test_serialize_model_instance(self, habit_factory):
        habit = habit_factory()
        serializer = HabitSerializer(instance=habit)

        assert serializer.data['name'] == habit.name
        assert serializer.data['description'] == habit.description

    def test_serialize_with_tags(self, habit_factory, tag_factory):
        tag1 = tag_factory()
        tag2 = tag_factory()
        habit = habit_factory()
        habit.tags.set([tag1, tag2])
        serializer = HabitSerializer(instance=habit)

        assert len(serializer.data['tags']) == 2
        assert serializer.data['tags'][0]['name'] == tag1.name
        assert serializer.data['tags'][1]['name'] == tag2.name

    def test_validation(self, habit_factory):
        habit = habit_factory()
        data = {'name': '', 'description': habit.description}  # Invalid data
        serializer = HabitSerializer(data=data)

        assert not serializer.is_valid()
        assert 'name' in serializer.errors

    def test_serialize_with_optional_fields(self, habit_factory):
        habit = habit_factory(start_date=date.today(), end_date=date.today() + timedelta(days=1))
        serializer = HabitSerializer(instance=habit)

        assert 'start_date' in serializer.data
        assert 'end_date' in serializer.data
        assert serializer.data['start_date'] == habit.start_date.isoformat()
        assert serializer.data['end_date'] == habit.end_date.isoformat()

    def test_update_with_tags(self, habit_factory, tag_factory):
        habit = habit_factory()
        tag1 = tag_factory()
        tag2 = tag_factory()

        update_data = {
            'name': 'Updated Habit',
            'description': 'Updated Description',
            'tags': [{'name': tag1.name}, {'name': tag2.name}]
            }
        
        serializer = HabitSerializer(habit, data=update_data)
    
        if not serializer.is_valid():
            print(serializer.errors)
        assert serializer.is_valid()
        updated_habit = serializer.save()
        assert updated_habit.name == 'Updated Habit'
        assert updated_habit.description == 'Updated Description'
        assert list(updated_habit.tags.values_list('name', flat=True)) == [tag1.name, tag2.name]

    def test_update_without_tags(self, habit_factory):
        habit = habit_factory()

        update_data = {
            'name': 'Updated Habit', 
            'description': 'Updated Description'
        }

        serializer = HabitSerializer(instance=habit, data=update_data)
        if not serializer.is_valid():
            print(serializer.errors)
        assert serializer.is_valid()
        updated_habit = serializer.save()
        assert updated_habit.name == 'Updated Habit'
        assert updated_habit.description == 'Updated Description'
    


class TestHabitRecordSerializer:
    def test_serialize_model_instance(self, habit_record_factory):
        habit_record = habit_record_factory()
        serializer = HabitRecordSerializer(instance=habit_record)

        assert serializer.data['habit'] == habit_record.habit.id
        assert serializer.data['notes'] == habit_record.notes
        # ... assert other fields ...

    def test_validation(self, habit_record_factory):
        habit_record = habit_record_factory()
        data = {'habit': None, 'notes': habit_record.notes}  # Invalid data
        serializer = HabitRecordSerializer(data=data)

        assert not serializer.is_valid()
        assert 'habit' in serializer.errors

    def test_invalid_habit(self):
        invalid_data = {'habit': 9999, 'notes': 'Invalid habit id'}
        serializer = HabitRecordSerializer(data=invalid_data)

        assert not serializer.is_valid()
        assert 'habit' in serializer.errors

    def test_update_habit_record(self, habit_record_factory):
        habit_record = habit_record_factory()
        update_data = {'notes': 'Updated notes'}
        serializer = HabitRecordSerializer(instance=habit_record, data=update_data, partial=True)

        if not serializer.is_valid():
            print(serializer.errors)
        assert serializer.is_valid()
        updated_record = serializer.save()
        assert updated_record.notes == 'Updated notes'


class TestTagSerializer:
    def test_serialize_model_instance(self, tag_factory):
        tag = tag_factory()
        serializer = TagSerializer(instance=tag)

        assert serializer.data['name'] == tag.name
        assert serializer.data['description'] == tag.description

    def test_validation(self, tag_factory):
        data = {'name': ''}  # Invalid data
        serializer = TagSerializer(data=data)

        assert not serializer.is_valid()
        assert 'name' in serializer.errors

    def test_update_tag(self, tag_factory):
        tag = tag_factory()
        update_data = {'name': 'Updated Tag', 'description': 'Updated Description'}
        serializer = TagSerializer(instance=tag, data=update_data)

        assert serializer.is_valid()
        updated_tag = serializer.save()
        assert updated_tag.name == 'Updated Tag'
        assert updated_tag.description == 'Updated Description'