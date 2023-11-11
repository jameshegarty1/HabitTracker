from django.urls import reverse
from rest_framework.test import APIClient, APITestCase
from api.models import Habit, Tag, HabitRecord

class HabitViewTestCase(APITestCase):

    def setUp(self):
        self.client = APIClient()
        self.habit = Habit.objects.create(name="Test Habit", description="Test description")
        self.tag = Tag.objects.create(name="Test Tag")

    def test_get_habits(self):
        response = self.client.get(reverse('getHabits'))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 1)

    def test_get_habit(self):
        response = self.client.get(reverse('getHabit', kwargs={'pk': self.habit.id}))
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data['name'], self.habit.name)

    def test_create_habit(self):
        data = {
            'name': 'New Habit',
            'description': 'New description',
            'tags': [self.tag.name]
        }
        response = self.client.post(reverse('createHabit'), data=data)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(Habit.objects.count(), 2)

    def test_update_habit(self):
        data = {
            'name': 'Updated Habit',
            'description': 'Updated description'
        }
        response = self.client.put(reverse('updateHabit', kwargs={'pk': self.habit.id}), data=data)
        self.assertEqual(response.status_code, 200)
        self.habit.refresh_from_db()
        self.assertEqual(self.habit.name, 'Updated Habit')