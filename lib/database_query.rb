def find_all(conn)
  conn.exec('
    SELECT
      t.result_token, t.result_date, p.cpf, p.name, p.email, p.birthdate,
      d.crm, d.crm_state, d.name AS doctor_name,
      t.exam_type AS type, t.exam_type_limits AS limits, t.exam_type_result AS result
    FROM tests t
    JOIN doctors d ON t.doctor_crm = d.crm
    JOIN patients p ON t.patient_cpf = p.cpf
  ')
end

def find_by_token(conn, token)
  conn.exec("
    SELECT
      t.result_token, t.result_date, p.cpf, p.name, p.email, p.birthdate,
      d.crm, d.crm_state, d.name AS doctor_name,
      t.exam_type AS type, t.exam_type_limits AS limits, t.exam_type_result AS result
    FROM tests t
    JOIN doctors d ON t.doctor_crm = d.crm
    JOIN patients p ON t.patient_cpf = p.cpf
    WHERE result_token = '#{token}'
  ")
end