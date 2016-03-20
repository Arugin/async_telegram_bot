module AsyncTelegram
  class User < Base
    attribute :id, Integer
    attribute :first_name, String
    attribute :last_name, String
    attribute :username, String

    def full_name
      if first_name.present?
        name = last_name.present? ? "#{first_name} #{last_name}" : first_name
      else
        name = username
      end
      name
    end
  end
end
