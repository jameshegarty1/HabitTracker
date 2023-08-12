#!/bin/bash
APP_HOME=.

cd $APP_HOME

# Step 2: Start the Django app
python  $APP_HOME/manage.py makemigrations && python $APP_HOME/manage.py migrate && python $APP_HOME/manage.py runserver 0.0.0.0:8080