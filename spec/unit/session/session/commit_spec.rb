require 'spec_helper'

describe Session::Session,'#commit' do
  let(:mapper)        { registry.resolve_model(DomainObject) }
  let(:registry)      { DummyRegistry.new                    }
  let(:domain_object) { DomainObject.new                     }
  let(:object)        { described_class.new(registry)        }

  subject { object.commit }

  shared_examples_for 'an uncommitted session' do
    it 'should tell it is uncommitted' do
      object.should be_uncommitted
    end

    it 'should NOT tell it is committed' do
      object.should_not be_committed
    end
  end

  shared_examples_for 'a committed session' do
    it 'should NOT tell it is uncommitted' do
      object.should_not be_uncommitted
    end

    it 'should tell it is committed' do
      object.should be_committed
    end
  end

  context 'when there was no interaction' do
    context 'and commit was NOT called' do
      it_should_behave_like 'a committed session'
    end

    context 'and commit was called' do
      it_should_behave_like 'a committed session'
    end
  end

  context 'when a domain object was marked as update' do

    context 'and domain object was modified' do

      let!(:key_before)  { mapper.dump_key(domain_object) }
      let!(:dump_before) { mapper.dump(domain_object)     }

      shared_examples_for 'a commit with updates' do
        it_should_behave_like 'a committed session'

        it 'should update with the correct key' do
          mapper.updates.should == [[
            key_before,
            mapper.dump(domain_object),
            dump_before
          ]]
        end
      end

      context 'and key did not change' do
        before do
          object.insert(domain_object).commit
          domain_object.other_attribute = :mutated_value
          object.update(domain_object)
        end

        context 'and commit was NOT called' do
          it_should_behave_like 'an uncommitted session'
        end

        context 'and commit was called' do
          before { subject }

          it_should_behave_like 'a commit with updates'
        end
      end
    end

    context 'when domain object was NOT modified' do
      before do
        object.insert(domain_object).commit
        object.update(domain_object)
      end
     
      context 'and commit was NOT called' do
        it_should_behave_like 'an uncommitted session'
      end
     
      context 'and commit was called' do
        before { subject }
     
        it_should_behave_like 'a committed session'
     
        it 'should NOT forward the update to mapper' do
          mapper.updates.should == []
        end
      end
    end
  end

  context 'when a domain object was marked as delete' do
    before do
      object.insert(domain_object).commit
      object.delete(domain_object)
    end

    context 'and commit was NOT called' do
      it_should_behave_like 'an uncommitted session'
    end

    context 'and commit was called' do
      let!(:key_before) { mapper.dump_key(domain_object) }

      before { subject }

      it_should_behave_like 'a committed session'

      it 'should forward the delete to mapper' do
        mapper.deletes.should == [key_before]
      end
    end
  end

  context 'when a domain object was marked as insert' do
    before do
      object.insert(domain_object)
    end

    context 'and commit was NOT called' do
      it_should_behave_like 'an uncommitted session'
    end

    context 'and commit was called' do
      before { subject }

      it_should_behave_like 'a committed session'

      it 'should forward the insert to mapper' do
        mapper.inserts.should == [mapper.dump(domain_object)]
      end
    end
  end
end