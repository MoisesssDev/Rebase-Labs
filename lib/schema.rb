class Schema

  def self.connect_to_database
    config_database = nil
  
    if ENV['APP_ENV'] == 'test'
      config_database = { dbname: 'rebasetest', user: 'docker', password: 'docker', host: 'pgtest' }
    else
      config_database = { dbname: 'rebaselabs', user: 'docker', password: 'docker', host: 'pgserver' }
    end
  
    PG.connect(config_database)
  end
  
  def self.create_tables(conn)
    conn.exec('CREATE TABLE IF NOT EXISTS doctors  (
                crm VARCHAR(10) UNIQUE NOT NULL,
                crm_state VARCHAR(2) NOT NULL,
                name VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL
              );')
  
    conn.exec('CREATE TABLE IF NOT EXISTS patients (
                cpf VARCHAR(14) UNIQUE NOT NULL,
                name VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                birthdate DATE NOT NULL,
                address VARCHAR(255) NOT NULL,
                city VARCHAR(255) NOT NULL,
                state VARCHAR(255) NOT NULL
              );')
  
    conn.exec('CREATE TABLE IF NOT EXISTS tests (
                patient_cpf VARCHAR(14) NOT NULL,
                doctor_crm VARCHAR(10) NOT NULL,
                result_token VARCHAR(255) NOT NULL,
                result_date DATE NOT NULL,
                exam_type VARCHAR(255) NOT NULL,
                exam_type_limits VARCHAR(255) NOT NULL,
                exam_type_result VARCHAR(255) NOT NULL,
                CONSTRAINT fk_medicalexam_patient FOREIGN KEY (patient_cpf) REFERENCES patients (cpf),
                CONSTRAINT fk_medicalexam_doctor FOREIGN KEY (doctor_crm) REFERENCES doctors (crm)
              );')
  end
  
  def self.drop_tables(conn)
    conn.exec('DROP TABLE IF EXISTS tests;')
    conn.exec('DROP TABLE IF EXISTS doctors;')
    conn.exec('DROP TABLE IF EXISTS patients;')
  end

  def self.insert_patient(conn, row)
    conn.exec_params("INSERT INTO patients VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT DO NOTHING", row[0..6])
    row[0]
  end
  
  def self.insert_doctor(conn, row)
    conn.exec_params("INSERT INTO doctors VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING", row[7..10])
    row[7]
  end
  
  def self.insert_test(conn, row, patient_cpf, doctor_crm)
    conn.exec_params("INSERT INTO tests VALUES ($1, $2, $3, $4, $5, $6, $7)", row[11..15].unshift(patient_cpf, doctor_crm))
  end


end