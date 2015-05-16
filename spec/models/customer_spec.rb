require 'rails_helper'
require 'spec_helper'
require 'autotest'

describe Customer do
  before(:each) do
    @customer = FactoryGirl.build(:customer)
  end

  after(:each) do
    @customer.delete
  end

  it 'should have first name' do
    expect(@customer.first_name).not_to be_nil
  end

  it 'should have last name' do
    expect(@customer.last_name).not_to be_nil
  end

  it 'should have age method' do
    @customer.should.respond_to?(:age)
  end

  it 'age should be number' do
    expect(@customer.age['year']).to be_a_kind_of(Fixnum)
  end
end
