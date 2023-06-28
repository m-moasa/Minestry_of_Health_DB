-- ساخت دیتابیس وزارت بهداشت
use master
CREATE DATABASE Ministry
ON PRIMARY
( NAME = 'healthMinistry_data' , FILENAME = 'd:\database\ministry_data.mdf' , SIZE = 10MB , MAXSIZE = unlimited , FILEGROWTH = 5MB ) ,
FILEGROUP [A]
( NAME = 'healthMinistryA_data' , FILENAME = 'd:\database\ministryA_data.ndf' , SIZE = 5MB , MAXSIZE = 200MB , FILEGROWTH = 5MB ) ,
FILEGROUP [B]
( NAME = 'healthMinistryB_data' , FILENAME = 'd:\database\ministryB_data.ndf' , SIZE = 20MB , MAXSIZE = unlimited , FILEGROWTH = 10MB )
LOG ON 
( NAME = 'healthMinistry_log' , FILENAME = 'd:\database\ministry_log.ldf' , SIZE = 5MB , MAXSIZE = unlimited , FILEGROWTH = 1MB )


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ساخت جداول موجودیت‌ها

create table university(									-- جدول دانشگاه
						code char(5) not null unique,	    -- کد دانشگاه
						[name] nvarchar(20) not null,		-- نام دانشگاه
						[address] nvarchar(50) not null,	-- آدرس دانشگاه
						primary key(code))






create table hospital(										-- جدول بیمارستان
					  code char(5) not null unique,			-- کد بیمارستان
					  [name] nvarchar(20),					-- نام بیمارستان
					  service_type nvarchar(20) not null,	-- نوع خدمات درمانی
					  number_of_beds int,					-- تعداد تخت‌ها
					  [adress] nvarchar(50),				-- آدرس بیمارستان
					  number_of_propertied int,				-- تعداد سهامداران
					  primary key(code))






create table doctor(										-- جدول دکتر
					national_id char(10) not null unique,	-- شماره‌ی ملی دکتر
					firstname nvarchar(20),					-- نام دکتر
					lastname nvarchar(20),					-- نام خانوادگی دکتر
					code char(10),							-- کد نظام پزشکی
					specialty nvarchar(30),					-- تخصص
					[address] nvarchar(50),					-- آدرس مطب
					sex bit,								-- جنسیت
					university_code char(5) not null,		--  کد دانشگاه عضو هیات علمی
					primary key(national_id),			
					foreign key(university_code) references university)






create table patient(										-- جدول بیمار
					 national_id char(10) not null unique,	-- کد ملی بیمار
					 firstname nvarchar(20),				-- نام بیمار
					 lastname nvarchar(20),					-- نام خانوادگی بیمار
					 file_code nvarchar(10),				-- شماره‌ی پرونده‌ی بیمار
					 sex bit,								-- جنسیت
					 ilness nvarchar(20),					-- عنوان بیماری
					 primary key(national_id))






create table intern(													--  جدول کارآموز
					national_id char(10) not null unique,				-- شماره‌ی ملی کارآموز
					firstname nvarchar(20),								-- نام کارآموز
					lastname nvarchar(20),								-- نام خانوادگی کارآموز
					student_code char(10),								-- شماره‌ی دانشجویی
					sex bit,											-- جنسیت
					employment_code char(10),							-- کد کارمندی
					university_code char(5) not null,					-- کد دانشگاهی که در آن تحصیل می‌کند 
					hospital_code char(5) not null,						-- کد بیمارستانی که در آن کارآموز است
					superviser_doctor_national_code char(10) not null,	-- شماره‌ی ملی دکتر مسئول
					primary key(national_id),
					foreign key(university_code) references university,
					foreign key(hospital_code) references hospital,
					foreign key(superviser_doctor_national_code) references doctor)






create table nurse(												-- جدول پرستار
				   national_id char(10) not null unique,		-- شماره‌ی ملی پرستار
				   firstname nvarchar(20),						-- نام پرستار
				   lastname nvarchar(20),						-- نام خانوادگی پرستار
				   code char(10),								-- کدنظام پزشکی پرستار
				   sex bit,										-- جنسیت
				   primary key(national_id))






create table survant(											-- جدول خدماتی
					 national_id char(10) not null unique,		-- شماره‌ی ملی خدماتی
				     firstname nvarchar(20),					-- نام خدماتی
				     lastname nvarchar(20),						-- نام خانوادگی خدماتی
				     service_type nvarchar(20) not null,		-- نوع خدمات ارائه دهنده
					 sex bit,									-- جنسیت
					 employment_code char(10),					-- کد کارمندی
					 hospital_code char(5),						-- کد بیمارستان محل کار
					 primary key(national_id),
					 foreign key(hospital_code) references hospital)






create table supplier(											-- جدول تامین کننده
					  commercial_code char(10) not null unique,	-- کد تجاری تامین کننده
					  [name] nvarchar(20),						-- نام تامین کننده
					  product_type nvarchar(20),				-- نوع کالای تامین کننده
					  service_type nvarchar(20) not null,		-- نوع خدمات تامین کننده
					  primary key(commercial_code))




---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ساخت جداول رابطه‌های چند به چند

create table hospital_doctor(												-- جدول رابطه‌ی بیمارستان و دکتر
							 hospital_code char(5) not null,				-- کد بیمارستان
							 doctor_national_code char(10) not null,		-- شماره‌ی ملی دکتر
							 is_manager bit,								-- مدیر بیمارستان است یا خیر
							 is_doctor bit,									-- صرفا دکتر در بیمارستان است یا خیر
							 foreign key(hospital_code) references hospital,
							 foreign key(doctor_national_code) references doctor)






create table hospital_nurse(													-- جدول رابطه‌ی بیمارستان و پرستار
							hospital_code char(5) not null,						-- کد بیمارستان
							nurse_national_code char(10) not null,				-- شماره‌ی ملی پرستار
							foreign key(hospital_code) references hospital,
							foreign key(nurse_national_code) references nurse)






create table hospital_patient(																-- جدول رابطه‌ی بیمارستان و بیمار
							  hospital_code char(5) not null,								-- کد بیمارستان
							  patient_national_code char(10) not null,						-- شماره‌ی ملی بیمار
							  foreign key(hospital_code) references hospital,				
							  foreign key(patient_national_code) references patient)






create table hospital_supplier(																-- جدول رابطه‌ی بیمارستان و تامین کننده
							   hospital_code char(5) not null,								-- کد بیمارستان
							   supplier_commercial_code char(10) not null,					-- کد تجاری تامین کننده
							   foreign key(hospital_code) references hospital,
							   foreign key(supplier_commercial_code) references supplier)




create table doctor_patient(															-- جدول رابطه‌ی دکتر و بیمار
							doctor_national_code char(10) not null,						-- شماره‌ی ملی دکتر
							patient_national_code char(10) not null,					-- شماره‌ی ملی بیمار
							foreign key(doctor_national_code) references doctor,
							foreign key(patient_national_code) references patient)



---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- درج داده

-- درج در جدول دانشگاه
INSERT INTO university (code, [name], [address])
VALUES ('00001', 'University of tehran', 'Enghlab SQ.')
INSERT INTO university (code, [name], [address])
VALUES ('00002', 'Shahed behshti Uni', 'Evin')
INSERT INTO university (code, [name], [address])
VALUES ('00003', 'Iran Uni', 'Chamraan')
INSERT INTO university (code, [name], [address])
VALUES ('00004', 'alborz medical Uni', 'Chamraan')


-- درج در جدول بیمارستان
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00101', 'taleghani', 'all', 1000, 'taleghani st.', 1)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00102', 'Noor', 'optic', 500, 'Zafar st.', 3)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00103', 'M. Khomieni', 'all', 2000, 'Keshavarz blv.', 2)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00104', 'mehr', 'all', 1000, 'zartosht st.', 1)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00105', 'kasra', 'all', 1000, 'nelson mandela st.', 1)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00106', 'pars', 'all', 1000, 'keshavarz blvd.', 1)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00107', 'laleh', 'all', 1000, 'simaye-iran st.', 1)
INSERT INTO hospital (code, [name], service_type, number_of_beds, adress, number_of_propertied)
VALUES ('00108', 'amir-al-momenin', 'all', 1000, 'sarsabz st.', 1)



-- درج در جدول بیمار
INSERT INTO patient(national_id, firstname, lastname, file_code, sex, ilness)
VALUES ('1111111111', 'Mohammad', 'Mosayebi', '201', 1, 'ALzhimer')
INSERT INTO patient(national_id, firstname, lastname, file_code, sex, ilness)
VALUES ('1111111112', 'Kian', 'Izadpanah', '202', 1, 'Eye Lost')
INSERT INTO patient(national_id, firstname, lastname, file_code, sex, ilness)
VALUES ('1111111113', 'Ehsan', 'Naderi', '203', 1, 'Bach ache')



-- درج در جدول دکتر
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333331', 'gholi', 'gholizadeh', 'D001', 'Eye', '1 st', 1, '00001')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333332', 'Donya', 'Donyazadeh', 'D002', 'neurology', '2 st', 0, '00002')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333333', 'Ehsan', 'Ehsani', 'D003', 'Sergeoun', '3 st', 1, '00003')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333334', 'mohammad', 'sadeghi', 'D004', 'Eye', '1 st', 1, '00003')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333335', 'ali', 'goodarazi', 'D005', 'Ear', '1 st', 1, '00002')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333336', 'reza', 'eslami', 'D006', 'Heart', '1 st', 1, '00004')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333337', 'alireza', 'akaberi', 'D007', 'Orthopedist', '1 st', 1, '00001')
INSERT INTO doctor(national_id, firstname, lastname, code, specialty, address, sex, university_code)
VALUES ('3333333338', 'taghi', 'joghataei', 'D008', 'lung', '1 st', 1, '00003')




-- درج در جدول کارآموز
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222221', 'hassan', 'hassani', '001001', 1, '101001', '00001', '00101', '3333333331')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222222', 'zahra', 'zahraie', '002001', 0, '102001', '00002', '00102', '3333333332')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222223', 'mohammad', 'mohammadi', '003001', 1, '103001', '00003', '00103', '3333333333')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222224', 'reza', 'aboulhassani', '004001', 1, '104001', '00002', '00105', '3333333336')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222225', 'reza', 'moghaddam', '005001', 1, '105001', '00002', '00108', '3333333334')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222226', 'negar', 'babashah', '006001', 0, '106001', '00003', '00105', '3333333338')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222227', 'kimia', 'ramezan zade', '007001', 0, '107001', '00003', '00105', '3333333338')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222228', 'mohammadreza', 'raddanipoor', '008001', 1, '108001', '00004', '00107', '3333333335')
INSERT INTO intern(national_id, firstname, lastname, student_code, sex, employment_code, university_code, hospital_code, superviser_doctor_national_code)
VALUES ('2222222229', 'hamraz', 'arafati', '009001', 0, '109001', '00004', '00107', '3333333335')




-- درج در جدول پرستار
INSERT INTO nurse(national_id, firstname, lastname, code, sex)
VALUES ('4444444441', 'Elahe', 'Elahi', 'N001', 0)
INSERT INTO nurse(national_id, firstname, lastname, code, sex)
VALUES ('4444444442', 'Sara', 'saravi', 'N002', 0)
INSERT INTO nurse(national_id, firstname, lastname, code, sex)
VALUES ('4444444443', 'Kiana', 'Kiani', 'N003', 0)
INSERT INTO nurse(national_id, firstname, lastname, code, sex)
VALUES ('4444444444', 'donya', 'navvabi', 'N004', 0)
INSERT INTO nurse(national_id, firstname, lastname, code, sex)
VALUES ('4444444445', 'ghazal', 'tahan', 'N005', 0)
INSERT INTO nurse(national_id, firstname, lastname, code, sex)
VALUES ('4444444446', 'mobina', 'zafarmand', 'N006', 0)



--  درج در جدول خدماتی
INSERT INTO survant (national_id, firstname, lastname, service_type, sex, employment_code, hospital_code)
VALUES ('555555551', 'Kamyar', 'Kami', 'Washing', 1, '101101', '00101')
INSERT INTO survant (national_id, firstname, lastname, service_type, sex, employment_code, hospital_code)
VALUES ('5555555552', 'Mariam', 'Mary', 'Rubbing', 0, '102101', '00102')
INSERT INTO survant (national_id, firstname, lastname, service_type, sex, employment_code, hospital_code)
VALUES ('5555555553', 'Koosha', 'Kooshi', 'transportation', 1, '103101', '00103')
INSERT INTO survant (national_id, firstname, lastname, service_type, sex, employment_code, hospital_code)
VALUES ('5555555554', 'arash', 'ziyaei', 'transportation', 1, '104101', '00106')
INSERT INTO survant (national_id, firstname, lastname, service_type, sex, employment_code, hospital_code)
VALUES ('5555555555', 'arian', 'alavi', 'transportation', 1, '105101', '00106')
INSERT INTO survant (national_id, firstname, lastname, service_type, sex, employment_code, hospital_code)
VALUES ('5555555556', 'mohsen', 'ghasemi', 'transportation', 1, '106101', '00106')



-- درج در جدول تامین کننده
INSERT INTO supplier (commercial_code, [name], product_type, service_type)
VALUES ('00201', 'MaskAvaran', 'Mask', 'Health')
INSERT INTO supplier (commercial_code, [name], product_type, service_type)
VALUES ('00202', 'CarAvaran', 'Car', 'transportation')
INSERT INTO supplier (commercial_code, [name], product_type, service_type)
VALUES ('00203', 'TakhtAvaran', 'Bed', 'Furniture')
INSERT INTO supplier (commercial_code, [name], product_type, service_type)
VALUES ('00204', 'mosayebdaran', 'Bed', 'Furniture')



-- درج در جدول رابطه‌ی بیمارستان و دکتر
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00101', '3333333331')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00102', '3333333332')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00103', '3333333333')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00105', '3333333335')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00106', '3333333335')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00107', '3333333335')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code, is_manager)
VALUES ('00105', '3333333336', 1)
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00107', '3333333337')
INSERT INTO hospital_doctor (hospital_code, doctor_national_code)
VALUES ('00108', '3333333338')



-- درج در جدول رابطه‌ی بیمارستان و پرستار
INSERT INTO hospital_nurse (hospital_code, nurse_national_code)
VALUES ('00101', '4444444441')
INSERT INTO hospital_nurse (hospital_code, nurse_national_code)
VALUES ('00102', '4444444442')
INSERT INTO hospital_nurse (hospital_code, nurse_national_code)
VALUES ('00103', '4444444443')
INSERT INTO hospital_nurse (hospital_code, nurse_national_code)
VALUES ('00104', '4444444444')
INSERT INTO hospital_nurse (hospital_code, nurse_national_code)
VALUES ('00104', '4444444445')
INSERT INTO hospital_nurse (hospital_code, nurse_national_code)
VALUES ('00104', '4444444446')



-- درج در جدول رابطه‌ی بیمارستان و بیمار
INSERT INTO hospital_patient (hospital_code, patient_national_code)
VALUES ('00101', '1111111111')
INSERT INTO hospital_patient (hospital_code, patient_national_code)
VALUES ('00102', '1111111112')
INSERT INTO hospital_patient (hospital_code, patient_national_code)
VALUES ('00103', '1111111113')
INSERT INTO hospital_patient (hospital_code, patient_national_code)
VALUES ('00107', '1111111113')
INSERT INTO hospital_patient (hospital_code, patient_national_code)
VALUES ('00107', '1111111112')



-- درج در جدول رابطه‌ی دکتر و بیمار
INSERT INTO doctor_patient (doctor_national_code, patient_national_code)
VALUES ('3333333331', '1111111111')
INSERT INTO doctor_patient (doctor_national_code, patient_national_code)
VALUES ('3333333332', '1111111112')
INSERT INTO doctor_patient (doctor_national_code, patient_national_code)
VALUES ('3333333333', '1111111113')
INSERT INTO doctor_patient (doctor_national_code, patient_national_code)
VALUES ('3333333337', '1111111112')
INSERT INTO doctor_patient (doctor_national_code, patient_national_code)
VALUES ('3333333337', '1111111113')


-- درج در جدول رابطه‌ی بیمارستان و تامین کننده
INSERT INTO hospital_supplier (hospital_code, supplier_commercial_code)
VALUES ('00101', '00201')
INSERT INTO hospital_supplier (hospital_code, supplier_commercial_code)
VALUES ('00102', '00201')
INSERT INTO hospital_supplier (hospital_code, supplier_commercial_code)
VALUES ('00103', '00201')
INSERT INTO hospital_supplier (hospital_code, supplier_commercial_code)
VALUES ('00107', '00204')
INSERT INTO hospital_supplier (hospital_code, supplier_commercial_code)
VALUES ('00108', '00204')


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- نمایش رکورد‌های تمامی جداول
select * from doctor
select * from doctor_patient
select * from hospital
select * from hospital_doctor
select * from hospital_nurse
select * from hospital_patient
select * from hospital_supplier
select * from intern
select * from nurse
select * from patient
select * from supplier
select * from survant
select * from university

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- بازیابی‌های موردنیاز

-- لیست پرستارانی که در بیمارستان مهر مشغول به کار هستند
select firstName, lastName from nurse where national_id in 
	(select nurse_national_code from hospital_nurse where hospital_code = '00104')



-- لیست تمام کارآموزان دانشگاه شهید بهشتی که در بیمارستان کسری مشغولند
select firstName, lastName from intern where 
		(hospital_code = '00105' and university_code = '00002')



-- لیست تمام کارآموزانی که دکتر صادقی سوپروایزر آنهاست
select firstName, lastName from intern where
	(superviser_doctor_national_code = '3333333334')



-- لیست بیمارستانهایی که دکتر گودرزی در آن مشغول به کار است
select [name] from hospital where code in (
	select hospital_code from hospital_doctor where 
		(doctor_national_code = '3333333335')
)



-- لیست بیمارستانهایی که دکتر اسلامی مدیریت آنرا بر عهده دارد
select [name] from hospital where code in (
	select hospital_code from hospital_doctor where (
		doctor_national_code = '3333333336' and is_manager = 1
	)
)



-- لیست دکترهایی که عضو هیات علمی دانشگاه تهران هستند
select firstname, lastname from doctor where (university_code = '00001')



-- لیست خدماتی‌های بیمارستان پارس
select firstname, lastname from survant where (hospital_code = '00106')



-- لیست بیمارستان‌هایی که دستگاه‌های آن توسط شرکت مصیب‌داران تامین می‌شود
select [name] from hospital where code in (
	select hospital_code from hospital_supplier where
		(supplier_commercial_code = '00204')
)



--لیست بیمارانی که در بیمارستان لاله بستری بوده‌اند و دکتر آنها دکتر اکابری است
select firstname, lastname from patient where 
	(national_id in (
		select distinct hospital_patient.patient_national_code from 
			hospital_patient inner join doctor_patient on 
			hospital_patient.patient_national_code = doctor_patient.patient_national_code
			where hospital_code = '00107' and doctor_national_code = '3333333337'
	)
)



--  لیست بیمارستانهایی که کارآموزی از دانشگاه علوم پزشکی البرز دارند به همراه نام و نام خانوادگی کارآموزان
create function internInHospital
	(@selected_hospital_code char(5))
	returns table
	as 
		return(
			select intern.firstname, intern.lastname, hospital.[name] from hospital
			inner join intern on hospital.code = intern.hospital_code
			inner join university on intern.university_code = university.code
			where university.code = @selected_hospital_code
		)
	go

select * from internInHospital('00004')



--لیست دانشجویان دختری که در دانشگاه ایران درس می‌خوانند و در بیمارستان کسری تحت نظر دکتر جغتایی کارآموزند
create proc internHospitalUniversityDoctor
	@doctor_lastname nvarchar(20),
	@university_name nvarchar(20),
	@hospital_name nvarchar(20)
	as
	begin
		select firstname, lastname from intern where (
		hospital_code in (select code from hospital where [name] = @hospital_name)
		and
		university_code in (select code from university where [name] = @university_name)
		and 
		superviser_doctor_national_code in (select national_id from doctor where lastname = @doctor_lastname)
		and
		sex = 0
		)
	end
	go

exec internHospitalUniversityDoctor'joghataei', 'Iran Uni', 'kasra'



-- تیریگر برای جلوگیری از عوض کردن شماره‌ی دانشجویی
create trigger tr_ChangeStudentCode
	ON intern
	AFTER update
	AS
	BEGIN
		IF update (student_code)
			ROLLBACK
	END

update intern
	set student_code = '001001'
	where student_code = '001008' -- بخاطر تریگر تعریف شده این خط ارور میدهد و مقدار این فیلد تغییری نمیکند
select * from intern

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- ویرایش داده‌ها

-- تغییر آدرس دانشگاه پزشکی البرز از چمران به استان البرز
update university
	set [address] = 'alborz province'
	where code = '00004'
select * from university


-- تغییر نوع کالای تامین شده توسط مصیب‌داران از تخت به سمعک
update supplier
	set product_type = 'earphone'
	where [name] = 'mosayebdaran'
select * from supplier
