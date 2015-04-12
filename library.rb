$inputFields = ["field1","field2"]
$numberOfFields = $inputFields.size
$logFileName = "log.txt"
$formFile = "form.html"
$printFormat = ""


def getResponse(message)
  format = buildResponseRegex
  log = Hash.new{""}
  itemNumber = 1
  if( message=~format )
    $numberOfFields.times do

      fieldVar = getVarName(itemNumber)
      fieldName = eval(fieldVar)

      itemNumber +=1

      valueVar = getVarName(itemNumber)
      value = eval(valueVar)

      log[fieldName.to_s]= value.to_s
      itemNumber +=1
    end
  end

  return log
end

def buildResponseRegex(numberOfFields = $numberOfFields)
  regexStr = ""
  addSeparator = false
  numberOfFields.times do
    if (addSeparator)
      regexStr = regexStr+ "&"
    else
      addSeparator= true
    end
    regexStr= regexStr+ "(.*)=(.*)"
  end

  return Regexp.new(regexStr)
end


def getVarName(count)
  fieldVar = "$"+ count.to_s
  return fieldVar
end




def showFileToSocket(socket, filename = $formFile)
  header = getHeader
  header = header+"\r\n"
  socket.print(header)
  file = File.open(filename,"r")
  while(line = file.gets)
    socket.print(line)
  end
  file.close
end

def getHeader
  header = ["HTTP/1.1 200 OK", "Content-Type:text/html"]
  response = ""
  header.each do |line|
    response = response + line + "\r\n"
  end
  return response
end

def correctInput(input)
  input.gsub!('+',' ')
end

def writeLog(log)
  logFile = File.open($logFileName,"a")
  input= []
  $inputFields.each do |field|
    input << log[field].gsub('+',' ')
  end

  mutex = Mutex.new

  mutex.synchronize do
    logFile.printf($printFormat, *input)
  end

  logFile.close

end

def initPrintFormat(numberOfFields = $numberOfFields)
  $printFormat=""
  numberOfFields.times do
    $printFormat += "%10s"
  end
  $printFormat+="\n"


end

def initLogFile(inputFields=$inputFields)
  logFile = File.open($logFileName,"w")
  logFile.printf($printFormat,*inputFields)
  logFile.close
end


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