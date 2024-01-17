from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    
    # Habit Endpoints
    path('habits/', views.getHabits, name='getHabits'),
    path('habits/create/', views.createHabit, name='createHabit'),
    path('habits/<str:pk>/', views.getHabit, name='getHabit'),    # Moved up for better sequence
    path('habits/<str:pk>/update/', views.updateHabit, name='updateHabit'),
    path('habits/<str:pk>/delete/', views.deleteHabit, name='deleteHabit'),
    
    # HabitRecords Endpoints
    path('habitRecords/', views.getHabitRecords, name='getHabitRecords'),
    path('habitRecords/create/', views.createHabitRecord, name='createHabitRecord'),
    path('habitRecords/<str:pk>/', views.getHabitRecord, name='getHabitRecord'),   # Moved up for better sequence
    path('habitRecords/<str:pk>/update/', views.updateHabitRecord, name='updateHabitRecord'),
    path('habitRecords/<str:pk>/delete/', views.deleteHabitRecord, name='deleteHabitRecord'),
    
    # Tags Endpoints
    path('tags/', views.getTags, name='getTags'),
    path('tags/create/', views.createTag, name='createTag'),
    path('tags/<str:pk>/', views.getTag, name='getTag'),    # Moved up for better sequence
    path('tags/<str:pk>/update/', views.updateTag, name='updateTag'),
    path('tags/<str:pk>/delete/', views.deleteTag, name='deleteTag'),
]