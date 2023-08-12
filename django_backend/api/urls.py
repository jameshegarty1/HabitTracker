from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    
    # Habit Endpoints
    path('habits/', views.getHabits),
    path('habits/create/', views.createHabit),
    path('habits/<str:pk>/', views.getHabit),    # Moved up for better sequence
    path('habits/<str:pk>/update/', views.updateHabit),
    path('habits/<str:pk>/delete/', views.deleteHabit),
    
    # HabitRecords Endpoints
    path('habitRecords/', views.getHabitRecords),
    path('habitRecords/create/', views.createHabitRecord),
    path('habitRecords/<str:pk>/', views.getHabitRecord),   # Moved up for better sequence
    path('habitRecords/<str:pk>/update/', views.updateHabitRecord),
    path('habitRecords/<str:pk>/delete/', views.deleteHabitRecord),
    
    # Tags Endpoints
    path('tags/', views.getTags),
    path('tags/create/', views.createTag),
    path('tags/<str:pk>/', views.getTag),    # Moved up for better sequence
    path('tags/<str:pk>/update/', views.updateTag),
    path('tags/<str:pk>/delete/', views.deleteTag),
]