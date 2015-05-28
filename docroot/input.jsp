<%
/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0"        prefix="portlet" %>

<portlet:defineObjects />
<%//
  // Parallel Application portlet 
  //
%>

<%
// Below the descriptive area of the GATE web form 
%>
<table>
    <tr>
        <td valign="top">
            <img align="left" style="padding:10px 10px;" src="<%=renderRequest.getContextPath()%>/images/AppLogo.png" />
        </td>
        <td>
            Select the parallel application type that you want perform, then 
            fill the following form and press <b>'SUBMIT'</b> button to launch the selected application.<br>
            
            Pressing the <b>'Demo'</b> Button input fields will be filled with Demo values.<br>
            Pressing the <b>'Reset'</b> Button all input fields will be initialized.<br>
            Pressing the <b>'About'</b> Button information about the application will be shown
        </td>
    <tr>
</table align="center">
<%
// Below the application submission web form 
//
// The <form> tag contains a portlet parameter value called 'PortletStatus' the value of this item
// will be read by the processAction portlet method which then assigns a proper view mode before
// the call to the doView method.
// PortletStatus values can range accordingly to values defined into Enum type: Actions
// The processAction method will assign a view mode accordingly to the values defined into
// the Enum type: Views. This value will be assigned calling the function: setRenderParameter
//
%>
<center>
    <form enctype="multipart/form-data" action="<portlet:actionURL portletMode="view"><portlet:param name="PortletStatus" value="ACTION_SUBMIT"/></portlet:actionURL>" method="post">
        <dl>	

            <dd>
                <p><b>Select collection type: </b><select id="collection_type_id" name="collection_type" onchange="resetForm()">
                        <option value="JOB_COLLECTION">Job Collection</option>
                        <option value="WORKFLOW_N1">Workflow N1</option>
                        <option value="JOB_PARAMETRIC">Parametric job</option>
                    </select>
                <p id="task"><b>Insert task number: </b> <input type="text" name="task_number" id="task_number_id"/> <input type="button" value="OK" onClick="updatePage()"/></p>
            </dd>
            <dd>
                <div id="container"> <div/>
            </dd>
            <!-- This block contains: label, file input and textarea for GATE Macro file -->
            <!--dd>		
                <p><b>Application' input file</b> <input type="file" name="file_inputFile" id="upload_inputFileId" accept="*.*" onchange="uploadInputFile()"/></p>
                <textarea id="inputFileId" rows="20" cols="100%" name="inputFile">Insert here your text file, or upload a file</textarea>
            </dd>
            <!-- This block contains the experiment name -->
            <dd>
                <p>Insert below your <b>collection identifier</b></p>
                <textarea id="jobIdentifierId" rows="1" cols="60%" name="JobIdentifier">multi-infrastructure-collection job description</textarea>
            </dd>	
            <!-- This block contains form buttons: Demo, SUBMIT and Reset values -->
            <dd>
            <td><input type="button" value="Demo" onClick="addDemo()"></td>
            <td><input type="button" value="Submit" onClick="preSubmit()"></td> 
            <td><input type="reset" value="Reset values" onClick="resetForm()"></td>
            </dd>
        </dl>
    </form>
    <tr>
    <form action="<portlet:actionURL portletMode="HELP"> /></portlet:actionURL>" method="post">
        <td><input type="submit" value="About"></td>
    </form>        
</tr>
</table>
</center>

<%
// Below the javascript functions used by the GATE web form 
%>
<script type="text/javascript">
    //
    // preSubmit
    //
    function preSubmit() {  
        
        var taskNumber=document.getElementById('task_number_id');
        var jobIdentifier=document.getElementById('jobIdentifierId');
        var executable = "";
        var executables = new Array();
        var arguments = new Array();
        var finalJobExecutalble = "";
        var finalJobArgument = "";
        
        var state_executable            = false;
        var state_argument              = false;
        var state_executables           = false;
        var state_taskNumber            = false;
        var state_jobIdentifier         = false;
        var state_finalJobExecutable    = false;
        
        var index_missingExecutable = -1;
        var index_missingArgument = -1;
        
        if(taskNumber.value == ""){
            state_taskNumber = true;
        } 
        else {
            var selectedCollectionType = document.getElementById('collection_type_id');
            
            switch (selectedCollectionType.value){
                case "JOB_COLLECTION"   :
                    for(var i = 0; i < taskNumber.value; i++){
                        var tmp = document.getElementById('executables'+i);
                        if(tmp.value == ""){
                            index_missingExecutable = i;
                            break;
                        } else {   
                            var argument = document.getElementById('argument'+i);
                            arguments[i]  = argument.value;
                            executables[i] = tmp;
                        }
                    }
                    break;
                case "WORKFLOW_N1":
                    for(var i = 0; i < taskNumber.value; i++){
                        var tmp = document.getElementById('executables'+i);
                        if(tmp.value == ""){
                            index_missingExecutable = i;
                            break;
                        } else{   
                            var argument = document.getElementById('argument'+i);
                            arguments[i]  = argument.value;
                            executables[i] = tmp;
                        }
                    }
                    
                    finalJobArgument = document.getElementById('final_argumentId').value;
                    finalJobExecutalble = document.getElementById('final_executableId').value;
                    
                    if(finalJobExecutalble == "")
                        state_finalJobExecutable = true;
                    break;
                case "JOB_PARAMETRIC":
                    executable = document.getElementById('executable').value;
                    if(executable == ""){
                        state_executable = true;
                    } else {
                        for(var i = 0; i < taskNumber.value; i++){
                  
                            var argument = document.getElementById('argument'+i);
                            if(argument.value!=""){
                                arguments[i]  = argument.value;
                            } else {
                                index_missingArgument = i;
                            }
                        }
                    }
         
                    if(index_missingArgument != -1){
                        state_argument = true;
                    }
                    break;
            }
            
            if(index_missingExecutable != -1){
                state_executables = true;
            }
        }
        
        if(jobIdentifier.value=="") 
            state_jobIdentifier=true;    
       
        var missingFields="";
        if(state_taskNumber){
            missingFields+="  Task Number\n";
        }
        if(state_executable){
            missingFields+="  Missing Executable\n";
        }
        if(state_executables){
            missingFields+="  Executable "+ index_missingExecutable +"\n";
        }
        if(state_argument){
            missingFields+="  Missing Argument "+ index_missingArgument +"\n";
        }
        if (state_jobIdentifier){
            missingFields+="  Collection identifier\n";
        }
        if(state_finalJobExecutable){
            missingFields+="  Final Job Executable\n"
        }
        if(missingFields == "") {
            var stringa = "";
            stringa += "\nTask Number: "+taskNumber.value + "\n";
            for(var i = 0; i < taskNumber.value; i++){
                if(document.getElementById('collection_type_id').value != "JOB_PARAMETRIC"){
                    stringa += "Executables["+i+"]: "+ executables[i].value + "\n";
                } else {
                    stringa += "Executable: " + executable +"\n";
                }
                stringa += "Arguments["+i+"]: "+ arguments[i] + "\n";
            }
            stringa += "FinalJobExecutable: " + finalJobExecutalble + "\n";
            stringa += "FinalJobArgument: " + finalJobArgument + "\n";
            stringa += "Collection Identifier: " + jobIdentifier.value;
            //alert("Submitting " + document.getElementById("collection_type_id").options[document.getElementById("collection_type_id").selectedIndex].text+", parameters: " +stringa);
            document.forms[0].submit();
        }
        else {
            alert("You cannot send an inconsistent "+ document.getElementById("collection_type_id").options[document.getElementById("collection_type_id").selectedIndex].text+"!\nMissing fields:\n"+missingFields);
        }
    }
    
    //
    //  uploadMacroFile
    //
    // This function is responsible to disable the related textarea and 
    // inform the user that the selected input file will be used
    function uploadInputFile(index) {
        var inputFileName=document.getElementById('upload_inputFileId'+index);
        //var inputFileText=document.getElementById('inputFileId');
        if(inputFileName.value!='') {
            //alert("Input file name= " +inputFileName.value);
            //inputFileText.disabled=true;
            //inputFileText.value="Using file: '"+inputFileName.value+"'";
        }
    }

    //
    //  resetForm
    //
    // This function is responsible to enable all textareas
    // when the user press the 'reset' form button
    function resetForm() {
        document.getElementById("collection_type_id").selectdindex = 0;
        document.getElementById('task_number_id').value = "";
        cancel();
        document.getElementById('jobIdentifierId').value = "multi-infrastructure-collection job description";
        //if(document.getElementById('task').style.visibility == 'hidden')
        //    document.getElementById('task').style.visibility = 'visible';
    }

    //
    //  addDemo
    //
    // This function is responsible to fill form with demo values
    function addDemo() {
        var currentTime     = new Date();
        var taskNumber      = document.getElementById('task_number_id');
        taskNumber.value    = 3;
        var jobIdentifier   = document.getElementById('jobIdentifierId');
        var selectedCollectionType = document.getElementById('collection_type_id');
        
        updatePage();
        //var demoExecutables = ('/bin/hostname', '/bin/ls', '/bin/pwd');
        var executables = new Array();
        for(var i = 0; i < taskNumber.value; i++){
            executables[i] = document.getElementById('executables'+i);
        }
        
        ;
        
        switch (selectedCollectionType.value){
            case "JOB_COLLECTION"   :
                executables[0].value = 'hostname';
                executables[1].value = 'ls';
                executables[2].value = 'pwd'
                jobIdentifier.value="Demo Collection: ";
                break;
            case "WORKFLOW_N1":
                executables[0].value = 'hostname';
                executables[1].value = 'ls';
                executables[2].value = 'pwd'
                document.getElementById('final_executableId').value = "ls";
                document.getElementById('final_argumentId').value = "-l";
                jobIdentifier.value="Demo Workflow N1: ";
                break;
            case "JOB_PARAMETRIC"   :
                var executable = document.getElementById('executable');
                executable.value = "echo";
        
                var arguments = new Array();
       
                for(var i = 0; i < taskNumber.value; i++){
                    arguments[i] = document.getElementById('argument'+i).value = "Job "+i;
                }
        
                jobIdentifier.value="Demo Parametric Job: ";
                break;
        }
        //jobIdentifier.value = "Demo Collection";
        jobIdentifier.value+=currentTime.getDate()+"/"+(currentTime.getMonth()+1)+"/"+currentTime.getFullYear()+" - "+currentTime.getHours()+":"+currentTime.getMinutes()+":"+currentTime.getSeconds();
        //var executables = new Array();
    }

    var control = true;
   
    function updatePage(){
        cancel();
        var tablecontents = "";
        var numInput=document.getElementById('task_number_id').value;
        //alert(numInput);
        var selectedCollectionType = document.getElementById('collection_type_id');
         
        tablecontents = "<table>";
        tablecontents +=  "<tr>";
        tablecontents +=  "<th><h3>Sub Jobs</h3></th>";
        tablecontents +=  "</tr>";
        tablecontents +=  "<tr>";
        tablecontents +=  "<th>Executables</th><th>Arguments</th>";
        tablecontents +=  "</tr>";
        
        switch (selectedCollectionType.value){
            case "JOB_COLLECTION"   : 
                
                for (var i = 0; i < numInput; i ++)
                {
                    tablecontents += "<tr>";
                    tablecontents += "<td><input type='text' name='executables' id='executables"+i+"'></input> </td>";
                    tablecontents += "<td><input type='text' name='argument' id='argument"+i+"'> </input></td>";
                    tablecontents += "</tr>";
                }
                
                break;
                
            case "WORKFLOW_N1"   : 
                
                for (var i = 0; i < numInput; i ++)
                {
                    tablecontents += "<tr>";
                    tablecontents += "<td><input type='text' name='executables' id='executables"+i+"'></input> </td>";
                    tablecontents += "<td><input type='text' name='argument' id='argument"+i+"'> </input></td>";
                    tablecontents += "</tr>";
                }
                
                tablecontents +=  "<tr>";
                tablecontents +=  "<th><h3>Final Job</h3></th>";
                tablecontents +=  "</tr>";
                
                tablecontents +=  "<tr>";
                tablecontents +=  "<th>Final Executable</th><th>Argument</th>";
                tablecontents +=  "</tr>";
                
                tablecontents += "<tr>";
                tablecontents += "<td><input type='text' name='final_executable' id='final_executableId'></input> </td>";
                tablecontents += "<td><input type='text' name='final_argument' id='final_argumentId'> </input></td>";
                tablecontents += "</tr>";
                break;
            case "JOB_PARAMETRIC":
                tablecontents += "<tr><td rowspan=" +numInput+ " ><input type='text' name='parametric_executable' id='executable'></input></td>";
                tablecontents += "<td><input type='text' name='argument' id='argument"+0+"'> </input></td>";
                tablecontents += "</tr>";
                for (var i = 1; i < numInput; i ++){
                    tablecontents += "<tr>";
                    tablecontents += "<td><input type='text' name='argument' id='argument"+i+"'> </input></td>";
                    tablecontents += "</tr>";
                }
                break;

        }
        
        tablecontents += "</table>";
        document.getElementById('container').innerHTML+=tablecontents;
        
        control = false;
    }
   
    function cancel(){
        if(control==false){
            var node = document.getElementById("container");
            while(node.firstChild){
                node.removeChild(node.firstChild);
            }
        }
    }

</script>
