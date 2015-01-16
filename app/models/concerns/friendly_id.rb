module FriendlyId
  extend ActiveSupport::Concern

  def to_param
    display_username
  end

  module ClassMethods
    def find(input)
      if input.to_i.zero?
        find_by(username: input.downcase)
      else
        super
      end
    end
  end
end
