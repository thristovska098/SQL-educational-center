create database edu;

create table person(
	SSN varchar(15) not null, 
	first_name varchar(50),
	last_name varchar(50),
	birth_date date,
	address varchar(200),
	phone_number varchar(20),
	email varchar(50) unique,
	primary key (SSN)
);

create table candidate(
	SSN varchar(15) not null primary key,
	CONSTRAINT FK_SSN FOREIGN KEY (SSN) REFERENCES person(SSN) on delete restrict on update cascade
);

create table lecturer(
SSN varchar(15) not null primary key ,
education_degree varchar(15) ,
CONSTRAINT FK_SSN FOREIGN KEY (SSN) REFERENCES person(SSN) on delete restrict on update cascade
);

create table schedule(
	id serial not null, 
	from_date date, 
	to_date date,
	primary key (id)
);

create table edu_location(
	id serial not null,
	capacity integer,
	lessons_type varchar(10) not null CHECK(lessons_type='online' OR lessons_type='in person'), 
	addres varchar(200), 
	room_number integer, 
	platform varchar(15),
	primary key (id)
);

create table education_program(
	code varchar(10) not null primary key, 
	name_program varchar(50), 
	description varchar(50),
	program_price integer, --price in euro 
	type_program varchar(15) not null check(type_program='academy' OR type_program='course'),
	total_lectures integer, 
	start_date date
);

create table candidate_group(
	id serial not null primary key, 
	education_program_code varchar(10) not null, 
	constraint FK_epc foreign key (education_program_code) references education_program (code) on delete restrict on update cascade
);
create table candidate_belongs_to_group(
	SSN varchar(15) not null, 
	group_id integer not null, 
	primary key(SSN, group_id),
	constraint FK_SSN foreign key(SSN) references candidate(SSN) on delete restrict on update cascade,
	constraint FK_group_id foreign key (group_id) references candidate_group(id) on delete restrict on update cascade
);

create table lecture(
	code serial not null primary key, 
	group_id integer not null, 
	location_id integer not null, 
	schedule_id integer not null, 
	start_hour varchar(10), --ex. 3:00 PM 
	on_date date, 
	duration_hours integer, 
	lecture_number integer,
	constraint FK_group_id foreign key (group_id) references candidate_group(id) on delete restrict on update cascade,
	constraint FK_location_id foreign key(location_id) references edu_location (id) on delete restrict on update cascade,
	constraint FK_schedule_id foreign key (schedule_id) references schedule(id) on delete restrict on update cascade
	
);

create table lecturer_teaches_lecture(
	SSN varchar(15) not null, 
	lecture_code integer not null, 
	primary key(SSN, lecture_code),
	constraint FK_SSN foreign key (SSN) references lecturer(SSN) on delete restrict on update cascade,
	constraint FK_lecture_code foreign key (lecture_code) references lecture(code) on delete restrict on update cascade
);

--Insert candidates;
INSERT INTO person (SSN,first_name,last_name,birth_date,address,phone_number,email)
	VALUES ('192879078', 'Ana','Anovska','1996-12-08','Nekoja Ulica br.3','070-588-999','ana.96@gmail.com');
INSERT INTO person (SSN,first_name,last_name,birth_date,address,phone_number,email)
	VALUES ('192879273', 'Mila','Milovska','1998-10-03','Nekoja Ulica br.4','070-338-999','mila.98@gmail.com');
INSERT INTO person (SSN,first_name,last_name,birth_date,address,phone_number,email)
	VALUES ('138213978', 'Gorgi','Gorgievski','1999-08-15','Nekoja Ulica br.88','070-777-999','gorgi.99@gmail.com');
	
INSERT INTO candidate (SSN)
	VALUES ('192879078');
INSERT INTO candidate (SSN)
	VALUES ('192879273');
INSERT INTO candidate (SSN)
	VALUES ('138213978');

--insert person who is lecturer and candidate;
INSERT INTO person (SSN,first_name,last_name,birth_date,address,phone_number,email)
	VALUES ('134238', 'Gordana','Gordanovska','1973-12-08','Nekoja Ulica br.3','070-598-999','gordana@edu.com');
	
INSERT INTO candidate (SSN)
	VALUES ('134238');
INSERT INTO lecturer (SSN,education_degree)
	VALUES ('192879273','master');

--insert lecturers ;
INSERT INTO person (SSN,first_name,last_name,birth_date,address,phone_number,email)
	VALUES ('139321', 'Sime','Simevski','1970-12-08','Nekoja Ulica br.3','070-598-889','sime@edu.com');
	
INSERT INTO lecturer (SSN,education_degree)
	VALUES ('139321','bachelor');
	
INSERT INTO person (SSN,first_name,last_name,birth_date,address,phone_number,email)
	VALUES ('1331831', 'Stojan','Stojanovski','1975-12-08','Nekoja Ulica br.109','070-598-889','stojan@edu.com');
	
INSERT INTO lecturer (SSN,education_degree)
	VALUES ('1331831','master');

--insert education programs ;
INSERT INTO education_program (code,name_program, description, program_price,type_program,total_lectures,start_date)
	VALUES ('CS305','Java Full Stack', 'Some description..',10000,'course',200,'2020-11-12');

--insert candidate_group ;
INSERT INTO candidate_group (education_program_code)
	VALUES ('CS305');

INSERT INTO candidate_group (education_program_code)
	VALUES ('CS305');

--insert candidates to groups ;
INSERT INTO candidate_belongs_to_group (SSN,group_id)
	VALUES ('134238',1);
INSERT INTO candidate_belongs_to_group (SSN,group_id)
	VALUES ('192879078',2);

--insert schedule ;
INSERT INTO schedule (from_date,to_date)
	VALUES ('2020-10-01','2021-05-01');

--insert edu_location ;
INSERT INTO edu_location (capacity,lessons_type,addres,room_number)
	VALUES (20,'in person','Nekoja adresa br.333',3);
	
INSERT INTO edu_location (capacity,lessons_type,platform)
	VALUES (30,'online','Zoom');

--insert lectures;
INSERT INTO lecture (group_id,location_id,schedule_id,start_hour,on_date,duration_hours,lecture_number)
	VALUES (1,1,1,'4:00 PM','2020-10-10',2,1);
	
INSERT INTO lecture (group_id,location_id,schedule_id,start_hour,on_date,duration_hours,lecture_number)
	VALUES (2,2,1,'5:00 PM','2020-11-11',2,3);

--insert lecturer_teaches_lecture;
INSERT INTO lecturer_teaches_lecture (SSN, lecture_code)
	VALUES (139321,1);
	
INSERT INTO lecturer_teaches_lecture (SSN, lecture_code)
	VALUES (139321,2);

--Show the number of lectures;
SELECT COUNT(code)
FROM lecture;

--Show the person that is candidate and lecturer;
SELECT * 
FROM candidate INNER JOIN lecturer on candidate.SSN=lecturer.SSN;

--Sort the candidates by their last name;
SELECT p.last_name, p.first_name, p.SSN
FROM candidate INNER JOIN person AS p on candidate.SSN=p.SSN
ORDER BY p.last_name;

