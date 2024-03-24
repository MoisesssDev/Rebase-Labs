class Test

  def self.find_all(conn)
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
  
  def self.find_by_token(conn, token)
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

  def self.format_response(data)
    patients = []
    current_patient = nil
  
    data.each do |row|
      if current_patient.nil? || current_patient['cpf'] != row['cpf']
        current_patient = {
          'result_token' => row['result_token'],
          'result_date' => row['result_date'],
          'cpf' => row['cpf'],
          'name' => row['name'],
          'email' => row['email'],
          'birthday' => row['birthdate'],
          'doctor' => {
            'crm' => row['crm'],
            'crm_state' => row['crm_state'],
            'name' => row['doctor_name']
          },
          'tests' => []
        }
        patients << current_patient
      end
  
      current_patient['tests'] << {
        'type' => row['type'],
        'limits' => row['limits'],
        'result' => row['result']
      }
    end
  
    patients
  end  

end