require 'socket'
require_relative 'library'


localhost = 'localhost'
port = 2000

server = TCPServer.new(localhost, port)



initPrintFormat
initLogFile

begin

  while (socket = server.accept)
    header, body= socket.recv(1024).split(/\r\n\r\n/, 2)
    if (header=~/POST.*/)
      log = getResponse(body)
      puts log
      writeLog(log)
    end
    showFileToSocket(socket)
    socket.close
  end


rescue Exception => e
  puts e
ensure
  socket.close if socket
  server.close if server
end

