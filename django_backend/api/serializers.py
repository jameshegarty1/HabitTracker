from rest_framework import serializers
from .models import Habit, HabitRecord, Tag
from .performance_handler import calculate_period_quantity 

class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Tag
        fields = '__all__'

class HabitRecordSerializer(serializers.ModelSerializer):
    habitId = serializers.PrimaryKeyRelatedField(queryset=Habit.objects.all())
    class Meta:
        model = HabitRecord
        fields = ['habitId', 'notes']


class HabitSerializer(serializers.ModelSerializer):
    tags = TagSerializer(many=True, required=False, allow_null=True, default=[])

    period_quantity = serializers.SerializerMethodField()


    def get_period_quantity(self, obj):
        habit_performance = calculate_period_quantity(obj)
        return habit_performance



    class Meta:
        model = Habit
        fields = ['id', 'name', 'description', 'tags', 'execution_quantity', 'notification_time', 'priority', 'frequency_count', 'frequency_period', 'period_quantity']
        extra_kwargs = {'tags': {'required': False}}

    def update(self, instance, validated_data):
        tags_data = validated_data.pop('tags', None)
        instance = super().update(instance, validated_data)

        if tags_data is not None:
            tags = [Tag.objects.get_or_create(name=tag_data['name'])[0] for tag_data in tags_data]
            instance.tags.set(tags)
        
        return instance

    def create(self, validated_data):
        tags_data = validated_data.pop('tags', [])
        habit = Habit.objects.create(**validated_data)

        # Handle tags, ensuring no attempt to iterate over None
        if tags_data is not None:
            for tag_data in tags_data:
                tag, created = Tag.objects.get_or_create(name=tag_data['name'])
                habit.tags.add(tag)

        return habit
