# This is a script that involves the following.

#  from the console type "ruby xml_2_csv.rb test.xml test.csv"
#  do not forget to install nokogiri and fastcsv before useage of the script.

#  A small script that converts an xml file to csv. Created by Akshay in April 2012
#  Libraries involved: Nokogiri, rubygems, Fastercsv
require 'rubygems'
require 'nokogiri'
require 'fastercsv'

#  The fields for csv file
FIELDS = %w{FCID Lane SampleID SampleRef Index Description Control Recipe Operator }
# A contructor method that stores all the given attributes as titles in the sheet array
def new_sheet(csv, fcid, lane, sampleId, sampleRef, index, description, control, recipe, operator)
  sheet = []
  sheet << fcid
  sheet << lane
  sheet << sampleId
  sheet << sampleRef
  sheet << index
  sheet << description
  sheet << control
  sheet << recipe
  sheet << operator
  #  Adding all of the above attributes to the row.
  csv << FasterCSV::Row.new(FIELDS, sheet)
end
#  Open the second argument ie.csv file in the console to write the details of the xml to it 
csv = FasterCSV.open(ARGV[1],"w")
# Push all the details in the field into the new sheet opened
csv << FIELDS
# Open the first argument in the console i.e xml file to read the details of the xml
doc = Nokogiri::XML(open(ARGV[0]))
#  parsing the xml file 
# collect the flowcellinfo tag with all the attributes
doc.xpath('//FlowcellInfo').each do |fcid|
    
   # Collect the lanes tag values and all the children details from that lane
   doc.xpath('//Lane').each do |lane|
     @samples = lane.element_children
     @samples.each do |sample|
       new_sheet(csv, fcid.attribute('ID'), lane.attribute('Number'), sample.attribute('ID'), sample.attribute('Ref'), sample.attribute('Index'), sample.attribute('Desc'),  sample.attribute('Control'), fcid.attribute('Recipe'), fcid.attribute('Operator'))
     end
   end
end

