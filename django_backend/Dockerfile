# We Use an official Python runtime as a parent image
FROM python:3

# The enviroment variable ensures that the python output is set straight
# to the terminal with out buffering it first
ENV PYTHONUNBUFFERED 1

RUN mkdir /HabitTracker

WORKDIR /HabitTracker

COPY requirements.txt /HabitTracker

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# create root directory for our project in the container
COPY . /HabitTracker


RUN chmod +x start_app.sh