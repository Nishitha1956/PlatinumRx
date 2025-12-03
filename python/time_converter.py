def convert_minutes(minutes):
    hours = minutes // 60
    minutes_a = minutes % 60
    return f"{hours} hrs {minutes_a} minutes"
    #return str(hours) + " hrs " + str(minutes_a) + " minutes"

print(convert_minutes(130))   # 2 hrs 10 minutes
print(convert_minutes(110))   # 1 hr 50 minutes

print(convert_minutes(45))