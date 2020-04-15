# frozen_string_literal: true

require 'logger'
require 'concurrent_executor/version'

class ConcurrentExecutor
  MAX_NUMBER_OF_THREADS = 100
  attr_accessor :threads, :queue, :number_of_threads, :executor, :logger

  def initialize(number_of_threads: 4, queue_size: 100, executor: nil)
    raise 'queue must be sized' unless queue_size
    raise 'number of threads must be > 0' unless (0..MAX_NUMBER_OF_THREADS).cover?(number_of_threads)

    @errors = Queue.new
    @errored = false

    self.logger = if defined?(Rails)
                    Rails.logger
                  elsif defined?(App) && App.respond_to?(:logger)
                    App.logger
                  else
                    Logger.new(STDERR)
                  end

    self.threads = []
    self.executor = executor
    self.queue = SizedQueue.new(queue_size)
    self.number_of_threads = number_of_threads

    start_threads
  end

  def consume_enumerable(enum)
    enum.each(&queue.method(:push))
  rescue ClosedQueueError
    self.class.logger.warn 'Queue closed during iteration'
  end

  class << self
    def consume_enumerable(enum, **args, &blk)
      executor = new(args.merge(executor: blk))
      executor.consume_enumerable(enum)
    rescue StandardError => e
      puts e
      raise e
    ensure
      executor&.graceful_shutdown
    end
  end

  def graceful_shutdown
    queue.close
    threads.map(&:join)
    raise @errors.pop(false) unless @errors.empty?
  end

  private

  def start_threads
    number_of_threads.times do
      threads << if Thread.respond_to?(:new_traced)
                   Thread.new_traced(&method(:work_loop))
                 else
                   Thread.new(&method(:work_loop))
                 end
    end
  end

  def work_loop
    while (work_item = queue.pop)
      begin
        executor.call(work_item)
      rescue StandardError => e
        @errors << e
        queue.clear
        queue.close
      end
    end
  end
end
