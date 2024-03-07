def create_tables(conn)
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
