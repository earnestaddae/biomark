require 'json'

module PayloadSync
  class Payload
    response_1 =  {
      "date_of_test": "20210227134300",
      "id_number": "IC000A2",
      "patient_name": "Patient A4",
      "gender": "F",
      "date_of_birth": "19940231",
      "lab_number": "QT196-21-124",
      "clinic_code": "QT196",
      "lab_studies":
      [
        { "code": "2085-9",
          "name": "HDL Cholesterol",
          "value": "cancel",
          "unit": "mg/dL",
          "ref_range": "> 59",
          "finding": "A",
          "result_state": "F"
        }
      ]
    }

    response_2 = {
      "patient_data": {
        "id_number": "IC000A3",
        "first_name": "Patient",
        "last_name": "A5",
        "phone_mobile": "+6500000000",
        "gender": "M",
        "date_of_birth": "19940231"
      },

      "date_of_test": "20210227134300",
      "lab_number": "QT196-21-124",
      "clinic_code": "QT196",
      "lab_studies":
      [
        {
          "code": "2085-9",
          "name": "HDLCholesterol",
          "value": "cancel",
          "unit": "mg/dL",
          "ref_range": "> 59",
          "finding": "A",
          "result_state": "F"
        }
      ]
    }


    payloads = [response_1, response_2]
    @structured_data = []

    # generates structured data
    def generate_structured_data
      payloads.each do |payload|
        gen = JSON.generate(payload)
        @structured_data << JSON.parse(gen, {symbolize_names: true})
      end
    end

    # sync all data from labs
    def self.sync!
      remote_labs = @structured_data
      remote_labs.each do |remote_lab|
        patient = create_patient(remote_lab)
        create_patient_lab(patient, remote_lab)
      end
    end

      private
        # creates a patient entry
        def self.create_patient(payload)
          unless Patient.exists?(id_number: payload[:id_number] || payload[:patient_data][:id_number])
            patient = Patient.create!(
              id_number: payload[:id_number] || payload[:patient_data][:id_number],
              first_name: payload[:patient_name] || payload[:patient_data][:first_name],
              last_name: payload[:patient_name] || payload[:patient_data][:last_name] ,
              date_of_birth: payload[:date_of_birth] || payload[:patient_data][:date_of_birth],
              phone_mobile: "NA" || payload[:patient_data][:phone_mobile],
              gender: payload[:gender] || payload[:patient_data][:gender]
            )
          end
          patient
        end

        # creates a patient lab with the respective patient
        def self.create_patient_lab(patient, payload)
         if !patient.nil?
            patient.patient_labs.create!(
            date_of_test: payload[:date_of_test],
            lab_number: payload[:lab_number],
            clinic_code: payload[:clinic_code],
            lab_studies: payload[:lab_studies]
          )
          end
        end
  end
end
