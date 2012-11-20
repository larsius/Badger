<%@ page contentType="text/html;charset=UTF-8" %>

<html>
  <head>
    <meta name='layout' content='main'/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${grailsApplication.config.projectID} transcript info</title>
    <parameter name="search" value="selected"></parameter>
  
    <script src="${resource(dir: 'js', file: 'jqplot/jquery.jqplot.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'jqplot/plugins/jqplot.barRenderer.min.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'jqplot/plugins/jqplot.categoryAxisRenderer.min.js')}" type="text/javascript"></script>    
    <script src="${resource(dir: 'js', file: 'jqplot/plugins/jqplot.pointLabels.min.js')}" type="text/javascript"></script> 
    <script src="${resource(dir: 'js', file: 'jquery.scrollTo-1.4.2-min.js')}" type="text/javascript"></script>  
    <script src="${resource(dir: 'js', file: 'jquery-ui-1.8.min.js')}" type="text/javascript"></script> 
    <link rel="stylesheet" href="${resource(dir: 'js', file: 'jqplot/jquery.jqplot.css')}" type="text/css"></link>
    
	<script src="${resource(dir: 'js', file: 'DataTables-1.9.0/media/js/jquery.dataTables.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'TableTools-2.0.2/media/js/TableTools.js')}" type="text/javascript"></script>
    <script src="${resource(dir: 'js', file: 'TableTools-2.0.2/media/js/ZeroClipboard.js')}" type="text/javascript"></script>
    <style type="text/css">
            @import "${resource(dir: 'js', file: 'DataTables-1.9.0/media/css/demo_table.css')}";
            @import "${resource(dir: 'js', file: 'TableTools-2.0.2/media/css/TableTools.css')}";
    </style>
    
            	  <% 	
		  def iprjsonData = ipr_results.encodeAsJSON();
		  def blastjsonData = blast_results.encodeAsJSON();
		  def funjsonData = fun_results.encodeAsJSON();
		  def exonjsonData = exon_results.encodeAsJSON();
		  def jsonAnno = annoLinks.encodeAsJSON();
		  //println fun_results
		  %>  
    <script>
    
    function get_table_data(table){
    	var table_scrape = [];
    	var rowNum
    	var regex
    	if (table == 'blast'){ 
	    	var oTableData = document.getElementById('blast_table_data');
	    	rowNum = 2
	    }else if (table == 'fun'){ 
	    	var oTableData = document.getElementById('fun_table_data');
	    	rowNum = 1
	    }else if (table == 'ipr'){ 
	    	var oTableData = document.getElementById('ipr_table_data');
	    	rowNum = 1
	    }
	    //gets table
	    var rowLength = oTableData.rows.length;
	    //gets rows of table
	    for (i = 0; i < rowLength; i++){
	    //loops through rows
	       var oCells = oTableData.rows.item(i).cells;
	       var cellVal = oCells.item(rowNum).innerHTML;
	       //alert(cellVal)
	       table_scrape.push(cellVal)
	    }
	    //alert(table_scrape)
	    return table_scrape;
	    
    }
    </script>
    <script type="text/javascript">
        /* new sorting functions */
        jQuery.fn.dataTableExt.oSort['scientific-asc']  = function(a,b) {
        	var x = parseFloat(a);
        	var y = parseFloat(b);
        	return ((x < y) ? -1 : ((x > y) ?  1 : 0));
        };
 
        jQuery.fn.dataTableExt.oSort['scientific-desc']  = function(a,b) {
        	var x = parseFloat(a);
        	var y = parseFloat(b);
        	return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
        };
    </script> 
    <script type="text/javascript">  
 		$(function() {
    		// get initial top offset of navigation 
    		var floating_navigation_offset_top = $('#nav_float').offset().top;   
    		// define the floating navigation function
    		var floating_navigation = function(){
            	// current vertical position from the top
    	    	var scroll_top = $(window).scrollTop(); 
	    	    // if scrolled more than the navigation, change its 
                // position to fixed to float to top, otherwise change 
                // it back to relative
        		if (scroll_top > floating_navigation_offset_top) { 
            		$('#nav_float').css({ 'position': 'fixed', 'top':0});
        		} else {
            		$('#nav_float').css({ 'position': 'relative' }); 
        		}   
    		};
     
    		// run function on load
    		floating_navigation();
     
    		// run function every time you scroll
    		$(window).scroll(function() {
         		floating_navigation();
    		});
	});
 	</script>
    <script type="text/javascript" charset="utf-8">
    var blasttableShow="";
    var iprtableShow="";
    var funtableShow="";
    blast_data = ${blastjsonData};	
	ipr_data = ${iprjsonData};
	fun_data = ${funjsonData};
	exon_data = ${exonjsonData};
	aa_data = ${aaData}
	AnnoData = ${jsonAnno};
	//alert(aa_data)
    
    var drawCount=0;
    $(document).ready(function() {   	
    	var anOpen = [];
    	var sImageUrl = "${resource(dir: 'js', file: 'DataTables-1.9.0/examples/examples_support/')}";
    	
    	if (blast_data.length > 0){
    		var blastTable = $('#blast_table_data').dataTable( {
			"bProcessing": true,
			"aaData": ${blastjsonData},
			"aoColumns": [
				{
				   "mDataProp": null,
				   "sClass": "control center",
				   "sDefaultContent": '<img src="'+sImageUrl+'details_open.png'+'">'
				},
				{ "mDataProp": "anno_db"},
				{ "mDataProp": "anno_id",
				"fnRender": function ( oObj, sVal ){
					//alert("id = "+sVal);					
					var db = oObj.aData["anno_db"]
					if (AnnoData[db]){
						var regex = new RegExp(AnnoData[db][0]);
						var link = sVal.replace(regex,"<a href=\""+AnnoData[db][1]+"$1 \" target='_blank'>$1</a>")
						//link = "<a name=\"$1\">"+link+"</a>"
					}
					return link
				}},
				{ "mDataProp": "descr"},
				{ "mDataProp": "anno_start"},
				{ "mDataProp": "anno_stop"},
				{ "mDataProp": "score"},
			],
			"fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull) {
				//<span id=\""+oObj.aData["id"]+"\">
      			$(nRow).attr("id",aData["id"]);
      			return nRow;
      			
    		},
			"sPaginationType": "full_numbers",
			"iDisplayLength": 5,
			"aLengthMenu": [[5,10, 25, 50, 100, -1], [5,10, 25, 50, 100, "All"]],
			"oLanguage": {
					 "sSearch": "Filter records:"
			 },
			"aaSorting": [[ 6, "desc" ]],
			"sDom": 'T<"clear">lfrtip',
			"oTableTools": {
				"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
			},    		
			"fnDrawCallback": function( oSettings ) {    			
    			if (drawCount>0){
    				//alert('redrawHits');
    				drawAnno();
    			}
  			},
		} );
		
	   
	  $('#blast_table_data td.control').live( 'click', function () {
	  var nTr = this.parentNode;
	  var i = $.inArray( nTr, anOpen );
	   
	  if ( i === -1 ) {
		$('img', this).attr( 'src', sImageUrl+"details_close.png" );
		var nDetailsRow = blastTable.fnOpen( nTr, fnFormatBlastDetails(blastTable, nTr), 'details' );
		$('div.innerDetails', nDetailsRow).slideDown();
		anOpen.push( nTr );
	  }
	  else {
		$('img', this).attr( 'src', sImageUrl+"details_open.png" );
		$('div.innerDetails', $(nTr).next()[0]).slideUp( function () {
		  blastTable.fnClose( nTr );
		  anOpen.splice( i, 1 );
		} );
	  }
	} );
	 
	function fnFormatBlastDetails( blastTable, nTr )
	{
	  var oData = blastTable.fnGetData( nTr );
	  var sOut =
		'<div class="innerDetails">'+
		'<div class="blast_res">'+
		  '<table width="100%" cellpadding="5" cellspacing="0" border="0" style="table-layout:fixed; padding-left:10px; overflow:auto;">'+
			'<tr><td><b>Alignment info:</b> Length='+oData.align+' Gaps='+oData.gaps+' Identity='+oData.identity+'</td></tr>'+
			'<tr><td><b>'+oData.mrna_id+'</b> '+oData.anno_start+' '+oData.anno_stop+'</td></tr>'+
			'<tr><td>'+oData.qseq+'</td></tr>'+
			'<tr><td>'+oData.midline+'</td></tr>'+
			'<tr><td>'+oData.hseq+'</td></tr>'+
			'<tr><td><b>'+oData.anno_id+'</b> '+oData.hit_start+' '+oData.hit_stop+'</td></tr>'+
		  '</table>'+
		'</div>'+  
		'</div>';
	   //alert(sOut)
	  return sOut;
	}
		//capture the rows in the tables to use for the image
		//var blastoTable = $('#blast_table_data').dataTable();
		//blasttableShow = blastoTable._('td');
	}
        
		if (fun_data.length > 0){
			$('#fun_table_data').dataTable({
				"sPaginationType": "full_numbers",
				"iDisplayLength": 5,
				"oLanguage": {
						 "sSearch": "Filter records:"
				 },
				"aLengthMenu": [[5,10, 25, 50, 100, -1], [5,10, 25, 50, 100, "All"]],
				"aaSorting": [[ 5, "desc" ]],
				"sDom": 'T<"clear">lfrtip',
				"oTableTools": {
				"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
				},
				"fnDrawCallback": function( oSettings ) {   			
					if (drawCount>0){
						//alert('redrawHits');
						drawAnno();
					}
				},
			 });     
			//capture the rows in the tables to use for the image
			//var funoTable = $('#fun_table_data').dataTable();
			//funtableShow = funoTable._('td');
        }
		
        if (ipr_data.length > 0){
			$('#ipr_table_data').dataTable({
				"sPaginationType": "full_numbers",
				"iDisplayLength": 5,
				"oLanguage": {
						 "sSearch": "Filter records:"
				 },
				"aLengthMenu": [[5,10, 25, 50, 100, -1], [5,10, 25, 50, 100, "All"]],
				"aaSorting": [[ 5, "asc" ]],
				"aoColumns": [
					 null,
					 null,
					 null,
					 null,
					 null,
					 { "sType": "scientific" }
				],
				"sDom": 'T<"clear">lfrtip',
				"oTableTools": {
				"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
				},
				"fnDrawCallback": function( oSettings ) {    			
					if (drawCount>0){
						//alert('redrawHits');
						drawAnno();
					}
				},
			 });  
			//capture the rows in the tables to use for the image
			//var iproTable = $('#ipr_table_data').dataTable();
			//iprtableShow = iproTable._('td');
		}
     
     //exons
     var anOpen = [];
  	 var sImageUrl = "${resource(dir: 'js', file: 'DataTables-1.9.0/examples/examples_support/')}";
     
	 var oTable = $('#exon_table').dataTable( {
			"bProcessing": true,
			"aaData": ${exonjsonData},
			"aoColumns": [
				{
				   "mDataProp": null,
				   "sClass": "control center",
				   "sDefaultContent": '<img src="'+sImageUrl+'details_open.png'+'">'
				},
				{ "mDataProp": "exon_id",
				"fnRender": function ( oObj, sVal ){
					return "<a href=\"/home/browse?link=${metaData.gbrowse}&contig_id="+oObj.aData["contig_id"]+"&start="+oObj.aData["start"]+"&stop="+oObj.aData["stop"]+"\">"+sVal+"</a>";
				}},
				{ "mDataProp": "exon_number" },
				{ "mDataProp": "length" },
				{ "mDataProp": "gc"},
				{ "mDataProp": "phase"},
				{ "mDataProp": "score"},
			],
			"sPaginationType": "full_numbers",
				"iDisplayLength": 10,
				"aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
				"oLanguage": {
						 "sSearch": "Filter records:"
				 },
				"aaSorting": [[ 1, "asc" ]],
				"sDom": 'T<"clear">lfrtip',
				"oTableTools": {
				"sSwfPath": "${resource(dir: 'js', file: 'TableTools-2.0.2/media/swf/copy_cvs_xls_pdf.swf')}"
				}
		} );
		
	   
	  $('#exon_table td.control').live( 'click', function () {
	  var nTr = this.parentNode;
	  var i = $.inArray( nTr, anOpen );
	   
	  if ( i === -1 ) {
		$('img', this).attr( 'src', sImageUrl+"details_close.png" );
		var nDetailsRow = oTable.fnOpen( nTr, fnFormatDetails(oTable, nTr), 'details' );
		$('div.innerDetails', nDetailsRow).slideDown();
		anOpen.push( nTr );
	  }
	  else {
		$('img', this).attr( 'src', sImageUrl+"details_open.png" );
		$('div.innerDetails', $(nTr).next()[0]).slideUp( function () {
		  oTable.fnClose( nTr );
		  anOpen.splice( i, 1 );
		} );
	  }
	} );
	
	function fnFormatDetails( oTable, nTr )
	{
	  var oData = oTable.fnGetData( nTr );
	  var sOut =
		'<div class="innerDetails">'+
		'<div class="blast_res">'+
		  '<table width="100%" cellpadding="5" cellspacing="0" border="0" style="table-layout:fixed; padding-left:10px; overflow:auto;">'+
			'<tr><td><b>Sequence:</b></td></tr>'+
			'<tr><td>'+oData.sequence+'</td></tr>'+
		  '</table>'+
		'</div>'+  
		'</div>';
	   //alert(sOut)
	  return sOut;
	}
     
  //aa chart
  var aa_plot = $.jqplot('aa_chart', [aa_data[0],aa_data[1],aa_data[2],aa_data[3]], {
  		animate: !$.jqplot.use_excanvas,
  		title: 'Amino acid composition',
  		seriesColors: [ "green"],
        seriesDefaults: {
            renderer:$.jqplot.BarRenderer,
            // Show point labels to the right ('e'ast) of each bar.
            // edgeTolerance of -15 allows labels flow outside the grid
            // up to 15 pixels.  If they flow out more than that, they 
            // will be hidden.
            pointLabels: { show: true, location: 'e', edgeTolerance: -15 },
            // Rotate the bar shadow as if bar is lit from top right.
            shadowAngle: 135,
            // Here's where we tell the chart it is oriented horizontally.
            rendererOptions: {
                barDirection: 'horizontal',
				//shadowDepth: 2,
        		//barMargin: 4,
		    }
        },
        series:[
            {label:'Non-polar',color:'orange'},
            {label:'Polar',color:'blue'},
            {label:'Acidic',color:'red'},
            {label:'Basic',color:'green'}
        ],
    	legend: {
            show: true,
            placement: 'outsideGrid',
            //location="s"
        },
        axes: {
        	xaxis: {
				//label: 'Percentage of amino acids',
			},
            yaxis: {
                renderer: $.jqplot.CategoryAxisRenderer
            }
        }
    });
    
    if (blast_data.length > 0 || fun_data.length > 0 || ipr_data.length > 0 ){
     			//draw the figure
     			drawAnno(); 
     		} 
    });
    
    
    </script>
    
    
  </head>
  <body>
  <g:if test="${info_results}">
    <g:link action="">Search</g:link> > <g:link action="species">Species</g:link> > <g:link action="species_search" params="${[Gid:metaData.id]}"><i> ${metaData.genus} ${metaData.species}</i></g:link> > Scaffold:<g:link action="genome_info" params="${[Gid:metaData.id,contig_id:info_results.contig_id[0]]}"> ${info_results.contig_id[0]}</g:link> > Gene: <g:link action="g_info" params="${[Gid:metaData.id,gid:info_results.gene_id[0]]}"> ${info_results.gene_id[0]}</g:link>  > Transcript: ${info_results.mrna_id[0]}
  	<div id="top_anchor"></div>
    <div id="info_anchor"><h1>Information for transcript ${info_results.mrna_id[0]}:</h1></div>
    <table width=100%>
      <tr><td width=40%>
		<table>
			<tr><td><b>Length:</b></td><td>${printf("%,d\n",info_results.nuc[0].length())} bp (${printf("%,d\n",info_results.pep[0].length())} aa)</td></tr>
			<tr><td><b>Exons:</b></td><td>${exon_results.size()}</td></tr>
			<tr><td><b>Source:</b></td><td>${info_results.source[0]}</td></tr>
			<tr><td><b>Scaffold start:</b></td><td>${printf("%,d\n",info_results.start[0])}</td></tr>
			<tr><td><b>Scaffold stop:</b></td><td>${printf("%,d\n",info_results.stop[0])}</td></tr>
			<tr><td><b>Strand:</b></td><td>${info_results.strand[0]}</td></tr>
			<tr><td><b>Download:</b></td>
					<td>
				<div class="inline">
				<g:form name="nucfileDownload" url="[controller:'FileDownload', action:'gene_download']">
					<g:hiddenField name="nucFileId" value="${info_results.gene_id[0]}"/>
					<g:hiddenField name="fileName" value="${info_results.gene_id[0]}"/>
					<g:hiddenField name="seq" value="Nucleotides"/>
					<a href="#" onclick="document.nucfileDownload.submit()">Nucleotides</a>
				</g:form> 
				|
				<g:form name="pepfileDownload" url="[controller:'FileDownload', action:'gene_download']">
					<g:hiddenField name="pepFileId" value="${info_results.gene_id[0]}"/>
					<g:hiddenField name="fileName" value="${info_results.gene_id[0]}"/>
					<g:hiddenField name="seq" value="Peptides"/>
					<a href="#" onclick="document.pepfileDownload.submit()">Peptides</a>
				</g:form>
				</div>
			</td>
			</tr>
		</table> 
    </td>
    
    <td width=60%>
		<div id="aa_chart" class="jqplot-target" style="height: 270px;"></div>
    </td>
    </tr>
    </table>
    
    <div id="nav_float">
		<div class="mid" role="contentinfo">
			<div class="nav_float">
			<ul>
			   <li><a href="javascript:void(0);" onclick="$.scrollTo('#top_anchor', 800, {offset : -50});">Top</a></li>
			   <li><a href="javascript:void(0);" onclick="$.scrollTo('#info_anchor', 800, {offset : -50});">Info</a></li>
			   <g:if test="${blast_results || ipr_results || fun_results}">
				   <!--li><a href="#anno_anchor" class="scroll">Annotations</a></li-->
				    <li><a href="javascript:void(0);" onclick="$.scrollTo('#anno_anchor', 800, {offset : -50});">Annotations</a></li>
			   </g:if>
			   <g:if test="${blast_results}">
				   <li><a href="javascript:void(0);" onclick="$.scrollTo('#blast_anchor', 800, {offset : -50});">BLAST</a></li>
			   </g:if>
			   <g:if test="${fun_results}">
				   <li><a href="javascript:void(0);" onclick="$.scrollTo('#fun_anchor', 800, {offset : -50});">Functional</a></li>
			   </g:if>
			   <g:if test="${ipr_results}">
				   <li><a href="javascript:void(0);" onclick="$.scrollTo('#ipr_anchor', 800, {offset : -50});">InterPro</a></li>
			   </g:if>
			   <g:if test = "${gbrowse}"> 
					<li><a href="javascript:void(0);" onclick="$.scrollTo('#browse_anchor', 800, {offset : -50});">Browse</a></li>
			   </g:if>
			   <li><a href="javascript:void(0);" onclick="$.scrollTo('#files_anchor', 800, {offset : -50});">Sequence data</a></li>
			   <li><a href="javascript:void(0);" onclick="$.scrollTo('#exon_anchor', 800, {offset : -50});">Exons</a></li>
			</ul>
			</div>
		</div>
	</div>
    <g:if test="${blast_results || ipr_results || fun_results}">
        <div id="anno_anchor"><hr size = 5 color="green" width="100%" style="margin-top:10px"></div>  
		  <h1>Annotation overview</h1>  
			  <div id="blast_fig"></div>
      </g:if>
      
      <g:if test="${blast_results}">
		  <div id="blast_anchor"><hr size = 5 color="green" width="100%" style="margin-top:10px"></div>
			   <h1>BLAST results</h1>
		   <table id="blast_table_data" class="display">
			  <thead>
			  <tr>
			<th></th>
			<th><b>Database</b></th>
			<th><b>Hit ID</b></th>
			<th width=50%><b>Description</b></th>
			<th><b>Start</b></th>
			<th><b>Stop</b></th>
			<th><b>Score</b></th>
			  </tr>
			  </thead>
			  <tbody>
			  </tbody>
			</table>
	   </g:if>
	   
	   <g:if test="${fun_results}">
	   <br>
	   <div id="fun_anchor"><hr size = 5 color="green" width="100%" style="margin-top:10px"></div>
	   <h1>Functional annotation results</h1>
	   <table id="fun_table_data" class="display">
	      <thead>
	      <tr>
		<th><b>Database</b></th>
		<th><b>Hit ID</b></th>
		<th><b>Description</b></th>
		<th><b>Start</b></th>
		<th><b>Stop</b></th>
		<th><b>Score</b></th>
	      </tr>
	      </thead>
	      <tbody>
	     <g:each var="res" in="${fun_results}">
	     <tr id="${res.id}">
		<td>${res.anno_db}</td>
		<%
			//set links
			annoLinks.each{
				if (res.anno_db == it.key){
					res.anno_id = res.anno_id.replaceAll(it.value[0], "<a href=\""+it.value[1]+"\$1\" target=\'_blank\'>\$1</a>") 
				}
			}
		%>
		<td>${res.anno_id}</td>
		<td>${res.descr}</td>
		<td>${res.anno_start}</td>
		<td>${res.anno_stop}</td>
		<td>${res.score}</td>
	      </tr>  
	     </g:each>
	      </tbody>
	    </table>
	    </g:if>
	   
	    
	   <br>
	   
	   <g:if test="${ipr_results}">
		   <div id="ipr_anchor"><hr size = 5 color="green" width="100%" style="margin-top:10px"></div>
		   <h1>InterProScan results</h1>
		   <table id="ipr_table_data" class="display">
			 <thead>
			  <tr>
			<th><b>Database</b></th>
			<th><b>Hit ID</b></th>
			<th><b>Description</b></th>
			<th><b>Start</b></th>
			<th><b>Stop</b></th>
			<th><b>Score</b></th>
			  </tr>
			  </thead>
			  <tbody>
			 <g:each var="res" in="${ipr_results}">
			<tr id="${res.id}">
			<td>${res.anno_db}</td>
			<%
			res.anno_id = res.anno_id.replaceAll(/(^IPR\d+)/, "<a href=\"http://www.ebi.ac.uk/interpro/IEntry?ac=\$1\" target=\'_blank\'>\$1</a>")
			%>
			<td>${res.anno_id}</td>
			<td>${res.descr}</td>
			<td>${res.anno_start}</td>
			<td>${res.anno_stop}</td>
			<td>${res.score}</td>
			  </tr>  
			 </g:each>
			 </tbody>
			</table>
	   </g:if> 
     <br>
    
   <g:if test ="${metaData.gbrowse}">
     	<div id="browse_anchor"><div></div>
         	<hr size = 5 color="green" width="100%" style="margin-top:10px">
		 	<h1>Browse on the genome <a href="${metaData.gbrowse}?name=${info_results.contig_id[0].trim()}:${info_results.start[0]}..${info_results.stop[0]}" target='_blank'>(go to genome browser)</a>:</h1>
		 	<iframe src="${metaData.gbrowse}?name=${info_results.contig_id[0].trim()}:${info_results.start[0]}..${info_results.stop[0]}" width="100%" height="700" frameborder="0">
				<img src="${metaData.gbrowse}?name=${info_results.contig_id[0].trim()}:${info_results.start[0]}..${info_results.stop[0]}"/>
		 	</iframe>
		 </div>
     </g:if>

      <div id="files_anchor"><hr size = 5 color="green" width="100%" style="margin-top:10px"></div>
      <h1>FASTA files</h1>
      <div style="overflow:auto; max-height:200px;">
	      <table style="table-layout: fixed; width:100%">
	      <tr><td style="word-wrap: break-word">
	      >${info_results.gene_id[0]}<br>${info_results.pep[0]}
	      </td></tr>
	      </table>
      </div>    
      <div style="overflow:auto; max-height:200px;">
	      <table style="table-layout: fixed; width:100%">
	      <tr><td style="word-wrap: break-word">
	      >${info_results.gene_id[0]}<br>${info_results.nuc[0]}
	      </td></tr>
	      </table>
      </div>      
     
    <div id="exon_anchor"><hr size = 5 color="green" width="100%" style="margin-top:10px"></div>
		<h1>Exons</h1>
		 <table cellpadding="0" cellspacing="0" border="0" class="display" id="exon_table">
		 <thead>
			<tr>
				<th></th>
				<th width=30%>ID</th>
				<th>Number</th>
				<th>Length</th>
				<th>GC</th>
				<th>Phase</th>
				<th>Score</th>
			</tr>
		 </thead>
		 <tbody></tbody>
	     </table> 
     <br>
	<g:if test="${blast_results || ipr_results || fun_results}">
	</g:if>
	<g:else>
	  	<hr size = 5 color="green" width="100%" style="margin-top:10px">
		<h1>There are no annotations for this transcript</h1>
	</g:else>
  </g:if>
  <g:else>
    <h1>The gene ID has no information</h1>
  </g:else>
 	 <script type="text/javascript" src="${resource(dir: 'js', file: 'raphael-min.js')}"></script>
	 <script type="text/javascript" src="${resource(dir: 'js', file: 'g.raphael-min.js')}"></script>
	 <script type="text/javascript" src="${resource(dir: 'js', file: 'g.line-min.js')}"></script>
	 <script type="text/javascript" src="${resource(dir: 'js', file: 'biodrawing.js')}"></script>
	 <script type="text/javascript">
	 	function drawAnno(){
			var drawing = new BioDrawing(); 
			$('#blast_fig').empty();
			drawCount++;
			drawHits()
			function drawHits(){			 	
				 //alert("drawing figure")
				 var paperWidth = $('#blast_fig').width();
				 drawing.start(paperWidth, 'blast_fig');
				 drawing.drawSpacer(40);
				 //add scale bars
				 drawing.drawScoreScale(${info_results.pep[0].length()});	
				 drawing.drawSpacer(20);
				 drawing.drawScale(${info_results.pep[0].length()});			 
				 drawing.drawSpacer(10);
				 
				 // add exon boundaries
				 if (exon_data.length > 0){
					drawing.drawSpacer(10);
					drawing.drawColouredTitle('Exons','black')
					var marker=0
					for (var i = 0; i < exon_data.length; i++) {   		 	 
						var exon = exon_data[i];
						drawing.drawExon(${info_results.pep[0].length()},exon.length/3,marker,exon.exon_number)
						marker = marker + exon.length/3
						//alert('marker='+marker)
					}
					drawing.drawSpacer(20);
					drawing.drawLine(${info_results.pep[0].length()});
				 }
				 if (blast_data.length > 0){
					 drawing.drawSpacer(10);
					 drawing.drawColouredTitle('BLAST','black')
					 var tableData = get_table_data('blast')
					 drawBars(blast_data,tableData,'blast')
					 drawing.drawSpacer(10);
					 drawing.drawLine(${info_results.pep[0].length()});
				 }
				 if (fun_data.length > 0){
					 drawing.drawSpacer(10);
					 drawing.drawColouredTitle('Functional','black')
					 var tableData = get_table_data('fun')
					 drawBars(fun_data,tableData,'fun')
					 drawing.drawSpacer(10);
					 drawing.drawLine(${info_results.pep[0].length()});
				 }
				 if (ipr_data.length > 0){
					 drawing.drawSpacer(10);
					 drawing.drawColouredTitle('InterPro','black')
					 var tableData = get_table_data('ipr')
					 drawBars(ipr_data,tableData,'ipr')
				 }
				 drawing.drawSpacer(10);
				 drawing.end();         
			 }
			 function drawBars(Anno,name,type){
				 var start=''
				 var stop=''
				 var score=''
				 var matched = new Array();
				 for (var i = 0; i < Anno.length; i++) {   		 	 
					 var hit = Anno[i];
					 //get rid of all strange characters
					 var stringy = String(name);
					 var idPattern = hit.anno_id
					 if (AnnoData[hit.anno_db]){
						var regex = new RegExp(AnnoData[hit.anno_db][0]);
						idPattern = idPattern.replace(regex,"$1")
					 }					 
					 //catch the interpro hits
					 idPattern = idPattern.replace(/(^IPR\d+).*/,"$1");
					 if (stringy.match(idPattern)){
					 	 //alert('stringy = '+stringy+' and idPattern = '+idPattern)
						 start = parseFloat(hit.anno_start)
						 stop = parseFloat(hit.anno_stop)
						 if (start > stop){
							 start = parseFloat(hit.anno_stop)
							 stop = parseFloat(hit.anno_start)
						 }
						 score = parseFloat(hit.score) 
						 var hitColour = drawing.getBLASTColour(score,type);
						 var blastRect = drawing.drawBar(start, stop, 7, hitColour, hit.anno_db + ": " + hit.anno_id + "\n" + hit.descr, '');
						 var link_id = hit.id
						 blastRect.click(function(id){
						 		 return function(event){ 
						 		 	var link = $('#' + id);
						 		 	link.effect("highlight", {}, 10000);
						 		 	$.scrollTo('#'+id, 800, {offset : -100});
						 		 	}
								 }(hit.id));
						 blastRect.hover(
							 function(event) {
								this.attr({stroke: 'black', 'stroke-width' : '2'});
								$('#' + hit.anno_id).css("background-color", "bisque");
				
								},
								function(event) {
								this.attr({stroke: 'black', 'stroke-width' : '0'});
								$('#' + hit.anno_id).css("background-color", "white");
								}
						)
					 drawing.drawSpacer(10);
					 matched.push(idPattern);	
					 }	    	    
				 }
				 
		 	}
		 }

	 </script>
		  
	 </body>		 
</html>