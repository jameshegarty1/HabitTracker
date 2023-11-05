from rest_framework import serializers
from .models import Habit, HabitRecord, Tag

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = '__all__'

class HabitRecordSerializer(serializers.ModelSerializer):
    habitId = serializers.IntegerField(write_only=True)
    class Meta:
        model = HabitRecord
        fields = ['habitId', 'notes']
    
    



class HabitSerializer(serializers.ModelSerializer):
    tags = TagSerializer(many=True, read_only=True)

    class Meta:
        model = Habit
        fields = '__all__'
