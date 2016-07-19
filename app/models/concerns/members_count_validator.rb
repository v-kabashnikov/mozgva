class MembersCountValidator < ActiveModel::Validator
  def validate(record)
    if record.team.full?
      record.errors.add(:team, "team is full")
    end
  end
end
