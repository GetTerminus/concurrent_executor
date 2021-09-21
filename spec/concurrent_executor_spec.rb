# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConcurrentExecutor do
  let(:block) { proc {} }

  it 'has a version number' do
    expect(ConcurrentExecutorVersion::VERSION).not_to be nil
  end

  def running_threads
    Thread.list.select(&:alive?)
  end

  around do |ex|
    # No example should leak threads
    expect { ex.run }.not_to(change { running_threads.length })
  end

  describe '.consume_enumerable' do
    it 'passes each enumerable to the provided block' do
      block = ->(a) {}
      expect(block).to receive(:call).with(1)
      expect(block).to receive(:call).with(2)
      expect(block).to receive(:call).with(3)
      expect(block).to receive(:call).with(4)

      ConcurrentExecutor.consume_enumerable([1, 2, 3, 4], &block)
    end

    it 'allows it to receive metadata' do
      expect(block).to receive(:call).with(1, {queue_size: 3})
      expect(block).to receive(:call).with(2, {queue_size: 2})
      expect(block).to receive(:call).with(3, {queue_size: 1})
      expect(block).to receive(:call).with(4, {queue_size: 0})

      ConcurrentExecutor.consume_enumerable([1, 2, 3, 4], &block)
    end


    describe 'throwing errors' do
      it 'throws errors and stop right away when an error is encountered' do
        received = []

        expect do
          ConcurrentExecutor.consume_enumerable((1..10_000)) do |item|
            raise 'it is 178' if item == 178

            received << item
          end
        end.to raise_error 'it is 178'

        expect(received.length).to be < 200
      end
    end
  end
end
