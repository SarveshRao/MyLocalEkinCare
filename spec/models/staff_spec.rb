require 'rails_helper'
require 'spec_helper'

describe Staff do
  before(:each) do
    @staff = Staff.create(email: 'staff@ekincare.com', password: 'test1', name: 'CodecPM')
  end

  after(:each) do
    @staff.delete
  end

  it 'should be authenticated' do
    expect(Staff.authenticate('staff@ekincare.com', 'test1')).to be_instance_of Staff
  end

  it 'before save should encrypt password' do
    expect(@staff.password_hash).to be_eql(BCrypt::Engine.hash_secret('test1', @staff.password_salt))
  end
end
