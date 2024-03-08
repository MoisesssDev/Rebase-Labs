def format_response(data)
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
