#######-- Authors: not_william  cwcdev.net --#######
require "graphviz"

def main()
  #name: dotToImageRB.main
  #calls: BASH

  inFile = gets.chomp
  outFile = inFile.split("/")[-1].split(".")[0]+".png"
  outFile = "./"+outFile

  `dot -Tpng #{inFile} -o #{outFile}`

  puts outFile
end

main

