RSpec.describe Enumerize::Integrations::RSpec::Matcher do

  let(:model) do
    Class.new do
      extend Enumerize
    end
  end

  subject do
    model.new
  end

  describe '#in' do

    context 'defined as array' do

      before do
        model.enumerize(:sex, :in => [:male, :female])
      end

      it 'accepts the right params as a array' do
        expect(subject).to enumerize(:sex).in(:male, :female)
      end

      xit 'accepts the right params as a hash' do
        expect(subject).to enumerize(:sex).in(male: 0, female: 1)
      end

      xit 'rejects the params as in a wrong order' do
        expect {
          expect(subject).to enumerize(:sex).in(:female, :male)
        }.to fail
      end
    end

    context 'defined as hash' do

      before do
        model.enumerize(:sex, :in => { male: 0, female: 1 })
      end

      it 'accepts the right params as a array' do
        expect(subject).to enumerize(:sex).in(:male, :female)
      end

      xit 'accepts the right params as a hash' do
        expect(subject).to enumerize(:sex).in(male: 0, female: 1)
      end
    end
  end
end
