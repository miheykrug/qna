FactoryBot.define do
  factory :comment do
    body "My Comment"
    commentable nil
    user nil
  end
end
