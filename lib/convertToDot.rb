#######-- Authors: not_william  cwcdev.net --#######



### the Node class is simply used to make a basic tree data structure.
class Node

  def initialize(fullName, label) 
    #name: newNode = convertToDotRB.Node.new

    @name = fullName
    @label = label
    @children = []
  end
  
  def getLabel 
    #name: nodeGetLabel = convertToDotRB.Node.instance.getLabel

    return @label
  end
  
  ### I want to funnel tree creation through the index() method. (this tree is currently only designed to be used for the DOT graph language format)
  protected def addChild(n)
    #name: nodeAddChild = convertToDotRB.Node.instance.protected.addChild

    @children << n
  end
  

  ### this is the recursive meat and potatoes and meat and potatoes and meat and potatoes...(etc) right here.
  def index(names,labels)
    #name: indexNode = convertToDotRB.Node.instance.index
    #calls: nodeGetLabel, newNode, nodeAddChild, indexNode
    
    select = nil
    @children.each do
      |node|
      ### for each child, if the first label in the list matches the label of the child, then continue on to that node.
      if(labels[0]==node.getLabel)
        select = node
      end
    end

    if(!select)
      select = Node.new(names[0],labels[0])
      self.addChild(select)
    end
    
    if(labels.size == 1)
      return true
    end

    return select.index(names[1...(names.length)],labels[1...(labels.length)])
  end

  ### recursively print the nodes to visualize the tree structure
  def printTree(tabs = 0)
    #name: printTreeNode = convertToDotRB.Node.instance.printTree
    #calls: printTreeNode

    x = "\t"*tabs
    puts x+"----"
    puts x+@name
    puts x+@label
    puts x+"----"
    @children.each do
      |child|
      child.printTree(tabs+1)
    end  
  end

  ### recursively print the nodes but in DOT language format. Leave off the last '}' in order to add the edges afterwards.
  def printTreeDOT(tabs = 0)
    #name: printNodeDOT = convertToDotRB.Node.instance.printTreeDOT
    #calls: printNodeDOT

    isFunc = (@children.length == 0)
    x = "  "

    ### leaves the last brace off to add in the edges afterward. (and then the last brace)
    if @name == "root"
      puts "digraph codeMap{\n"
    else
      if isFunc
        puts (x*tabs) + @name + " [label = \"" + @label + "\"] [style = filled] [color = lightgrey]\n"
      else
        puts (x*tabs) + "subgraph cluster_"+@name+"{\n"+(x*(tabs+1))+"label = \""+@label+"\"\n"+(x*(tabs+1))+"color = blue\n"
      end
    end
    #now recur through the child nodes.
    @children.each do
      |child|
      child.printTreeDOT(tabs+1)
    end

    puts ((x*tabs)+"}\n") unless ((@name == "root") || isFunc)
    
    return
  end
end 






###  take a name like 'pack.pack2.func' and return [ ['pack','pack_pack2','pack_pack2_func'] , ['pack','pack2','func'] ]
def getNamesAndLabels(functionString)
  #name: namesAndLabels = convertToDotRB.getNamesAndLabels

  arr = functionString.chomp.split(".")
  nameString = ""
  names = []
  labels = []
  arr.each do
    |section|
    labels << section
    names << (nameString+section)
    nameString = nameString+section+"_"
  end
  return [names,labels]
end

### for each named function in a collection, see if it has calls, and if so, add each call to a string to be added to the DOT file.
def getCalls(coll)
  #name: getCalls = convertToDotRB.getCalls
  #calls: namesAndLabels

  calls = ""
  coll.each do
    |item|
    if item =~ /;/
      x = item.split(';')
      y = x[1].split(',')
      x = x[0]
      xName = getNamesAndLabels(x)[0][-1]
      y.each do
        |lil_y| ###<- his fire mixtape drops next September. Yeet.
        yName = getNamesAndLabels(lil_y)[0][-1]
        calls = calls + xName+" -> "+yName+"\n"
      end
    end
  end
  return calls
end

def getAliases(lines)
  #name: getDOTAliases = convertToDotRB.getAliases

  ### returns a hash map of aliases and large functions
  aliases = {}
  lines.each do
    |line|
    ### matches 1 and 3 are key and value
    m = line.match(/nam[e]:(\w+(\.\w+)*)=(\w+(\.\w+)*)/)
    if m
      aliases[m[1]] = m[3]
    end
  end
  return aliases
end

def replaceAliases(lines, aliases)
  #name: replaceDOTAliases = convertToDotRB.replaceAliases

  ### remove any aliases in the list and replace :alias\n or :alias, or ,alias, or ,alias\n with the full name.
  ### return the array.
  ret = lines.join("\n") + "\n" # extra \n for the last entry.
  aliases.each do
    |key,value|
    ret.gsub!(/#{key}=/,"")
    ret.gsub!(/:#{key}\n/,":"+value+"\n")
    ret.gsub!(/,#{key}\n/,","+value+"\n")
    ret.gsub!(/:#{key},/,":"+value+",")
    ret.gsub!(/,#{key},/,","+value+",")
  end
  return ret.split("\n")
end

def main()
  #name: dotmain = convertToDotRB.main
  #calls: newNode, namesAndLabels, indexNode, printNodeDOT, getCalls, getDOTAliases, replaceDOTAliases

  collection = []
  allDataString = STDIN.read
  allData = allDataString.split("\n")
  allData = allData.map do
    |x|
    x.gsub(/\s+/,"")
  end
  
  otherData = allData
  a = getAliases(otherData)
  allData = replaceAliases(otherData,a)
  









  ### get one line in advance
  lastLine = allData.shift
  infoLine = ""

  ### get all lines (with one got in advance)
  while nextLine = allData.shift
    ### cut out spaces and match the 'name' line
    name = lastLine.match(/nam[e]:(\w+(\.\w+)*)/)
    if name
      infoLine = name[1]
      ### if the line after the 'name' line is the 'calls' line, then add calls, too.
      call = nextLine.match(/call[s]:((\w+(\.\w+)*)(,\w+(\.\w+)*)*)/)
      if call
        infoLine = infoLine + ";"+ call[1]
      end
    
      ### if at least the 'name' line was found, then add it (and possibly the 'calls') to the collection.
      collection << infoLine
    end

    ### reset the infoLine and shift the current line into the last line.
    infoLine = ""
    lastLine = nextLine
  end

  allNames = []
  collection.each do
    |thing|
    ### since allNames is for adding nodes and not edges, the nodes in 'calls' can be added also. (hence gsub(";",",") before splitting)
    thing.gsub(";",",").split(",").each do
      |little_thing|
      allNames << little_thing
    end
  end

  ### make a root node object to structure the nodes/clusters correctly.
  x = Node.new("root","root")
  allNames.each do
    |name|
    ### the names need to be fully qualified, but the labels are just the node/cluster short name.
    temp = getNamesAndLabels(name)
    ### node.index does the most useful work in this whole script. It structures in a tree recursively based on a full name.
    x.index(temp[0],temp[1])
  end

  x.printTreeDOT(0)

  ### now we worry about adding the edges. Since the nodes are in the right structure, we can just put the edges at the bottom of the file.
  puts
  puts getCalls(collection)

  ### since rootNode.index() leaves off the '}' in order to be able to add in the calls afterward, I need to put it in.
  puts "}"

end




main()

