<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta name='layout' content='main'/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${grailsApplication.config.projectID} species</title>
    <parameter name="search" value="selected"></parameter>
</head>
<body>
  	 <g:if test = "${meta}">
  	 	<br>
  	 	<g:each var="res" in="${meta}">
  	 		<h2><b><i>${res.genus} ${res.species}</i></b></h2> 		
  	 		<table>
  	 			<tr>
  	 				<td width=150> 
	    				<a href = "species_search?id=${res.id}"><img src="${resource(dir: 'images', file: res.image_file)}" width="150" style="float:left;"/></a>
	    			</td>
	    			<td>
	    				<div style="overflow:auto; padding-right:2px; height:150px">
	    					<p>${res.description}</p>
	    					<br><font size="1">Picture supplied by ${res.image_source}</font>
	    				</div>
	    			</td>
	    		</tr>
	    	</table>
		</g:each>
		</table>	
  	 </g:if>
  	 <g:else>
  	 	<h2>There are no species in the database at present, please add some</h2>
  	 </g:else>
  </table>
</body>
</html>