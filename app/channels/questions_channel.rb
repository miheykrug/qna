class QuestionsChannel < ApplicationCable::Channel
  # def echo(data)
  #   Rails.logger.info data
  #   transmit data
  # end

  def follow
    stream_from 'questions'
  end
end