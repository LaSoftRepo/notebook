module ShortID
  extend ActiveSupport::Concern

  included do
    after_initialize :generate_short_id, if: :new_record?
  end

  private

    def generate_short_id
      self.id = DateTime.now.new_offset(0).to_f.to_s.remove('.').to_i.to_s(36)
    end
end
