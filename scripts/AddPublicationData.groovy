package GDB

import groovy.sql.Sql

def grailsApplication
def matcher
def idlist = new File("/tmp/idlist.txt")
def pubdata = new File("/tmp/pubdata.txt")
if (idlist.exists()){idlist.delete()}
if (pubdata.exists()){pubdata.delete()}

getPub()
def getPub(){
	println "Adding publication data..."
	//get the pubmed data
	def utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";
	def db = 'PubMed';
	def query = grailsApplication.config.species
	//make sure all words are used in search
	query = query.replace(" ","+AND+")
	def esearch = "$utils/esearch.fcgi?db=$db&retmax=100000&term=$query";
	println "Searching PubMed for all articles containing '"+grailsApplication.config.species+"'"
	println "Getting IDs...";
	println esearch
	def idlist = new File("/tmp/idlist.txt")
	idlist << new URL(esearch).getText()
	def esearch_result=new File("/tmp/idlist.txt").text
	def counter=0
	def efetch_ids=''
	def pubdata = new File("/tmp/pubdata.txt")
	esearch_result.split("\n").each{
		if ((matcher = it =~ /.*?<Id>(\d+)<\/Id>/)){
			efetch_ids += matcher[0][1] + ","
			counter++
			//get the data in batches as fails if url is too long
			if ((counter % 100) ==  0){
				efetch_ids = efetch_ids[0..-2]
				println "Fetching "+counter			
				def efetch = "$utils/efetch.fcgi?db=$db&id=$efetch_ids&retmode=xml";
				pubdata << new URL(efetch).getText()
				efetch_ids=''
			}
		}
	}
	//get the last ones
	efetch_ids = efetch_ids[0..-2]
	println "Fetching "+counter			
	def efetch = "$utils/efetch.fcgi?db=$db&id=$efetch_ids&retmode=xml";
	pubdata << new URL(efetch).getText()
	addPub(pubdata) 
}
//add info
def addPub(pubFile){
	def dataSource = ctx.getBean("dataSource")
	def sql = new Sql(dataSource)
	println "Deleting old data..."
	def delsql = "delete from Publication;";
	sql.execute(delsql)
	println "Adding data to db..."
	def pubMap = [:]
	int count_all = 0
	def dateString = ''
	def nameString = ''
	def year = ''
	def month = ''
	def day = ''
	def firstname = '' 
	def lastname = ''
	boolean indate = false
	pubFile.eachLine { line ->		
		if ((matcher = line =~ /<ArticleId IdType="pubmed">(.*?)<\/ArticleId>/)){
				pubMap.pubmedId = matcher[0][1]
				count_all++
		}        
		else if ((matcher = line =~ /<ArticleTitle>(.*?)<\/ArticleTitle>/)){
				pubMap.title =  matcher[0][1]    
		}
		else if ((matcher = line =~ /<AbstractText>(.*?)<\/AbstractText>/)){
				pubMap.abstractText =  matcher[0][1]    
		}
		else if ((matcher = line =~ /<Title>(.*?)<\/Title>/)){
				pubMap.journal = matcher[0][1]
		}
		else if ((matcher = line =~ /<ISOAbbreviation>(.*?)<\/ISOAbbreviation>/)){
				pubMap.journal_short = matcher[0][1]
		}
		else if ((matcher = line =~ /<Volume>(.*?)<\/Volume>/)){
				pubMap.volume = matcher[0][1]
		}
		else if ((matcher = line =~ /<Issue>(.*?)<\/Issue>/)){
				pubMap.issue = matcher[0][1]
		}
		//use initials for first name as some entries have no first names!
		else if ((matcher = line =~ /<Initials>(.*?)<\/Initials>/)){
				firstname = matcher[0][1]
				nameString += firstname + " " + lastname + ", "
		}
		else if ((matcher = line =~ /<LastName>(.*?)<\/LastName>/)){
				lastname = matcher[0][1]
		}
		else if ((matcher = line =~ /<PubMedPubDate PubStatus="pubmed">/)){
				indate = true       		
		}       	
		else if ((matcher = line =~ /<\/PubMedPubDate>/)){
				indate = false
		}
		else if ((matcher = line =~ /<ArticleId IdType="doi">(.*?)<\/ArticleId>/)){
				pubMap.doi = matcher[0][1]
		}

		//get date data       
		else if (indate){
			if ((matcher = line =~ /<Year>(.*?)<\/Year>/)){
				year = matcher[0][1]
			}
			if ((matcher = line =~ /<Month>(.*?)<\/Month>/)){
				month = matcher[0][1]
			}
			if ((matcher = line =~ /<Day>(.*?)<\/Day>/)){
				day = matcher[0][1]
				dateString = year + "/" + month + "/" + day
				println "dateString = "+dateString
				pubMap.dateString = dateString
			}       	
		}
		//end of an entry
		else if ((matcher = line =~ /<\/PubmedArticle>/)){
			nameString = nameString[0..-3]
			pubMap.authors = nameString
			nameString = ''
			dateString = ''            
			//println pubMap
			if ((count_all % 100) ==  0){
				println "Adding "+count_all
				new Publication(pubMap).save(flush:true)
			}else{
				new Publication(pubMap).save()
			}
		}
	}
	println "Added "+count_all 
}
//remove the tmp pubmed files
println "Deleting tmp pubmed files..."
idlist.delete()
pubdata.delete()
