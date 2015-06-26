tree {
  source_name "Kinetic Request"
  source_group "Shared Trees"
  name "Send Template Email Notification v1"
  subtree_id "send_template_email_v1"
  status "Active"
  definition <<-DEFINITION
    <taskTree builder_version='3.1.0' schema_version='1.0' version=''>
      <name>Send Template Email Notification v1</name>
      <author/>
      <notes/>
      <lastID>58</lastID>
      <taskDefinition id='tree_send_template_email_v1' name='Send Template Email Notification v1' schema_version='1.0' version='1'>
        <visible>false</visible>
        <deferrable>true</deferrable>
        <parameters>
          <parameter id='Email Addresses To Email' label='Email Addresses To Email' required='false' tooltip='List of comma delimited email addresses to email'/>
          <parameter id='Login IDs To Email' label='Login IDs To Email' required='false' tooltip='List of comma delimited login ids to email (email addresses looked up in CTM:People)'/>
          <parameter id='Email Template Name' label='Email Template Name' required='true' tooltip=''/>
          <parameter id='Format Answers' label='Format Answers' required='false' tooltip=''/>
          <parameter id='JSON Misc.' label='JSON Misc.' required='false' tooltip='JSON input of miscellaneous values'/>
          <parameter id='Request Instance ID' label='Request Instance ID' required='false' tooltip='instanceId of the Kinetic Request submission to get answers/dataset for'/>
          <parameter id='Region' label='Region' required='false' tooltip='Region to send the message to/for, recommended if using predefined recipients'/>
          <parameter id='Language' label='Language' required='false' tooltip='Language to send the message in, recommended if using predefined recipients'/>
          <parameter id='Catalog' label='Catalog' required='true' tooltip=''/>
        </parameters>
        <handler name='system_tree_call' version='1'/>
        <results format='xml'/>
      </taskDefinition>
      <request>
        <task definition_id='system_start_v1' id='start' name='Start' x='-13' y='604'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters/>
          <messages/>
          <dependents>
            <task label='' type='Complete' value=''>utility_json_to_results_v2_13</task>
            <task label='Request Id not nil' type='Complete' value=' !@inputs[&apos;Request Instance ID&apos;].nil? &amp;&amp; @inputs[&apos;Request Instance ID&apos;].length &gt; 0 '>kinetic_request_submission_base_retrieve_v1_26</task>
            <task label='Request Id Not Nil' type='Complete' value=' !@inputs[&apos;Request Instance ID&apos;].nil? &amp;&amp; @inputs[&apos;Request Instance ID&apos;].length &gt; 0 '>kinetic_request_answers_all_retrieve_v1_27</task>
            <task label='Request Id not nil' type='Complete' value=' !@inputs[&apos;Request Instance ID&apos;].nil? &amp;&amp; @inputs[&apos;Request Instance ID&apos;].length &gt; 0 '>kinetic_request_submission_dataset_retrieve_v1_28</task>
          </dependents>
        </task>
        <task definition_id='system_tree_return_v1' id='system_tree_return_v1_3' name='Tree Return' x='2533' y='679.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters/>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents/>
        </task>
        <task definition_id='system_loop_head_v1' id='system_loop_head_v1_6' name='Email Address Loop Start' x='994.6875' y='347.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='data_source' label='Data Source:' menu='' required='true' tooltip='The source that contains the data to use to create each task in the loop.'>&lt;%=@results['Email Address List to XML']['XML']%&gt;</parameter>
            <parameter id='loop_path' label='Loop Path:' menu='' required='true' tooltip='The XPath statement to indicate what data records to process.'>//list/item</parameter>
            <parameter id='var_name' label='Variable Name:' menu='' required='true' tooltip='The local variable name used to represent the data used in loop tasks.'>loopTempVar</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_loop_tail_v1_7</task>
            <task type='Complete' label='' value=''>helper_form_notification_content_lookup_v1_56</task>
          </dependents>
        </task>
        <task definition_id='system_loop_tail_v1' id='system_loop_tail_v1_7' name='Email Address Loop End' x='1443.6875' y='358.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='type' label='Type:' menu='All,Some,Any' required='true' tooltip='How many loop processes must be completed before continuing?'>All</parameter>
            <parameter dependsOnId='type' dependsOnValue='Some' id='number' label='Number:' menu='' required='false' tooltip='If some, how many?'/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>utility_csv_to_xml_v1_14</task>
          </dependents>
        </task>
        <task definition_id='utility_csv_to_xml_v1' id='utility_csv_to_xml_v1_9' name='Email Address List to XML' x='833.6875' y='347.078125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='csv' label='CSV' menu='' required='true' tooltip=''>&lt;%=@inputs['Email Addresses To Email']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_loop_head_v1_6</task>
          </dependents>
        </task>
        <task definition_id='utility_json_to_results_v2' id='utility_json_to_results_v2_13' name='Misc. Inputs' x='123.6875' y='717.078125'>
          <version>2</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='json' label='JSON String' menu='' required='true' tooltip='The json string to be converted.'>
              &lt;%= if @inputs.has_key?('JSON Misc.') &amp;&amp; !@inputs['JSON
              Misc.'].nil? &amp;&amp; @inputs['JSON Misc.'].length &gt; 0 then
              @inputs['JSON Misc.'] else '{}' end %&gt; 
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>kinetic_request_service_item_attribute_retrieve_v1_36</task>
          </dependents>
        </task>
        <task definition_id='utility_csv_to_xml_v1' id='utility_csv_to_xml_v1_14' name='Login ID List to XML' x='1606.6875' y='359.078125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='csv' label='CSV' menu='' required='true' tooltip=''>&lt;%=@inputs['Login IDs To Email']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_loop_head_v1_15</task>
          </dependents>
        </task>
        <task definition_id='system_loop_head_v1' id='system_loop_head_v1_15' name='Login ID Loop Start' x='1773.6875' y='357.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='data_source' label='Data Source:' menu='' required='true' tooltip='The source that contains the data to use to create each task in the loop.'>&lt;%=@results['Login ID List to XML']['XML']%&gt;</parameter>
            <parameter id='loop_path' label='Loop Path:' menu='' required='true' tooltip='The XPath statement to indicate what data records to process.'>//list/item</parameter>
            <parameter id='var_name' label='Variable Name:' menu='' required='true' tooltip='The local variable name used to represent the data used in loop tasks.'>tempLoopVar</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_loop_tail_v1_16</task>
            <task label='' type='Complete' value=''>bmc_itsm7_person_retrieve_v1_20</task>
          </dependents>
        </task>
        <task definition_id='system_loop_tail_v1' id='system_loop_tail_v1_16' name='Login ID Loop End' x='2227.6875' y='353.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='type' label='Type:' menu='All,Some,Any' required='true' tooltip='How many loop processes must be completed before continuing?'>All</parameter>
            <parameter dependsOnId='type' dependsOnValue='Some' id='number' label='Number:' menu='' required='false' tooltip='If some, how many?'/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_junction_v1_55</task>
          </dependents>
        </task>
        <task definition_id='bmc_itsm7_person_retrieve_v1' id='bmc_itsm7_person_retrieve_v1_20' name='Retrieve Person Details' x='1757.6875' y='242.5'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>true</visible>
          <parameters>
            <parameter id='remedy_login_id' label='Remedy Login ID:' menu='' required='true' tooltip='The Remedy Login ID associated to the CTM People record to retrieve'>&lt;%=@results['Login ID Loop Start']['Value']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>helper_form_language_preference_lookup_v1_58</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_submission_base_retrieve_v1' id='kinetic_request_submission_base_retrieve_v1_26' name='Base' x='204.6875' y='576.1875'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='Submission ID' label='Submission ID' menu='' required='true' tooltip='Enter the Customer Survey ID or instanceId of the KS_SRV_CustomerSurvey_base form'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_junction_v1_31</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_answers_all_retrieve_v1' id='kinetic_request_answers_all_retrieve_v1_27' name='Answers' x='216.6875' y='516.796875'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='Submission ID' label='Submission ID' menu='' required='true' tooltip='Submission Instance ID'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_junction_v1_31</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_submission_dataset_retrieve_v1' id='kinetic_request_submission_dataset_retrieve_v1_28' name='Dataset' x='214.6875' y='643.78125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='Submission ID' label='Submission ID' menu='' required='true' tooltip='CustomerSurveyInstanceId or CustomerSurveyID on KS_CustomerSurvey'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task label='' type='Complete' value=''>system_junction_v1_31</task>
          </dependents>
        </task>
        <task definition_id='smtp_email_send_v1' id='smtp_email_send_v1_29' name='Send Email - Addresses' x='1252.6875' y='204.09375'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>true</visible>
          <parameters>
            <parameter id='from' label='From (email address)' menu='' required='true' tooltip='The email address of the simulated sender.'>from@yourdomain.com</parameter>
            <parameter id='to' label='To (email address)' menu='' required='true' tooltip='The email address of the intended recipient.'>&lt;%=@results['Email Address Loop Start']['Value']%&gt;</parameter>
            <parameter id='subject' label='Subject' menu='' required='false' tooltip='The subject of the email.'>
              &lt;%= content="" content=@results['Get Notification Content -
              Email']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='htmlbody' label='HTML Body' menu='' required='false' tooltip='HTML representing the body of a rich email.'>
              &lt;%= content="" content=@results['Get Notification Content -
              Email']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='textbody' label='Alternate (text) Body' menu='' required='false' tooltip='A plaintext message that will be displayed if the recipient can&apos;t display multipart HTML emails.'>
              &lt;%= content="" content=@results['Get Notification Content -
              Email']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_join_v1_49</task>
          </dependents>
        </task>
        <task definition_id='smtp_email_send_v1' id='smtp_email_send_v1_30' name='Send Email - IDs' x='1995' y='186'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>true</visible>
          <parameters>
            <parameter id='from' label='From (email address)' menu='' required='true' tooltip='The email address of the simulated sender.'>from@yourdomain.com</parameter>
            <parameter id='to' label='To (email address)' menu='' required='true' tooltip='The email address of the intended recipient.'>&lt;%=@results['Retrieve Person Details']['Email']%&gt;</parameter>
            <parameter id='subject' label='Subject' menu='' required='false' tooltip='The subject of the email.'>
              &lt;%= content="" content=@results['Get Notification Content - Login
              ID']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end content=content.gsub(/&lt;PERSON
              DETAILS&gt;(.*?)&lt;\/PERSON DETAILS&gt;/) do @results['Retrieve
              Person Details'][$1] end
              content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='htmlbody' label='HTML Body' menu='' required='false' tooltip='HTML representing the body of a rich email.'>
              &lt;%= content="" content=@results['Get Notification Content - Login
              ID']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end content=content.gsub(/&lt;PERSON
              DETAILS&gt;(.*?)&lt;\/PERSON DETAILS&gt;/) do @results['Retrieve
              Person Details'][$1] end
              content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt; 
            </parameter>
            <parameter id='textbody' label='Alternate (text) Body' menu='' required='false' tooltip='A plaintext message that will be displayed if the recipient can&apos;t display multipart HTML emails.'>
              &lt;%= content="" content=@results['Get Notification Content - Login
              ID']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_join_v1_54</task>
          </dependents>
        </task>
        <task definition_id='system_junction_v1' id='system_junction_v1_31' name='Junction' x='475.6875' y='607.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters/>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>helper_form_notification_content_lookup_v1_34</task>
            <task type='Complete' label='' value=''>utility_csv_to_xml_v1_9</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_attachment_retrieve_v2' id='kinetic_request_attachment_retrieve_v2_33' name='Attachment' x='1430.6875' y='632.359375'>
          <version>2</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='content_type' label='Content Type:' menu='Plain,Base64' required='true' tooltip='The content type either plain text or base 64 encoded.'>Plain</parameter>
            <parameter id='attachment_question_menu_label' label='Attachment Question Menu Label:' menu='' required='false' tooltip='The menu label of an attachment question to retrieve an attachment from.'>&lt;%=@results['Get Attachment Name']['output']%&gt;</parameter>
            <parameter id='customer_survey_instance_id' label='Request Instance ID:' menu='' required='true' tooltip='The instance ID of a request to retrieve an attachment from.'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
            <parameter id='survey_template_instance_id' label='Template Instance ID:' menu='' required='true' tooltip='The instance ID of a template to retrieve an attachment from.'>&lt;%=@results['Get Template ID']['Attribute Value']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='Predefined' value='!@results[&apos;Get Base Notification&apos;][&apos;Recipient&apos;].nil?'>smtp_email_with_attachment_send_v1_37</task>
          </dependents>
        </task>
        <task definition_id='helper_form_notification_content_lookup_v1' id='helper_form_notification_content_lookup_v1_34' name='Get Base Notification' x='610.6875' y='646.859375'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='messagename' label='Message Name:' menu='' required='true' tooltip='The name of the message to be sent.  This is used to lookup the appropriate content in the KS_SRV_Helper form'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
            <parameter id='region' label='Region:' menu='' required='false' tooltip='The region (if available) of the person that the email is to be sent to'>&lt;%=@inputs['Region']%&gt;</parameter>
            <parameter id='language' label='Language:' menu='' required='false' tooltip='The language (if available) that the message should be sent in'>&lt;%=@inputs['Language']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='LoginIDs' value='@results[&apos;Get Base Notification&apos;][&apos;Recipient Type&apos;] == &quot;Login ID&quot;'>utility_csv_to_xml_v1_39</task>
            <task type='Complete' label='Email' value='@results[&apos;Get Base Notification&apos;][&apos;Recipient Type&apos;]==&quot;SMTP&quot;'>system_join_v1_45</task>
          </dependents>
        </task>
        <task definition_id='utilities_echo_v1' id='utilities_echo_v1_35' name='Get Attachment Name' x='1104.6875' y='618.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='input' label='Input' menu='' required='true' tooltip=''>
               &lt;%=attachmentName="" bodyText="" if @results['Get Base
              Notification']['Body'].includes?("&lt;ATTACHMENT&gt;")
              bodyText=@results['Get Base
              Notification']['Body'].split("&lt;ATTACHMENT&gt;")
              bodyText1=bodyText[1].split("&lt;/ATTACHMENT&gt;")
              attachmentName=bodyText1[0] end subjectText="" if @results['Get Base
              Notification']['Subject'].includes?("&lt;ATTACHMENT&gt;")
              subjectText=@results['Get Base
              Notification']['Subject'].split("&lt;ATTACHMENT&gt;")
              subjectText1=subjectText[1].split("&lt;/ATTACHMENT&gt;")
              attachmentName=subjectText1[0] end attachmentName %&gt; 
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>kinetic_request_attachment_retrieve_v2_33</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_service_item_attribute_retrieve_v1' id='kinetic_request_service_item_attribute_retrieve_v1_36' name='Get Template ID' x='328.6875' y='704.125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='catalog_name' label='Catalog Name' menu='' required='true' tooltip='The catalog name of the service item this handler will query for the given attribute'>&lt;%=@inputs['Catalog']%&gt;</parameter>
            <parameter id='service_item_name' label='Service Item Name' menu='' required='true' tooltip='The name of the service item this handler will query for the given attribute'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
            <parameter id='attribute_name' label='Attribute Name' menu='' required='true' tooltip='The name of the attribute that this handler will query for'>ServiceItemTemplateID</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_junction_v1_31</task>
          </dependents>
        </task>
        <task name='Send Email - Predefined Recipients - Attachment' id='smtp_email_with_attachment_send_v1_37' definition_id='smtp_email_with_attachment_send_v1' x='1675' y='614.640625'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='to' label='To' required='true' tooltip='A comma separated list of email address to be used as the intended recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''>
              &lt;%=if @results.has_key?('Collect Emails') @results['Collect
              Emails']['output'] else @results['Get Base Notification']['Recipient']
              end%&gt;
            </parameter>
            <parameter id='cc' label='CC' required='false' tooltip='A comma separated list of email address to be used as the intended CC recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''/>
            <parameter id='bcc' label='BCC' required='false' tooltip='A comma separated list of email address to be used as the intended BCC recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''/>
            <parameter id='display_name' label='Display Name (From)' required='false' tooltip='The value to be used for the Name of the sender (the email address of the sender can not be manually set).' menu=''>from@yourdomain.com</parameter>
            <parameter id='reply_to' label='Reply To' required='false' tooltip='The address of the account that email replies should be sent to.  The email address of the A custom name can be used if the address is provided in the format: NAME &lt;ADDRESS&gt;' menu=''>from@yourdomain.com</parameter>
            <parameter id='subject' label='Subject' required='false' tooltip='The subject of the email.' menu=''>
              &lt;%= content="" content=@results['Get Base
              Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;APPCONFIG&gt;(.*?)&lt;\/APPCONFIG&gt;/) do @results['App Config'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='htmlbody' label='HTML Body' required='false' tooltip='HTML representing the body of the email (should start with &apos;&lt;html&gt;&apos; and end with &apos;&lt;/html&gt;&apos;).' menu=''>
              &lt;%= content="" content=@results['Get Base
              Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='textbody' label='Alternate Body (Text)' required='false' tooltip='A plaintext message that will be displayed if the recipient can&apos;t display multipart HTML emails.' menu=''>
              &lt;%= content="" content=@results['Get Base
              Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='attachment_file_name' label='Attachment File Name' required='false' tooltip='The name of the file that will be attached to this email message.' menu=''>&lt;%=@results['Attachment']['Name']%&gt;</parameter>
            <parameter id='attachment_file_content' label='Attachment File Content' required='false' tooltip='The content of the file that will be attached to this email message.' menu=''>&lt;%=@results['Attachment']['Contents']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_junction_v1_55</task>
          </dependents>
        </task>
        <task definition_id='smtp_email_send_v1' id='smtp_email_send_v1_38' name='Send Email - Predefined Recipients' x='1389' y='752'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='from' label='From (email address)' menu='' required='true' tooltip='The email address of the simulated sender.'>from@yourdomain.com</parameter>
            <parameter id='to' label='To (email address)' menu='' required='true' tooltip='The email address of the intended recipient.'>
              &lt;%=if @results.has_key?('Collect Emails') @results['Collect
              Emails']['output'] else @results['Get Base Notification']['Recipient']
              end%&gt; &lt;%=if @results.has_key?('Collect Emails')
              @results['Collect Emails']['output'] else @results['Get Base
              Notification']['Recipient'] end%&gt; 
            </parameter>
            <parameter id='subject' label='Subject' menu='' required='false' tooltip='The subject of the email.'>
              &lt;%= content="" content=@results['Get Base
              Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;APPCONFIG&gt;(.*?)&lt;\/APPCONFIG&gt;/) do @results['App Config'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='htmlbody' label='HTML Body' menu='' required='false' tooltip='HTML representing the body of a rich email.'>
              &lt;%= content="" content=@results['Get Base
              Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt; &lt;%= content="" content=@results['Get Base Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt; 
            </parameter>
            <parameter id='textbody' label='Alternate (text) Body' menu='' required='false' tooltip='A plaintext message that will be displayed if the recipient can&apos;t display multipart HTML emails.'>
              &lt;%= content="" content=@results['Get Base
              Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt; &lt;%= content="" content=@results['Get Base Notification']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;/DATASET&gt;/) do @results['Dataset'][$1] end content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;/ATTACHMENT&gt;/) do "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;/ANSWER&gt;/) do @results['Answers'][$1] end content=content.gsub(/&lt;BASE&gt;(.*?)&lt;/BASE&gt;/) do @results['Base'][$1] end content=content.gsub(/&lt;MISC&gt;(.*?)&lt;/MISC&gt;/) do @results['Misc. Inputs'][$1] end content %&gt; 
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_junction_v1_55</task>
          </dependents>
        </task>
        <task name='Recipients to XML' id='utility_csv_to_xml_v1_39' definition_id='utility_csv_to_xml_v1' x='555.6875' y='778.40625'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='csv' label='CSV' required='true' tooltip='' menu=''>&lt;%=@results['Get Base Notification']['Recipient']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_loop_head_v1_40</task>
          </dependents>
        </task>
        <task name='Login IDs to Emails Loop Begin' id='system_loop_head_v1_40' definition_id='system_loop_head_v1' x='656.6875' y='845.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='data_source' required='true' label='Data Source:' tooltip='The source that contains the data to use to create each task in the loop.' menu=''>&lt;%=@results['Email Address List to XML']['XML']%&gt;</parameter>
            <parameter id='loop_path' required='true' label='Loop Path:' tooltip='The XPath statement to indicate what data records to process.' menu=''>//list/item</parameter>
            <parameter id='var_name' required='true' label='Variable Name:' tooltip='The local variable name used to represent the data used in loop tasks.' menu=''>loginIds</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>bmc_itsm7_person_retrieve_v2_42</task>
            <task type='Complete' label='' value=''>system_loop_tail_v1_41</task>
          </dependents>
        </task>
        <task name='Login IDs to Emails End' id='system_loop_tail_v1_41' definition_id='system_loop_tail_v1' x='843.6875' y='874.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='type' required='true' label='Type:' tooltip='How many loop processes must be completed before continuing?' menu='All,Some,Any'>All</parameter>
            <parameter id='number' label='Number:' tooltip='If some, how many?' dependsOnId='type' dependsOnValue='Some' required='false' menu=''/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>utilities_echo_v1_43</task>
          </dependents>
        </task>
        <task name='Lookup Recipient' id='bmc_itsm7_person_retrieve_v2_42' definition_id='bmc_itsm7_person_retrieve_v2' x='739.6875' y='915.984375'>
          <version>2</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='remedy_login_id' label='Remedy Login ID:' required='true' tooltip='The Remedy Login ID associated to the CTM People record to retrieve' menu=''>loginIds</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_loop_tail_v1_41</task>
          </dependents>
        </task>
        <task name='Collect Emails' id='utilities_echo_v1_43' definition_id='utilities_echo_v1' x='1004.6875' y='880.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='input' required='true' label='Input' tooltip='' menu=''>
              &lt;%= @results['Lookup Recipient'].collect{|key,values| if
              (values['Email'] != "") values['Email'] end }.compact.join(', ') %&gt;
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_join_v1_45</task>
          </dependents>
        </task>
        <task name='bmc_itsm7_functional_role_lookup_v1_44' id='bmc_itsm7_functional_role_lookup_v1_44' definition_id='bmc_itsm7_functional_role_lookup_v1' x='759' y='723.265625'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>true</visible>
          <parameters>
            <parameter id='group_id' label='Group ID:' required='true' tooltip='Group ID' menu=''/>
            <parameter id='functional_role' label='Functional Role:' required='true' tooltip='Name of the Functional Role to retrieve' menu=''/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents/>
        </task>
        <task name='Predefined recipients ready' id='system_join_v1_45' definition_id='system_join_v1' x='1080.6875' y='750.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='type' label='Type:' required='true' menu='All,Any,Some' tooltip='How many dependents must be completed before continuing?'>Any</parameter>
            <parameter id='number' label='Number:' required='false' dependsOnId='type' dependsOnValue='Some' tooltip='If some, how many?' menu=''/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='No Attach, Predefined Recip' value='!@results[&apos;Get Base Notification&apos;][&apos;Body&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) &amp;&amp; !@results[&apos;Get Base Notification&apos;][&apos;Subject&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) &amp;&amp; !@results[&apos;Get Base Notification&apos;][&apos;Recipient&apos;].nil?'>smtp_email_send_v1_38</task>
            <task type='Complete' label='Attach, Predefined Recip' value='(@results[&apos;Get Base Notification&apos;][&apos;Body&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) || @results[&apos;Get Base Notification&apos;][&apos;Subject&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;)) &amp;&amp; !@results[&apos;Get Base Notification&apos;][&apos;Recipient&apos;].nil?'>utilities_echo_v1_35</task>
          </dependents>
        </task>
        <task definition_id='utilities_echo_v1' id='utilities_echo_v1_46' name='Get Attachment Name - Email' x='1111' y='90'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='input' label='Input' menu='' required='true' tooltip=''>
               &lt;%=attachmentName="" bodyText="" if @results['Get Notification
              Content - Email']['Body'].includes?("&lt;ATTACHMENT&gt;")
              bodyText=@results['Get Notification Content -
              Email']['Body'].split("&lt;ATTACHMENT&gt;")
              bodyText1=bodyText[1].split("&lt;/ATTACHMENT&gt;")
              attachmentName=bodyText1[0] end subjectText="" if @results['Get
              Notification Content -
              Email']['Subject'].includes?("&lt;ATTACHMENT&gt;")
              subjectText=@results['Get Notification Content -
              Email']['Subject'].split("&lt;ATTACHMENT&gt;")
              subjectText1=subjectText[1].split("&lt;/ATTACHMENT&gt;")
              attachmentName=subjectText1[0] end attachmentName %&gt; 
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>kinetic_request_attachment_retrieve_v2_48</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_attachment_retrieve_v2' id='kinetic_request_attachment_retrieve_v2_48' name='Attachment - Email' x='1287' y='87'>
          <version>2</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='content_type' label='Content Type:' menu='Plain,Base64' required='true' tooltip='The content type either plain text or base 64 encoded.'>Plain</parameter>
            <parameter id='attachment_question_menu_label' label='Attachment Question Menu Label:' menu='' required='false' tooltip='The menu label of an attachment question to retrieve an attachment from.'>&lt;%=@results['Get Attachment Name - Email']['output']%&gt;</parameter>
            <parameter id='customer_survey_instance_id' label='Request Instance ID:' menu='' required='true' tooltip='The instance ID of a request to retrieve an attachment from.'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
            <parameter id='survey_template_instance_id' label='Template Instance ID:' menu='' required='true' tooltip='The instance ID of a template to retrieve an attachment from.'>&lt;%=@results['Get Template ID']['Attribute Value']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>smtp_email_with_attachment_send_v1_50</task>
          </dependents>
        </task>
        <task name='Email Addr Email Sent' id='system_join_v1_49' definition_id='system_join_v1' x='1439.6875' y='254.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='type' label='Type:' required='true' menu='All,Any,Some' tooltip='How many dependents must be completed before continuing?'>Any</parameter>
            <parameter id='number' label='Number:' required='false' dependsOnId='type' dependsOnValue='Some' tooltip='If some, how many?' menu=''/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_loop_tail_v1_7</task>
          </dependents>
        </task>
        <task name='Send Email - Email - Attachment' id='smtp_email_with_attachment_send_v1_50' definition_id='smtp_email_with_attachment_send_v1' x='1454' y='89'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='to' label='To' required='true' tooltip='A comma separated list of email address to be used as the intended recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''>&lt;%=@results['Email Address Loop Start']['Value']%&gt;</parameter>
            <parameter id='cc' label='CC' required='false' tooltip='A comma separated list of email address to be used as the intended CC recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''/>
            <parameter id='bcc' label='BCC' required='false' tooltip='A comma separated list of email address to be used as the intended BCC recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''/>
            <parameter id='display_name' label='Display Name (From)' required='false' tooltip='The value to be used for the Name of the sender (the email address of the sender can not be manually set).' menu=''>from@yourdomain.com</parameter>
            <parameter id='reply_to' label='Reply To' required='false' tooltip='The address of the account that email replies should be sent to.  The email address of the A custom name can be used if the address is provided in the format: NAME &lt;ADDRESS&gt;' menu=''>from@yourdomain.com</parameter>
            <parameter id='subject' label='Subject' required='false' tooltip='The subject of the email.' menu=''>
              &lt;%= content="" content=@results['Get Notification Content -
              Email']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='htmlbody' label='HTML Body' required='false' tooltip='HTML representing the body of the email (should start with &apos;&lt;html&gt;&apos; and end with &apos;&lt;/html&gt;&apos;).' menu=''>
              &lt;%= content="" content=@results['Get Notification Content -
              Email']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='textbody' label='Alternate Body (Text)' required='false' tooltip='A plaintext message that will be displayed if the recipient can&apos;t display multipart HTML emails.' menu=''>
              &lt;%= content="" content=@results['Get Notification Content -
              Email']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='attachment_file_name' label='Attachment File Name' required='false' tooltip='The name of the file that will be attached to this email message.' menu=''>&lt;%=@results['Attachment']['Name']%&gt;</parameter>
            <parameter id='attachment_file_content' label='Attachment File Content' required='false' tooltip='The content of the file that will be attached to this email message.' menu=''>&lt;%=@results['Attachment']['Contents']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_join_v1_49</task>
          </dependents>
        </task>
        <task definition_id='utilities_echo_v1' id='utilities_echo_v1_51' name='Get Attachment Name - Login ID' x='1995' y='-22'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='input' label='Input' menu='' required='true' tooltip=''>
               &lt;%=attachmentName="" bodyText="" if @results['Get Notification
              Content - Login ID']['Body'].includes?("&lt;ATTACHMENT&gt;")
              bodyText=@results['Get Notification Content - Login
              ID']['Body'].split("&lt;ATTACHMENT&gt;")
              bodyText1=bodyText[1].split("&lt;/ATTACHMENT&gt;")
              attachmentName=bodyText1[0] end subjectText="" if @results['Get
              Notification Content - Login
              ID']['Subject'].includes?("&lt;ATTACHMENT&gt;")
              subjectText=@results['Get Notification Content - Login
              ID']['Subject'].split("&lt;ATTACHMENT&gt;")
              subjectText1=subjectText[1].split("&lt;/ATTACHMENT&gt;")
              attachmentName=subjectText1[0] end attachmentName %&gt; 
            </parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>kinetic_request_attachment_retrieve_v2_52</task>
          </dependents>
        </task>
        <task definition_id='kinetic_request_attachment_retrieve_v2' id='kinetic_request_attachment_retrieve_v2_52' name='Attachment - Login ID' x='2144' y='-16'>
          <version>2</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='content_type' label='Content Type:' menu='Plain,Base64' required='true' tooltip='The content type either plain text or base 64 encoded.'>Plain</parameter>
            <parameter id='attachment_question_menu_label' label='Attachment Question Menu Label:' menu='' required='false' tooltip='The menu label of an attachment question to retrieve an attachment from.'>&lt;%=@results['Get Attachment Name - Login ID']['output']%&gt;</parameter>
            <parameter id='customer_survey_instance_id' label='Request Instance ID:' menu='' required='true' tooltip='The instance ID of a request to retrieve an attachment from.'>&lt;%=@inputs['Request Instance ID']%&gt;</parameter>
            <parameter id='survey_template_instance_id' label='Template Instance ID:' menu='' required='true' tooltip='The instance ID of a template to retrieve an attachment from.'>&lt;%=@results['Get Template ID']['Attribute Value']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>smtp_email_with_attachment_send_v1_53</task>
          </dependents>
        </task>
        <task name='Send Email - Login ID - Attachment' id='smtp_email_with_attachment_send_v1_53' definition_id='smtp_email_with_attachment_send_v1' x='2188' y='96'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='to' label='To' required='true' tooltip='A comma separated list of email address to be used as the intended recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''>&lt;%=@results['Email Address Loop Start']['Value']%&gt;</parameter>
            <parameter id='cc' label='CC' required='false' tooltip='A comma separated list of email address to be used as the intended CC recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''/>
            <parameter id='bcc' label='BCC' required='false' tooltip='A comma separated list of email address to be used as the intended BCC recipients.  Custom names can be used if any of the addresses are provided in the format: NAME &lt;ADDRESS&gt;' menu=''/>
            <parameter id='display_name' label='Display Name (From)' required='false' tooltip='The value to be used for the Name of the sender (the email address of the sender can not be manually set).' menu=''>from@yourdomain.com</parameter>
            <parameter id='reply_to' label='Reply To' required='false' tooltip='The address of the account that email replies should be sent to.  The email address of the A custom name can be used if the address is provided in the format: NAME &lt;ADDRESS&gt;' menu=''>from@yourdomain.com</parameter>
            <parameter id='subject' label='Subject' required='false' tooltip='The subject of the email.' menu=''>
              &lt;%= content="" content=@results['Get Notification Content - Login
              ID']['Subject'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt; 
            </parameter>
            <parameter id='htmlbody' label='HTML Body' required='false' tooltip='HTML representing the body of the email (should start with &apos;&lt;html&gt;&apos; and end with &apos;&lt;/html&gt;&apos;).' menu=''>
              &lt;%= content="" content=@results['Get Notification Content - Login
              ID']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='textbody' label='Alternate Body (Text)' required='false' tooltip='A plaintext message that will be displayed if the recipient can&apos;t display multipart HTML emails.' menu=''>
              &lt;%= content="" content=@results['Get Notification Content - Login
              ID']['Body'].gsub(/&lt;DATASET&gt;(.*?)&lt;\/DATASET&gt;/) do
              @results['Dataset'][$1] end
              content=content.gsub(/&lt;ATTACHMENT&gt;(.*?)&lt;\/ATTACHMENT&gt;/) do
              "" end content=content.gsub(/&lt;ANSWER&gt;(.*?)&lt;\/ANSWER&gt;/) do
              @results['Answers'][$1] end
              content=content.gsub(/&lt;BASE&gt;(.*?)&lt;\/BASE&gt;/) do
              @results['Base'][$1] end
              content=content.gsub(/&lt;MISC&gt;(.*?)&lt;\/MISC&gt;/) do
              @results['Misc. Inputs'][$1] end content %&gt;
            </parameter>
            <parameter id='attachment_file_name' label='Attachment File Name' required='false' tooltip='The name of the file that will be attached to this email message.' menu=''>&lt;%=@results['Attachment - Login ID']['Name']%&gt;</parameter>
            <parameter id='attachment_file_content' label='Attachment File Content' required='false' tooltip='The content of the file that will be attached to this email message.' menu=''>&lt;%=@results['Attachment - Login ID']['Contents']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_join_v1_54</task>
          </dependents>
        </task>
        <task name='Email Sent - Login ID' id='system_join_v1_54' definition_id='system_join_v1' x='2218.6875' y='256.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='type' label='Type:' required='true' menu='All,Any,Some' tooltip='How many dependents must be completed before continuing?'>Any</parameter>
            <parameter id='number' label='Number:' required='false' dependsOnId='type' dependsOnValue='Some' tooltip='If some, how many?' menu=''/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_loop_tail_v1_16</task>
          </dependents>
        </task>
        <task name='All Emails Processed' id='system_junction_v1_55' definition_id='system_junction_v1' x='2209.6875' y='668.703125'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters/>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>system_tree_return_v1_3</task>
          </dependents>
        </task>
        <task name='Get Notification Content - Email' id='helper_form_notification_content_lookup_v1_56' definition_id='helper_form_notification_content_lookup_v1' x='1029.6875' y='198.890625'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='messagename' label='Message Name:' required='true' tooltip='The name of the message to be sent.  This is used to lookup the appropriate content in the KS_SRV_Helper form' menu=''>&lt;%=@inputs['Email Template Name']%&gt;</parameter>
            <parameter id='region' label='Region:' required='false' tooltip='The region (if available) of the person that the email is to be sent to' menu=''>Americas</parameter>
            <parameter id='language' label='Language:' required='false' tooltip='The language (if available) that the message should be sent in' menu=''/>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='Attachment' value='@results[&apos;Get Notification Content - Email&apos;][&apos;Body&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) || @results[&apos;Get Notification Content - Email&apos;][&apos;Subject&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;)'>utilities_echo_v1_46</task>
            <task type='Complete' label='No Attach' value='!@results[&apos;Get Notification Content - Email&apos;][&apos;Body&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) &amp;&amp; !@results[&apos;Get Notification Content - Email&apos;][&apos;Subject&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;)'>smtp_email_send_v1_29</task>
          </dependents>
        </task>
        <task name='Get Notification Content - Login ID' id='helper_form_notification_content_lookup_v1_57' definition_id='helper_form_notification_content_lookup_v1' x='1781' y='-7'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='messagename' label='Message Name:' required='true' tooltip='The name of the message to be sent.  This is used to lookup the appropriate content in the KS_SRV_Helper form' menu=''>&lt;%=@inputs['Email Template Name']%&gt;</parameter>
            <parameter id='region' label='Region:' required='false' tooltip='The region (if available) of the person that the email is to be sent to' menu=''>&lt;%=@results['Retrieve Person Details']['Region']%&gt;</parameter>
            <parameter id='language' label='Language:' required='false' tooltip='The language (if available) that the message should be sent in' menu=''>&lt;%=@results['Retrieve Person Language Preference']['Language']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='Attachment' value='@results[&apos;Get Notification Content - Login ID&apos;][&apos;Body&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) || @results[&apos;Get Notification Content - Login ID&apos;][&apos;Subject&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;)'>utilities_echo_v1_51</task>
            <task type='Complete' label='No Attach' value='!@results[&apos;Get Notification Content - Login ID&apos;][&apos;Body&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;) &amp;&amp; !@results[&apos;Get Notification Content - Login ID&apos;][&apos;Subject&apos;].include?(&quot;&lt;ATTACHMENT&gt;&quot;)'>smtp_email_send_v1_30</task>
          </dependents>
        </task>
        <task name='Retrieve Person Language Preference' id='helper_form_language_preference_lookup_v1_58' definition_id='helper_form_language_preference_lookup_v1' x='1774.6875' y='112.890625'>
          <version>1</version>
          <configured>true</configured>
          <defers>false</defers>
          <deferrable>false</deferrable>
          <visible>false</visible>
          <parameters>
            <parameter id='userid' label='Remedy Login ID:' required='true' tooltip='The user login id used to lookup the appropriate language preference in the KS_SRV_Helper form' menu=''>&lt;%=@results['Login ID Loop Start']['Value']%&gt;</parameter>
          </parameters>
          <messages>
            <message type='Create'/>
            <message type='Update'/>
            <message type='Complete'/>
          </messages>
          <dependents>
            <task type='Complete' label='' value=''>helper_form_notification_content_lookup_v1_57</task>
          </dependents>
        </task>
      </request>
    </taskTree>
  DEFINITION
}