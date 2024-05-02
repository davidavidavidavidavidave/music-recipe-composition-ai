require "open-uri"

class Composition < ApplicationRecord
after_save if: -> { saved_change_to_name? || saved_change_to_instruments? || saved_change_to_description? } do
  set_photo
  # set_video
end
has_one_attached :photo
# has_one_attached :video

def content
  if super.blank?
    set_content
  else
    super
  end
end

  private

  def set_content
      client = OpenAI::Client.new
      response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{
          role: "user",
          content: "Give me a music composition with instruments #{self.instruments}. It has musical elements #{self.description}. identify the chords and melody notes and the rhythm values (like crotchets and quavers etc.). Give it a title #{name}"
          }]
      })
      new_content = response["choices"][0]["message"]["content"]

      update(content: new_content)
      return new_content
  end

  def set_photo
    client = OpenAI::Client.new
    response = client.images.generate(parameters: {
      prompt: "Give me an image like an album cover for a music song called #{self.name}, that uses instruments like #{self.instruments} and has musical elements #{self.description}. Ensure the artwork does not have a black background or black border",
      size: "256x256"
    })
    id = response["data"][0]["id"]
    url = response["data"][0]["url"]
    file = URI.open(url)

    photo.purge if photo.attached?
    photo.attach(io: file, filename: "#{self.name}.png", content_type: "image/png")

    return photo

  end

  # def set_video
  #   client = OpenAI::Client.new
  #   response = client.audio.speech(
  #     parameters: {
  #       model: "tts-1",
  #       input: "#{self.content}",
  #       voice: "alloy"
  #     }
  #   )
  #   File.binwrite('demo.mp3', response)
  #   video.purge if video.attached?
  #   video.attach(io: file, filename: "#{self.name}.mp3", content_type: "video/mp3")

  #   return video
  #   # => mp3 file that plays: "This is a speech test!"
  # end

end
