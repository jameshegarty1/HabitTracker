from django.db import models


class Habit(models.Model):
    # Habit types
    INFINITE = 'INFINITE'
    FINITE = 'FINITE'
    HABIT_TYPE_CHOICES = [
        (INFINITE, 'Infinite'),
        (FINITE, 'Finite')
    ]
    
    # Habit data
    #user = models.ForeignKey('auth.User', on_delete=models.CASCADE)  # Link the habit to a user.
    parent_habit = models.ForeignKey('self', null=True, blank=True, on_delete=models.SET_NULL)  # For nested habits.
    name = models.CharField(max_length=200)
    description = models.TextField(null=True, blank=True)
    habit_type = models.CharField(max_length=10, choices=HABIT_TYPE_CHOICES, default=INFINITE)
    goal_quantity = models.PositiveIntegerField(null=True, blank=True)  # For finite habits only
    current_quantity = models.PositiveIntegerField(default=0)  # For finite habits only
    start_date = models.DateField(null=True, blank=True)
    end_date = models.DateField(null=True, blank=True)
    notification_time = models.TimeField(null=True, blank=True)
    tags = models.ManyToManyField('Tag', blank=True)  # A many-to-many relationship with a Tag model (to be defined).
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.name

    class Meta:
        ordering = ['-updated']


class HabitRecord(models.Model):
    habit = models.ForeignKey(Habit, on_delete=models.CASCADE)
    #user = models.ForeignKey('auth.User', on_delete=models.CASCADE)  # Link the history to a user.
    completion_date = models.DateField(auto_now_add=True)
    progress = models.PositiveIntegerField(default=0)  # For habits where you track progress.
    notes = models.TextField(null=True, blank=True)
    
    class Meta:
        ordering = ['-completion_date']


class Tag(models.Model):  # Basic tag model to categorize habits.
    name = models.CharField(max_length=100)
    description = models.TextField(null=True, blank=True)
    
    def __str__(self):
        return self.name