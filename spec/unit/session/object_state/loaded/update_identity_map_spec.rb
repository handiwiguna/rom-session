require 'spec_helper'

describe Session::ObjectState::Loaded,'#update_identity_map' do
  let(:object)        { described_class.new(mapper,domain_object) }
  let(:mapper)        { DummyMapper.new                           }
  let(:domain_object) { DomainObject.new(:foo,:bar) }

  let(:identity_map)         { {} }

  subject { object.update_identity_map(identity_map) }

  it 'should add object to identity_map' do
    subject
    identity_map.should == { mapper.dump_key(domain_object) => domain_object }
  end

  it 'should return self' do
    should be(object)
  end
end
