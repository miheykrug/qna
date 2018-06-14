shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(access_token: '123456')
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for "response status" do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for "returns array" do |size, resource_path|
  it "returns resources list" do
    expect(response.body).to have_json_size(size).at_path(resource_path)
  end
end

shared_examples_for "check resources list attributes" do |attr_list|
  attr_list.each do |attr|
    it "resource object contains #{attr}" do
      resource = resources.first
      expect(response.body).to be_json_eql(resource.send(attr.to_sym).to_json).at_path("0/#{attr}")
    end
  end
end
shared_examples_for "check resource attributes" do |attr_list, common_path|
  attr_list.each do |attr|
    it "resource object contains #{attr}" do
      expect(response.body).to be_json_eql(resource.send(attr.to_sym).to_json).at_path("#{common_path}#{attr}")
    end
  end
end
