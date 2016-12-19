RSpec.describe Frecli::Cli do
  describe '.status' do
    context 'when not timing anything' do
      before do
        allow(Frecli).to receive(:timer_current).and_return(nil)
      end

      it 'shows a message describing no timer.' do
        expect { subject.status }
          .to output("No timer running.\n")
          .to_stdout
      end
    end

    context 'when timing something' do
      before do
        timer = FreckleApi::Timer.new(
          project: {
            name: 'Foo'
          },
          formatted_time: 'THE_TIME'
        )

        allow(Frecli)
          .to receive(:timer_current)
          .and_return(timer)
      end

      it 'shows the timer.' do
        expect { subject.status }
          .to output("Timer running on Foo (THE_TIME).\n")
          .to_stdout
      end
    end
  end

  describe '.time' do
    before do
      timer = FreckleApi::Timer.new(
        project: {
          name: 'Foo'
        },
        formatted_time: 'THE_TIME'
      )

      allow(Frecli).to receive(:projects).and_return(
        [
          FreckleApi::Project.new(name: 'Foo'),
          FreckleApi::Project.new(name: 'Bar')
        ]
      )

      allow(Frecli)
        .to receive(:timer_start)
        .with(name: 'Foo')
        .and_return(timer)
    end

    it 'shows a message describing the timed project.' do
      expect { subject.time('f') }
        .to output("Now timing Foo (THE_TIME).\n")
        .to_stdout
    end
  end

  describe '.pause' do
    context 'when not timing anything' do
      before do
        allow(Frecli).to receive(:timer_current).and_return(nil)
      end

      it 'shows a message describing no timer.' do
        expect { subject.status }
          .to output("No timer running.\n")
          .to_stdout
      end
    end

    context 'when timing something' do
      before do
        timer = FreckleApi::Timer.new(
          project: {
            name: 'Foo'
          },
          formatted_time: 'THE_TIME'
        )

        allow(Frecli)
          .to receive(:timer_current)
          .and_return(timer)

        allow(Frecli)
          .to receive(:timer_pause)
          .and_return(timer)
      end

      it 'shows that the timer was paused.' do
        expect { subject.pause }
          .to output("Paused Foo (THE_TIME).\n")
          .to_stdout
      end
    end
  end

  describe '.log' do
    context 'when not timing anything' do
      before do
        allow(Frecli).to receive(:timer_current).and_return(nil)
      end

      it 'shows a message describing no timer.' do
        expect { subject.log }
          .to output("No timer running.\n")
          .to_stdout
      end
    end

    context 'when timing something' do
      before do
        timer = FreckleApi::Timer.new(
          project: {
            name: 'Foo'
          },
          formatted_time: 'THE_TIME'
        )

        allow(Frecli)
          .to receive(:timer_current)
          .and_return(timer)

        allow(Frecli)
          .to receive(:timer_log)
          .with(timer, 'message')
          .and_return(timer)
      end

      it 'shows that the timer was logged, with the given message' do
        expect { subject.log('message') }
          .to output(%(Logged Foo (THE_TIME).\n"message"\n))
          .to_stdout
      end
    end
  end

  describe '.projects' do
    context 'when no projects exist' do
      before do
        allow(Frecli).to receive(:projects).and_return([])
      end

      it 'shows a message describing no projects.' do
        expect { subject.projects }
          .to output("No projects found.\n")
          .to_stdout
      end
    end

    context 'when projects exist' do
      before do
        allow(Frecli).to receive(:projects).and_return(
          [
            FreckleApi::Project.new(name: 'Foo'),
            FreckleApi::Project.new(name: 'Bar')
          ]
        )
      end

      it 'shows a list of projects.' do
        expect { subject.projects }
          .to output("Foo\nBar\n")
          .to_stdout
      end
    end
  end
end
