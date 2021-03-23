class Patient < ApplicationRecord
  has_many :patient_labs, dependent: :destroy
end
