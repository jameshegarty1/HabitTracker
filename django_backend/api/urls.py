from django.urls import path
from . import views

urlpatterns = [
    path('', views.getRoutes),
    path('habits/', views.getHabits),
    path('habits/create/', views.createHabit),
    path('habits/<str:pk>/update/', views.updateHabit),
    path('habits/<str:pk>/delete/', views.deleteHabit),
    path('habits/<str:pk>', views.getHabit)
]