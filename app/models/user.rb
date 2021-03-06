class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include GlobalID::Identification

  field :name, type: String
  field :email, type: String
  field :role, type: String, default: 'user'

  validates_presence_of :name, :email, :role
  validates_uniqueness_of :email
  validates_inclusion_of :role, in: %w(user admin)

  has_many :requested_clinics, class_name: 'Clinic', inverse_of: :requester
  has_many :proposed_clinics, class_name: 'Clinic', inverse_of: :proposer
  has_many :votes
  has_many :confirmations
  has_many :comments

  def admin?
    role == 'admin'
  end

  def votable?(clinic)
    votes.where(clinic_id: clinic.id).empty?
  end

  def confirmable?(clinic)
    confirmations.where(clinic_id: clinic.id).empty?
  end

  def vote!(clinic)
    votes.find_or_create_by!(clinic_id: clinic.id)
  end

  def confirm!(clinic)
    confirmations.find_or_create_by!(clinic_id: clinic.id)
  end
end
