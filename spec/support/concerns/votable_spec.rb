require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

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

  it '#rating_sum' do
    votable = create(model.to_s.underscore.to_sym)
    votable.rating_up(user)
    votable.rating_up(another_user)
    expect(votable.rating_sum).to eq 2
  end


  describe '#vote_of' do
    before do
      @votable = create(model.to_s.underscore.to_sym)
      @votable.rating_up(user)
    end
    it 'returns true if resource has vote of user' do
      expect(@votable).to be_vote_of(user)
    end

    it "returns false if resource hasn't vote of user" do
      expect(@votable).to_not be_vote_of(another_user)
    end
  end
end