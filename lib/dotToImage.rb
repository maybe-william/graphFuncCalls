#######-- Authors: not_william  cwcdev.net --#######
require "graphviz"

def main()
  inFile = gets.chomp
  outFile = inFile.split("/")[-1].split(".")[0]+".png"
  outFile = "../out/"+outFile

  `dot -Tpng #{inFile} -o #{outFile}`

  puts outFile
end

main

