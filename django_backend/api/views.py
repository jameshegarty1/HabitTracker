from django.http import JsonResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .serializers import HabitSerializer, TagSerializer, HabitRecordSerializer
from .models import Habit, HabitRecord, Tag
import logging

logger = logging.getLogger(__name__)


@api_view(['GET'])
def getRoutes(request):
    routes = [
        # Habit Endpoints
        {
            'Endpoint': '/habits/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of Habits'
        },
        {
            'Endpoint': '/habits/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Habit'
        },
        {
            'Endpoint': '/habits/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates a new Habit'
        },
        {
            'Endpoint': '/habits/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Modifies an existing Habit'
        },
        {
            'Endpoint': '/habits/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing Habit'
        },

        # habitRecord Endpoints
        {
            'Endpoint': '/habitRecords/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of HabitRecords'
        },
        {
            'Endpoint': '/habitRecords/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single HabitRecord'
        },
        {
            'Endpoint': '/habitRecords/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates a new habitRecord'
        },
        {
            'Endpoint': '/habitRecords/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Modifies an existing HabitRecord'
        },
        {
            'Endpoint': '/habits/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing HabitRecord'
        },
        # Tag Endpoints
        {
            'Endpoint': '/tags/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of Tags'
        },
        {
            'Endpoint': '/tags/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Tag'
        },
        {
            'Endpoint': '/tags/create/',
            'method': 'POST',
            'body': {'name': ""},
            'description': 'Creates a new Tag'
        },
        {
            'Endpoint': '/tags/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Modifies an existing Tag'
        },
        {
            'Endpoint': '/tags/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing Tag'
        },
    ]
    return Response(routes)


#habit endpoints

@api_view(['GET'])
def getHabits(request):
    habits = Habit.objects.all()
    serializer = HabitSerializer(habits, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getHabit(request, pk):
    habit = Habit.objects.get(id=pk)
    serializer = HabitSerializer(habit, many=False)
    return Response(serializer.data)


@api_view(['POST'])
def createHabit(request):
    data = request.data

    tags = []
    if 'tags' in data and data['tags'] is not None:
        tags_data = data['tags']
        try:
            tags = [Tag.objects.get_or_create(name=tag_name)[0] for tag_name in tags_data]
        except Exception as e:
            return Response({'error': f"Error processing tags: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)

    habit_serializer = HabitSerializer(data=data)
    
    if habit_serializer.is_valid():
        habit = habit_serializer.save()
        if not habit:
            return Response({'error': 'Failed to create habit'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if tags:
            habit.tags.set(tags)
        return Response(habit_serializer.data)
    else:
        return Response(habit_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updateHabit(request, pk):
    data = request.data

    habit = Habit.objects.get(id=pk)

    serializer = HabitSerializer(habit, data=request.data)
    if serializer.is_valid():
        serializer.save()

    serializer = HabitSerializer(habit, many=False)
    return Response(serializer.data)

@api_view(['DELETE'])
def deleteHabit(request, pk):
    habit = Habit.objects.get(id=pk)
    habit.delete()
    return Response("Habit was deleted.")


#habit record endpoints
@api_view(['GET'])
def getHabitRecords(request):
    records = HabitRecord.objects.all()
    serializer = HabitRecordSerializer(records, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getHabitRecord(request, pk):
    record = HabitRecord.objects.get(id=pk)
    serializer = HabitSerializer(record, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def createHabitRecord(request):
    serializer = HabitRecordSerializer(data=request.data)
    if serializer.is_valid():
        habit_id = serializer.validated_data.pop('habitId')
        try:
            habit = Habit.objects.get(id=habit_id)
        except Habit.DoesNotExist:
            return Response({"detail": "Habit not found"}, status=404)
        instance = HabitRecord.objects.create(habit=habit, notes=serializer.validated_data.get('notes', ''))
        return Response(HabitRecordSerializer(instance).data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updateHabitRecord(request, pk):
    data = request.data

    record = HabitRecord.objects.get(id=pk)

    serializer = HabitRecordSerializer(record, data=request.data)
    if serializer.is_valid():
        serializer.save()

    serializer = HabitRecordSerializer(record, many=False)
    return Response(serializer.data)


@api_view(['GET'])
def getRoutes(request):
    routes = [
        # Habit Endpoints
        {
            'Endpoint': '/habits/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of Habits'
        },
        {
            'Endpoint': '/habits/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Habit'
        },
        {
            'Endpoint': '/habits/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates a new Habit'
        },
        {
            'Endpoint': '/habits/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Modifies an existing Habit'
        },
        {
            'Endpoint': '/habits/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing Habit'
        },

        # habitRecord Endpoints
        {
            'Endpoint': '/habitRecords/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of HabitRecords'
        },
        {
            'Endpoint': '/habitRecords/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single HabitRecord'
        },
        {
            'Endpoint': '/habitRecords/create/',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Creates a new habitRecord'
        },
        {
            'Endpoint': '/habitRecords/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Modifies an existing HabitRecord'
        },
        {
            'Endpoint': '/habits/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing HabitRecord'
        },
        # Tag Endpoints
        {
            'Endpoint': '/tags/',
            'method': 'GET',
            'body': None,
            'description': 'Returns an array of Tags'
        },
        {
            'Endpoint': '/tags/id/',
            'method': 'GET',
            'body': None,
            'description': 'Returns a single Tag'
        },
        {
            'Endpoint': '/tags/create/',
            'method': 'POST',
            'body': {'name': ""},
            'description': 'Creates a new Tag'
        },
        {
            'Endpoint': '/tags/id/update/',
            'method': 'PUT',
            'body': {'body': ""},
            'description': 'Modifies an existing Tag'
        },
        {
            'Endpoint': '/tags/id/delete/',
            'method': 'DELETE',
            'body': None,
            'description': 'Deletes an existing Tag'
        },
    ]
    return Response(routes)


#habit endpoints

@api_view(['GET'])
def getHabits(request):
    habits = Habit.objects.all()
    serializer = HabitSerializer(habits, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getHabit(request, pk):
    habit = Habit.objects.get(id=pk)
    serializer = HabitSerializer(habit, many=False)
    return Response(serializer.data)


@api_view(['POST'])
def createHabit(request):
    data = request.data

    tags = []
    if 'tags' in data and data['tags'] is not None:
        tags_data = data['tags']
        try:
            tags = [Tag.objects.get_or_create(name=tag_name)[0] for tag_name in tags_data]
        except Exception as e:
            return Response({'error': f"Error processing tags: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)

    habit_serializer = HabitSerializer(data=data)
    
    if habit_serializer.is_valid():
        habit = habit_serializer.save()
        if not habit:
            return Response({'error': 'Failed to create habit'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        if tags:
            habit.tags.set(tags)
        return Response(habit_serializer.data)
    else:
        return Response(habit_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
def updateHabit(request, pk):
    data = request.data

    habit = Habit.objects.get(id=pk)

    serializer = HabitSerializer(habit, data=request.data)
    if serializer.is_valid():
        serializer.save()

    serializer = HabitSerializer(habit, many=False)
    return Response(serializer.data)

@api_view(['DELETE'])
def deleteHabit(request, pk):
    habit = Habit.objects.get(id=pk)
    habit.delete()
    return Response("Habit was deleted.")


#habit record endpoints
@api_view(['GET'])
def getHabitRecords(request):
    records = HabitRecord.objects.all()
    serializer = HabitRecordSerializer(records, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getHabitRecord(request, pk):
    record = HabitRecord.objects.get(id=pk)
    serializer = HabitSerializer(record, many=False)
    return Response(serializer.data)
@api_view(['DELETE'])
def deleteHabitRecord(request, pk):
    record = HabitRecord.objects.get(id=pk)
    record.delete()
    return Response("Habit record was deleted.")



# Tag views
@api_view(['GET'])
def getTags(request):
    tags = Tag.objects.all()
    serializer = TagSerializer(tags, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getTag(request, pk):
    tag = Tag.objects.get(id=pk)
    serializer = HabitSerializer(tag, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def createTag(request):
    serializer = TagSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
    return Response(serializer.data)

@api_view(['PUT'])
def updateTag(request, pk):
    data = request.data

    tag = Tag.objects.get(id=pk)

    serializer = TagSerializer(tag, data=request.data)
    if serializer.is_valid():
        serializer.save()

    serializer = TagSerializer(tag, many=False)
    return Response(serializer.data)

@api_view(['DELETE'])
def deleteTag(request, pk):
    tag = Tag.objects.get(id=pk)
    tag.delete()
    return Response("Tag was deleted.")
