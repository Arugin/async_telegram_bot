module AsyncTelegram
  class File < Base
    attribute :file_id, String
    attribute :file_size, Integer
    attribute :file_path, String
  end
end