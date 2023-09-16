# README



* Install Ruby version 2.7.5

* Config DB host, username and password on config/database.yml

* Run:
	- bundle install
	- rails db:setup
	- rails db:migrate
	- RAILS_ENV=test rails db:migrate

* Run server:
	- SCHEDULING_API=LOCAL_TOKEN bundle exec rails s


 * Run test
 	- rspec spec



# Summary

 * Some validations are not present, such as time ranges
 
 * Model attributes are basic, more can be added

 * Patient model can be added to vinculate the appoinment with the patient

 * The appoinment interval it's fixed to 30m, but just adding a attribute there is a easy way to ensure that each doctor can set this configuration

 * The appoinments only can by assigned by one on each doctor, because the inteval is fixed, not a range of 1 or 2 hours can be added



# Models:
 	Doctors: Doctor's main data
 	Appoinments: Each doctor appoinment with dates and patient info
 	Workingdays: Days and time range of each doctor's workday 





# JSON calls examples

Create Doctor
```
POST http://127.0.0.1:3000/doctors/
{"full_name": "DR Full Name"}
```

Lists of Doctors
```
GET http://127.0.0.1:3000/doctors/
```

Update Doctor
```
POST http://127.0.0.1:3000/doctors/
{"full_name": "Dr. Full Name"}
```



Create Doctor Working Days and Hours 
```
POST http://127.0.0.1:3000/working_days
{ "doctor_id": **ID**, "working_days": [
	{ "weekday": 0, "start_working_hour": "09:00", "end_working_hour": "18:00" },
	{ "weekday": 1, "start_working_hour": "09:00", "end_working_hour": "18:00" }
]
} 
```

Doctor Working Days and Hours
```
GET http://127.0.0.1:3000/doctors/**ID**/working_days
```


Update Doctor Working Days and Hours 
```
PATCH http://127.0.0.1:3000/doctors/**ID**/working_days
{ "doctor_id": 3, "working_days": [
	{ "weekday": 0, "start_working_hour": "11:00", "end_working_hour": "19:00" },
	{ "weekday": 1, "start_working_hour": "11:00", "end_working_hour": "19:00" }
]
} 
```

List of Doctor appointment
```
GET http://127.0.0.1:3000/doctors/**ID**/appointments
```

List of Doctor open sots
```
GET http://127.0.0.1:3000/doctors/**ID**/open_slots?date=2023-01-09
```

Create Doctor appointment
```
POST http://127.0.0.1:3000/appointments/
{ "doctor_id": **ID**, "start_date": "2023-01-01T09:00:00.000Z", "end_date": "2023-01-01T09:30:00.000Z"}
```

Appointment
```
GET http://127.0.0.1:3000/appointments/**ID**
```

UPDATE Doctor appointment
```
PATCH http://127.0.0.1:3000/appointments/
{ "id": **ID_APPOINTMENT**, "doctor_id": **ID**, "start_date": "2023-01-01T10:00:00.000Z", "end_date": "2023-01-01T10:30:00.000Z"}
```

Delete Doctor appointment
```
DELETE http://127.0.0.1:3000/appointments/**ID**
```





# Changes

- Added token config as env varable for unauthorize api calls
- Added Rack Attack Gem to throttling repited calls by ip

