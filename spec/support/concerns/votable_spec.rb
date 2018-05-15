require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it '#rating_up' do
    votable = create(model.to_s.underscore.to_sym)
    votable.rating_up(user)
    expect(Vote.last.rating).to eq 1
    expect(Vote.last.user).to eq user
    expect(Vote.last.votable).to eq votable
  end

  it '#rating_down' do
    votable = create(model.to_s.underscore.to_sym)
    votable.rating_down(user)
    expect(Vote.last.rating).to eq -1
    expect(Vote.last.user).to eq user
    expect(Vote.last.votable).to eq votable
  end
end