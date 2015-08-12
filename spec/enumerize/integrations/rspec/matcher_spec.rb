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

      it 'rejects wrong params' do
        message = ' expected :sex to allow values: "boy", "girl", but it allows "female", "male" instead'
        expect do
          expect(subject).to enumerize(:sex).in(:boy, :girl)
        end.to fail_with(message)
      end

      xit 'rejects the params in a wrong order' do
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

    it 'has the right description' do
      matcher = enumerize(:sex).in(:male, :female)
      expect(matcher.description).to eq('enumerize :sex in: "female", "male"')
    end
  end

  describe '#with_default' do

    before do
      model.enumerize(:sex, :in => [:male, :female], default: :female)
    end

    it 'accepts the right default value' do
      expect(subject).to enumerize(:sex).in(:male, :female).with_default(:female)
    end

    it 'rejects the wrong default value' do
      message = ' expected :sex to have "male" as default value, but it sets "female" instead'
      expect do
        expect(subject).to enumerize(:sex).in(:male, :female).with_default(:male)
      end.to fail_with(message)
    end

    it 'rejects if the `in` is wrong with a correct default value' do
      message = ' expected :sex to allow values: "boy", "girl", but it allows "female", "male" instead'
      expect do
        expect(subject).to enumerize(:sex).in(:boy, :girl).with_default(:female)
      end.to fail_with(message)
    end

    it 'has the right description' do
      matcher = enumerize(:sex).in(:male, :female).with_default(:female)
      message = 'enumerize :sex in: "female", "male" with "female" as default value'
      expect(matcher.description).to eq(message)
    end
  end
end
