require 'socket'

def getHeader
  header = ["HTTP/1.1 200 OK", "Content-Type:text/html"]
  response = ""
  header.each do |line|
    response = response + line + "\r\n"
  end
  response
end

server = TCPServer.new('localhost',2223)
begin
  while(socket= server.accept)
    begin
      puts "OK"
      request = socket.read
      puts request
      isGet = (request=~/GET.*/)
      if(isGet)
        response = getHeader+"\r\n"
        socket.print(response)
        fileName = "form.html"
        file = File.open(fileName,"r")
        while(line= file.gets)
          socket.print(line)
        end
        file.close
      end

    rescue Exception =>e
      puts e
    ensure
      puts "Exiting"
      raise
    end
  end

rescue Exception => e
  puts e
  socket.close if socket
  file.close if file
end

=begin
while(socket= server.accept)
  request =socket.gets
  puts request
  isGet = (request=~/GET.*/)
  if(isGet)
    response = getHeader+"\r\n"
    socket.print(response)
    fileName = 'form.html'
    file = File.open(fileName, "r")
    while(line = file.gets)
      socket.print(line)
    end
    file.close
  else
    postMessage = socket.gets
    puts postMessage
  end

  socket.close
end
=end




require 'socket'

def getHeader
  header = ["HTTP/1.1 200 OK", "Content-Type:text/html"]
  response = ""
  header.each do |line|
    response = response + line + "\r\n"
  end
  response
end

localhost = 'localhost'
port = 1234
formFile = "form.html"


server = TCPServer.new(localhost, port)
outputFile = File.open(formFile, "r")

def buildResponseFormat(inputFields)

  regexStr = ""
  addSeparator = false
  inputFields.each do |field|
    if (addSeparator)
      regexStr = regexStr+ "&"
    else
      addSeparator= true
    end
    regexStr= regexStr+ field +"=(.*)"
  end

  return Regexp.new(regexStr)
end

def getResponse(message)
  inputFields = ["field1","field2"]
  format = buildResponseFormat(inputFields)
  log = ""
  count = 1
  if(message=~format)
    inputFields.each do |field|
      varName = "$"+ count.to_s
      log = log+ field + eval(varName)
      count +=1
    end
  end
  puts log
end

begin
  while(socket = server.accept)
    puts "##"

    header,body=  socket.recv(1024).split(/\r\n\r\n/,2)
    if(header=~/GET.*/)
      puts "GET"
      while(line = outputFile.gets)
        socket.print(line)
      end
    else
      puts "POST"
      if(body =~ regex)
        puts $1
        puts $2
      end

    end

    puts "##"
  end
rescue Exception => e
  puts e
ensure
  socket.close if socket
  server.close if server
  outputFile.close if outputFile
end
