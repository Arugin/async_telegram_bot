module AsyncTelegram
  class Sticker < Base
    attribute :file_id, String
    attribute :width, Integer
    attribute :height, Integer
    attribute :thumb, PhotoSize
    attribute :file_size, Integer
  end
end
