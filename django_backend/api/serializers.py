from rest_framework import serializers
from .models import Habit, HabitRecord, Tag

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = '__all__'

class HabitRecordSerializer(serializers.ModelSerializer):
    habit = serializers.PrimaryKeyRelatedField(queryset=Habit.objects.all())
    class Meta:
        model = HabitRecord
        fields = ['habit', 'notes']


class HabitSerializer(serializers.ModelSerializer):
    tags = TagSerializer(many=True, required=False, allow_null=True, default=[])


    class Meta:
        model = Habit
        fields = ['id', 'name', 'description', 'tags', 'habit_type', 'goal_quantity', 'current_quantity', 'start_date', 'end_date', 'notification_time', 'priority', 'parent_habit']
        extra_kwargs = {'tags': {'required': False}}

    def update(self, instance, validated_data):
        tags_data = validated_data.pop('tags', None)
        instance = super().update(instance, validated_data)

        if tags_data is not None:
            tags = [Tag.objects.get_or_create(name=tag_data['name'])[0] for tag_data in tags_data]
            instance.tags.set(tags)
        
        return instance
