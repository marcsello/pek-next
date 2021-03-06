class Evaluation < ActiveRecord::Base
  self.table_name = "ertekelesek"
  self.primary_key = :id

  before_save :set_default_values

  alias_attribute :entry_request_status, :belepoigeny_statusz
  alias_attribute :timestamp, :feladas
  alias_attribute :point_request_status, :pontigeny_statusz
  alias_attribute :date, :semester
  alias_attribute :justification, :szoveges_ertekeles
  alias_attribute :last_evaulation, :utolso_elbiralas
  alias_attribute :last_modification, :utolso_modositas
  alias_attribute :reviewer_user_id, :elbiralo_usr_id
  alias_attribute :group_id, :grp_id
  alias_attribute :creator_user_id, :felado_usr_id
  alias_attribute :principle, :pontozasi_elvek

  belongs_to :group, foreign_key: :grp_id
  has_many :point_requests, foreign_key: :ertekeles_id
  has_many :entry_requests, foreign_key: :ertekeles_id
  has_many :principles

  NON_EXISTENT = 'NINCS'
  ACCEPTED = 'ELFOGADVA'
  REJECTED = 'ELUTASITVA'
  NOT_YET_ASSESSED = 'ELBIRALATLAN'

  def point_request_accepted?
    point_request_status == ACCEPTED
  end

  def entry_request_accepted?
    entry_request_status == ACCEPTED
  end

  def no_entry_request?
    entry_request_status == NON_EXISTENT
  end

  def accepted
    point_request_accepted? && !next_version
  end

  def date_as_semester
    Semester.new(self.date)
  end

  def set_default_values
    self.point_request_status ||= NON_EXISTENT
    self.entry_request_status ||= NON_EXISTENT
    self.timestamp ||= Time.now
    self.justification ||= ''
    self.last_modification = Time.now
    self
  end

  def started_creation!
    self.point_request_status = NOT_YET_ASSESSED if self.point_request_status == NON_EXISTENT
    self.entry_request_status = NOT_YET_ASSESSED if self.entry_request_status == NON_EXISTENT
    save!
  end

  def update_last_change!
    self.last_modification = Time.now
    save!
  end
end
