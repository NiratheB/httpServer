require 'thread'

class ThreadPool

  @job_queue = Queue.new
  @thread_pool =[]

  def initialize(size = 10)
    @thread_pool = []
    @job_queue = Queue.new

    size.times do |i|
      @thread_pool << Thread.new(i) do
        Thread.current[:id]= i

        catch(:exit) do
          loop do
            if(@job_queue.size>0)
              job,arg = @job_queue.pop
              job.call(arg)
            end
          end
        end

      end
    end

  end

  def schedule(job,arg)
    @job_queue.push([job,arg])
  end

  def shutdown
    exitCode= Proc.new do |code|
      throw(code)
    end

    if(@job_queue.size>0)
      print("Please wait!")
      sleep(2*60)
    end

    @thread_pool.each do
      schedule(exitCode,:exit)
    end

    @thread_pool.each do |thread|
      thread.join
    end

  end


end