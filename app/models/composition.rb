class Composition < ApplicationRecord
after_save :set_content, if: -> { saved_change_to_instruments? || saved_change_to_description? }

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
          content: "Give me a music composition with instruments #{self.instruments}. It has musical elements #{self.description}. identify the chords and melody notes and the rhythm values (like crotchets and quavers etc.). Give it a title"
          }]
      })
      new_content = response["choices"][0]["message"]["content"]

      update(content: new_content)
      return new_content
  end

end
