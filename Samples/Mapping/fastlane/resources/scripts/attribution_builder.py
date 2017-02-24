#!/usr/bin/python

import csv
import urllib
import urllib2
import shutil
import urlparse
import os
import sys
import StringIO
import getopt
import errno
import json
 
SPREADSHEET_URL = "https://docs.google.com/spreadsheet/pub?key=0AoPUxGWQK9YRdDNMYkUyRVhYa0wybW4zQ09xM1RmZ2c&output=csv" 
AGGREGATION_URL = "https://script.google.com/macros/s/AKfycbz4FqN39y3MEApsgJGDUEW3vQXk3fIL4qXxSBK-1IKKWjaUJFU/exec"
COLUMN_LIBRARY_ID = 3
COLUMN_LIBRARY_NAME = 2
COLUMN_LIBRARY_LICENSE_TEXT = 9
COLUMN_LIBRARY_LICENSE_TYPE = 4
COLUMN_LIBRARY_ATTRIBUTION_REQUIRED = 6
COLUMN_LIBRARY_LEGAL_APPROVAL = 10
VERBOSE = False
ARG_APP_NAME = ''


def removeNonAscii(s): return "".join(i for i in s if ord(i)<128)

class ThirdPartyLibrary:
	def __init__(self, spreadsheetRow):
		if spreadsheetRow:
			self.id = removeNonAscii(spreadsheetRow[COLUMN_LIBRARY_ID].strip())
			self.name = spreadsheetRow[COLUMN_LIBRARY_NAME].strip()
			self.license = spreadsheetRow[COLUMN_LIBRARY_LICENSE_TEXT]
			self.licenseType = spreadsheetRow[COLUMN_LIBRARY_LICENSE_TYPE].strip()
		   
			if spreadsheetRow[COLUMN_LIBRARY_LEGAL_APPROVAL].lower() == "approved":
				self.approved = True;
			else:
				self.approved = False; 

			if spreadsheetRow[COLUMN_LIBRARY_ATTRIBUTION_REQUIRED] == "Yes":
				self.attributionRequired = True;
			else:
				self.attributionRequired = False; 

			log("Library "+self.id+" w/name "+self.name)

	

	def toXML(self):
		return '<notice name="{}" type="{}" approved="{}"><![CDATA[{}]]></notice>'.format(self.name, self.licenseType, str(self.approved).lower(), self.license)

	def toPLIST(self):
		return '<dict><key>Library Name</key><string>{}</string><key>Approved</key><{}/><key>License Type</key><string>{}</string><key>License Text</key><string><![CDATA[{}]]></string></dict>'.format(self.name, str(self.approved).lower(), self.licenseType, self.license)

	def toHTML(self):
		return '<strong class="title">{}</strong><br /><pre class="licenseText">{}</pre>'.format(self.name, self.license)

	def toHTMLBuildPusher(self):
		retVal = ""
		libraryName = ""
		
		retVal += '<li><a href="{}">{}</a></li>'.format(self.id, self.id)

		return retVal

	# Factory method to generate a ThirdPartyLibrary object
	# when all we have is an ID (such as from the list of requested third party libraries)
	@classmethod
	def fromRequestedLibrary(self, id):
		ret = ThirdPartyLibrary(None)
		ret.id = removeNonAscii(id)
		return ret

	def __eq__(self, other):
		return self.id == other.id

def ensure_directory(path):
	try:
		os.makedirs(path)
	except OSError as exception:
		if exception.errno != errno.EEXIST:
			raise

def ensureFieldNames(column_index, actual, expected):
	if str(actual).lower() != str(expected).lower():
		print 'Warning: Column {} expected to be titled "{}" but is actually {}'.format(column_index, expected, actual)

def generateNoticesString(outputType, libraries):
	global ARG_APP_NAME
	output = ''
	if outputType == "xml":
		output += "<notices>"
		for library in libraries:
			output += library.toXML()
		output += '</notices>'
	elif outputType == "plist":
		output += '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><array>'
		for library in libraries:
			output += library.toPLIST()
		output += '</array></plist>'
	elif outputType == "html":
		output = '<html><head><style> body { font-family: sans-serif; } pre { background-color: #eeeeee; padding: 1em; white-space: pre-wrap; } </style></head><body>'
		for library in libraries:
			output += library.toHTML()
		output += '</body></html>'
	elif outputType == "htmlbp":
		log("Creating buildpusher file..")
		outputBP = ''

		# show all unapproved libraries
		rejectedLibrariesHeader = '<h2>Entries from ThirdParty.txt that have not been approved</h2><br /><br />'
		rejectedLibraries = ''
		for library in (l for l in libraries if hasattr(l, 'name')): 
			rejectedLibraries += library.toHTMLBuildPusher()

		if rejectedLibraries:
			outputBP += rejectedLibrariesHeader
			outputBP += "<ul>"+rejectedLibraries+"</ul>"

		# find all missing libraries
		missingLibrariesHeader = '<h2>Entries from ThirdParty.txt not found in Google Doc</h2>'
		missingLibraries = ''
		for library in (l for l in libraries if not hasattr(l, 'name')): 
			missingLibraries += library.toHTMLBuildPusher()


		if missingLibraries:
			outputBP += missingLibrariesHeader
			outputBP += "<ul>"+missingLibraries+"</ul>"
 
		if outputBP:
			output = '<html><head></head><body>'
			output += ARG_APP_NAME + " was just built in release mode and references unapproved third party libraries. <br />"
			output += '<strong>Job:</strong> <a href=\'' + os.environ['BUILD_URL'] +"\'>"+os.environ['BUILD_URL']+"</a>"
			output += "<p>Please address this <strong>ASAP</strong> with your dev manager prior to public release.</p>"
			output += outputBP
			output += "<p>Steps to correct these warnings:</p>"
			output += "<ul>"
			output += "<li>If you have third party entries that are NOT in the <a href=\"https://docs.google.com/a/phunware.com/spreadsheet/ccc?key=0AoPUxGWQK9YRdDNMYkUyRVhYa0wybW4zQ09xM1RmZ2c#gid=0\">Google Doc</a> then please <a href=\"http://goo.gl/pbkLvl\">request them to be added</a>."
			output += "<li>If you have third party entries that are IN the <a href=\"https://docs.google.com/a/phunware.com/spreadsheet/ccc?key=0AoPUxGWQK9YRdDNMYkUyRVhYa0wybW4zQ09xM1RmZ2c#gid=0\">Google Doc</a> but haven't received legal approval, then tell your dev manager.</li>"
			output += "<li>If you have third party entries that have been <strong>REJECTED</strong> then please contact your dev manager."
			output += "</ul>"
			output += '</body></html>'

	   
	else:
		print "Unknown output format requested. ({})".format(outputType)
		sys.exit(1)

	if output:
		output = '<?xml version="1.0" encoding="UTF-8"?>' + output

	return output       

 
   
def usage():
	print 'Usage: attribution_builder.py -l <librarylistfile> -o <noticesoutputfile> -n applicationname [-v]  [-t xml|html|plist]' 
	print '\t-l <path to library list>\tShould be a line delimited list of library IDs from the Third-party authorization request (Responses) spreadsheet.'
	print '\t-o <path to output file>\tSpecify location for notices output file.  Path should include appropriate extension (.plist, .xml, .html)'
	print '\t-n applicationname\tSpecify the name of the application currently being built.  This will be used for aggregating which libraries are used by which apps.'
	print '\t-v \t\t\t\tUse verbose logging.'
	print '\t-t <xml|plist|html>\t\tSpecify output type for notices file. (Default is XML)'
	print '\t-b <path to write buildpusher html>'

def log(message):
	global VERBOSE
	if VERBOSE:
		print message

def main(argv): 
	global VERBOSE
	ARG_INPUT_FILE = ''
	ARG_OUTPUT_FILE = ''
	ARG_OUTPUT_TYPE = 'xml'
	global ARG_APP_NAME
	ARG_BUILD_PUSHER_OUTPUT = ''

	requestedThirdPartyLibraries = []

	if len(argv) == 0:
		usage()
		sys.exit()

	try:
		opts, args = getopt.getopt(argv,"hvl:o:t:n:b:",["librarylistfile=","noticesoutputfile=", "outputtype=", "appname=", "buildpusher="])
	except getopt.GetoptError:
		usage()
		sys.exit(2)   
	for opt, arg in opts:
		if opt == '-h':
			usage()
			sys.exit()
		elif opt in ("-l", "--librarylist"):
			ARG_INPUT_FILE = arg
		elif opt in ("-v", "--verbose"):
			print "Verbose enabled."
			VERBOSE = True
		elif opt in ("-o", "--output"):
			ARG_OUTPUT_FILE = arg
		elif opt in ("-t", "--type"):
			ARG_OUTPUT_TYPE = arg.lower()
		elif opt in ("-n", "--name"):
			ARG_APP_NAME = arg 
		elif opt in ("-b", "--buildpusher"):
			ARG_BUILD_PUSHER_OUTPUT = arg 

	# check our required arguments
	if ARG_INPUT_FILE == '':
		usage()
		print "Error: Must specify librarylist input file. (-l)"
		sys.exit(2)

	if ARG_OUTPUT_FILE == '':
		usage()
		print 'Error: Must specify notices output file. (-o).  Usually you want this to be the location to the assets folder of your project, with a name like "notices.xml".'
		sys.exit(2)

	print "-->" + ARG_INPUT_FILE + "<---"
	print os.path.exists(ARG_INPUT_FILE)

	if os.path.exists(ARG_INPUT_FILE):
		try:
			print "Reading requested library list: " + ARG_INPUT_FILE;
			ins = open(ARG_INPUT_FILE, "r") 

			# only read in lines that don't start with #
			# these lines are considered "commented out"
			for valid_library in (line for line in ins if not line.startswith("#")):  
				requestedThirdPartyLibraries.append(ThirdPartyLibrary.fromRequestedLibrary(valid_library.rstrip()))
			ins.close() 
		except IOError as e:
			print 'Unable to read requested library list: '
			print e
			sys.exit(1)    

	if len(requestedThirdPartyLibraries) == 0:
		print 'No third party libraries requested for this project.  Aborting.'
		sys.exit()

	# Download license spreadsheet as CSV file
	log("Downloading latest spreadsheet...{}".format(SPREADSHEET_URL))
	headers = { 'User-Agent' : 'Mozilla/5.0' }
	req = urllib2.Request(SPREADSHEET_URL, None, headers)
	try: 
		ossCSVData = urllib2.urlopen(req)
	except Exception, e:
		print "Error: Unable to fetch update to spreadsheet."
		print e
		sys.exit(2)   

	# build a list of approved libraries from the Google Docs Spreadsheet
	log("Parsing CSV")
	data = csv.reader(StringIO.StringIO(ossCSVData.read()))
	availableThirdPartyLibraries = [ThirdPartyLibrary(row) for row in data]

	if VERBOSE:
		log("Available third party libraries:")
		for library in availableThirdPartyLibraries:
			print "- {}	{}	Approved: {}".format(library.id, library.name, library.approved)

	# first entry should have the field names
	# let's do a quick sanity check to make sure the field names match what we expect them to
	fieldNames = availableThirdPartyLibraries[0]

	ensureFieldNames(COLUMN_LIBRARY_NAME, fieldNames.name, "Third-Party name")
	ensureFieldNames(COLUMN_LIBRARY_ID, fieldNames.id, "Url")
	ensureFieldNames(COLUMN_LIBRARY_LICENSE_TYPE, fieldNames.licenseType, "License")
	#ensureFieldNames(COLUMN_LIBRARY_ATTRIBUTION_REQUIRED, fieldNames.attributionRequired, "Attribution Required")
	ensureFieldNames(COLUMN_LIBRARY_LICENSE_TEXT, fieldNames.license, "Attribution Notice")

	if fieldNames.name.lower() != "third-party name":
		print 'Warning: Column {} expected to be titled "Third-Party name" but is actually {}'.format(COLUMN_LIBRARY_NAME, fieldNames.name.lower())

	
 
	print "{} third party libraries available.".format(len(availableThirdPartyLibraries)-1)
	print "{} requested third party libraries.".format(len(requestedThirdPartyLibraries))


	print "\n"
	print "The following third party libraries have been requested in this project: "
	for library in requestedThirdPartyLibraries:
		print "\t",library.id

	print "\n"
  
	# check to see if any of our requested libraries are in the spreadsheet and approved and require attribution
	log("Generating notices file...") 

	outputLibraries = []

	# build a payload to send to the aggregation script that tracks which apps use which libraries
	# need:
	# ProjectName (URL encoded)
	# ID - json object that contains list of libraries and their indicies
	# [{index:9, name:"AQuery"}, {index:0, name:"test"}
	aggregationIDs = ""

	unavailableThirdPartyLibraries = []

	for library in requestedThirdPartyLibraries:
		if library in availableThirdPartyLibraries:
			libraryIndex = availableThirdPartyLibraries.index(library)
			log("Requested library ({}) found at index {} ".format(availableThirdPartyLibraries[libraryIndex].name,libraryIndex))

			aggregationID = '{{index: {}, name: "{}"}}'.format( libraryIndex-1, urllib.quote(availableThirdPartyLibraries[libraryIndex].name) ) 

			if aggregationIDs is not "":
				aggregationIDs = aggregationIDs + ","
		 
			aggregationIDs = aggregationIDs + aggregationID
		   
			if availableThirdPartyLibraries[libraryIndex].approved:
				if availableThirdPartyLibraries[libraryIndex].attributionRequired:
					print '"{}" is in approved list and requires attribution.'.format(library.id);
					outputLibraries.append(availableThirdPartyLibraries[libraryIndex])
				else:
					print '"{}" does not require attribution and will be omitted from notices.'.format(availableThirdPartyLibraries[libraryIndex].id)
			else:
				unavailableThirdPartyLibraries.append(availableThirdPartyLibraries[libraryIndex])
				print '"{}" HAS NOT BEEN APPROVED.'.format(availableThirdPartyLibraries[libraryIndex].id)

		else:
			unavailableThirdPartyLibraries.append(library)
			print '"{}" has possibly been explicitly rejected or not submitted yet.'.format(library.id)
 
	output = generateNoticesString(ARG_OUTPUT_TYPE, outputLibraries)  
	log(output) 

	try:
		ensure_directory(os.path.dirname(ARG_OUTPUT_FILE))
		fout = open(ARG_OUTPUT_FILE, "w+")
		fout.write(output)
		fout.close()
		print "\nnotices written to ", ARG_OUTPUT_FILE
	except Exception, e:
		print "Unable to write ",ARG_OUTPUT_FILE
		sys.exit(1)


	if ARG_APP_NAME:
		print "Aggregation enabled....sending aggregation results."

		if ARG_BUILD_PUSHER_OUTPUT:
			print "Buildpusher reporting enabled for this job."
			buildpusher_file = ARG_BUILD_PUSHER_OUTPUT + "/" + "buildpusher_" + ARG_APP_NAME + ".html"

			buildpusher_output = generateNoticesString("htmlbp", unavailableThirdPartyLibraries) 
			log(buildpusher_output)

			try:
				os.remove(buildpusher_file)
			except Exception, e:
				pass

			if buildpusher_output: 
				try:
					ensure_directory(ARG_BUILD_PUSHER_OUTPUT)
					
					fout = open(buildpusher_file, "w+")
					fout.write(buildpusher_output)
					fout.close()
					print "\nbuildpusher output written to ", buildpusher_file
				except Exception, e:
					print "\nUnable to write buildpusher output to ",buildpusher_file
					sys.exit(1)
			else:
				log("No buildpusher output to write.")

		# lameAggregationPayload is a pre urlencoded string.  The python urlencode method keeps converting
		# characters to entites that the aggregation script doesn't expect to be entities (such as
		# double-quotes wrapping a library's name)
		lameAggregationPayload = 'name={}&ids={}'.format(ARG_APP_NAME,aggregationIDs)
	 

		aggregationRequest = urllib2.Request(AGGREGATION_URL, lameAggregationPayload)

		try:
			aggregationResponse = urllib2.urlopen(aggregationRequest)
			if aggregationResponse.getcode() is not 200:
				aggregationResponseTest = aggregationResponse.read()
				print "Warning:  Unable to send libraries to aggregation script: "+aggregationResponseTest
			else:
				print "Aggregation for "+ARG_APP_NAME+" was successful."
		except Exception, e:
			print "Warning:  Unable to rearch the aggregation script: "
			print e

	else:
		print "Warning: Aggregation not enabled for this run, an app name was not provided."

	

if __name__ == "__main__":
   main(sys.argv[1:])