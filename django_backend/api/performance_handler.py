from datetime import datetime, timedelta
import pytz
from collections.abc import Iterable
from .models import Habit, HabitRecord
import logging

logger = logging.getLogger(__name__)

def calculate_period_quantity(habit_input):
    if isinstance(habit_input, Iterable) and not isinstance(habit_input, str):
        # `items` is a list of objects
        for habit in habit_input:
            start_period, end_period = get_period_start_end(habit.frequency_period) 
            executions_count = HabitRecord.objects.filter(habitId_id=habit.id, execution_date__range=(start_period, end_period)).count()
            logger.info(f"[{__name__}] Habit ID {habit.id}, current performance = {executions_count}, frequency period is {habit.frequency_period}, checking performance from between: {start_period}, {end_period}")

    else:
        start_period, end_period = get_period_start_end(habit_input.frequency_period)
        logger.info(f"[{__name__}] Habit ID {habit_input.id}, current performance = {executions_count}, frequency period is {habit_input.frequency_period}, checking performance from between: {start_period}, {end_period}")
        executions_count = HabitRecord.objects.filter(habitId_id=habit.id, execution_date__range=(start_period, end_period)).count()
        return executions_count

def get_period_start_end(frequency_period, reference_date=None):
    logger.debug(f"[{__name__}] Handling frequency period {frequency_period}")
    if reference_date is None:
        reference_date = datetime.now(pytz.utc)
    else:
        # Ensure reference_date is timezone-aware
        if reference_date.tzinfo is None or reference_date.tzinfo.utcoffset(reference_date) is None:
            raise ValueError("reference_date must be timezone-aware")

    if frequency_period == 'Hourly':
        start = reference_date.replace(minute=0, second=0, microsecond=0)
        end = start + timedelta(hours=1) - timedelta(microseconds=1)
    elif frequency_period == 'Daily':
        start = reference_date.replace(hour=0, minute=0, second=0, microsecond=0)
        end = start + timedelta(days=1) - timedelta(microseconds=1)
    elif frequency_period == 'Weekly':
        start = (reference_date - timedelta(days=reference_date.weekday())).replace(hour=0, minute=0, second=0, microsecond=0)
        end = start + timedelta(weeks=1) - timedelta(microseconds=1)
    elif frequency_period == 'Monthly':
        start = reference_date.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
        if start.month == 12:
            end = start.replace(year=start.year + 1, month=1) - timedelta(microseconds=1)
        else:
            end = start.replace(month=start.month + 1) - timedelta(microseconds=1)
    elif frequency_period == 'Yearly':
        start = reference_date.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
        end = start.replace(year=start.year + 1) - timedelta(microseconds=1)
    else:
        raise ValueError("Unsupported frequency_period")

    return start, end
