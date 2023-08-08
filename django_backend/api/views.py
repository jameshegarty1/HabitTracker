from django.http import JsonResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import HabitSerializer
from .models import Habit

@api_view(['GET'])
def getRoutes(request):
    routes = [
        {
            'Endpoint' : '/habits/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns an array of Habits'
        },
        {
            'Endpoint' : '/habits/id/',
            'method' : 'GET',
            'body' : None,
            'description' : 'Returns a single Habits'
        },
        {
            'Endpoint' : '/habits/create/',
            'method' : 'POST',
            'body' : {'body': ""},
            'description' : 'Creates a new Habit with data sent in POST request'
        },
        {
            'Endpoint' : '/habits/id/update/',
            'method' : 'PUT',
            'body' : {'body': ""},
            'description' : 'Modifies an existing Habit with data sent in PUT request'
        },
        {
            'Endpoint' : '/habits/id/delete/',
            'method' : 'DELETE',
            'body' : None,
            'description' : 'Deletes an existing Habit'
        }
    ]
    return Response(routes)

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
    habit = Habit.objects.create(
        body = data['body']
    )
    serializer = HabitSerializer(habit, many=False)
    return Response(serializer.data)

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