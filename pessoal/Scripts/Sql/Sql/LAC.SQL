select substr(user_name,1,10),substr(full_name,1,30) from fnd_user a , hr_employees b where b.employee_id =a.employee_id order by
full_name
/
