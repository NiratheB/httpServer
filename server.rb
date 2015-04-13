require 'socket'
require_relative 'library'
require_relative 'thread_pool'


localhost = '192.168.2.40'
port = 3000

server = TCPServer.new(localhost, port)



initPrintFormat
initLogFile

serve = Proc.new do |socket|
  header, body= socket.recv(1024).split(/\r\n\r\n/, 2)
  if (header=~/POST.*/)
    log = getResponse(body)
    writeLog(log)
  end
  showFileToSocket(socket)
  socket.close
end


NUMBER_OF_THREADS = 4

threadPool = ThreadPool.new(NUMBER_OF_THREADS)
print("Initialized!\n")

catch(:exit) do
  begin
    while(socket= server.accept)
      if(socket)
        threadPool.schedule(serve, socket)
      end

    end
  rescue Exception=>error
    puts "Shutting down..."
    puts "due to #{error}" if error!=""
    throw(:exit)
  end

end
server.close if server
threadPool.shutdown
puts "The End!"





