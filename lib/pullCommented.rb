#######-- Authors: not_william  cwcdev.net --#######


### This file is simply meant to pull any commented areas from a single file and then print all of the commented areas.


#These are the main comment symbols I'm aware of.
comments = [/(#.*?\n|#.*?\z)/, /(\/\/.*?\n|\/\/.*?\z)/, /(\/\*.*?\*\/)/m, /(--.*?\n|--.*?\z)/] #the one with m at the end is multiline.


def main(comments)
  allCode = STDIN.read
  commented = ""
  stillMatching = true


  while(stillMatching) do
    matches = comments.map{
     |reg|
     allCode.match(reg)
    }

    #check if matches or not.
    matches = matches.keep_if do
      |x|
      x
    end
    if matches.length == 0
      stillMatching = false
    end

    break unless stillMatching

    matchInds = matches.map{
      |temp|
      [temp.begin(1),temp.end(1)]
    }

    section = matchInds.inject do
      |prev,current|
      if(prev[0] < current[0])
        prev
      else
        current
      end
    end

    tempString = allCode[section[0]...section[1]]
    allCode = allCode[section[1]...(allCode.length)]

    if tempString[-1] != "\n"
      tempString = tempString + "\n"
    end

    commented = commented + tempString
  end





  print(commented)  
end

main(comments)

