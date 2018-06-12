class AnswerShowSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best
  has_many :comments
  has_many :attachments
end
