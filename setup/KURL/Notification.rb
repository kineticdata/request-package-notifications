require File.join(File.dirname(__FILE__),"config.rb")
require File.join(File.dirname(__FILE__),"bridges.rb")

setup_bridges

service_item "Notification" do
  catalog CATALOG_NAME
  type "Portal"
  description "Notification Console for creating and updating notifications"

  catalog CATALOG_NAME
  display_name DISPLAY_PAGE_NAME
  display_page  DISPLAY_PAGE
  web_server WEB_SERVER
  header_content ""
  web_server WEB_SERVER
  data_set DATA_SET

  visible_to_group VISIBLE_GROUP
  management_group MANAGEMENT_GROUP
  submission_group SUBMISSION_GROUP
  allow_anonymous true
  authentication :default
  task_engine TASK_VERSION
  if TASK_VERSION == "Kinetic Task 4+" 
    run_trees_on :complete
  end


  page "Initial Page",
    :confirmation,
    :vertical_buttons do
    event "Retrieve Parameter",
      :custom_action,
      :load,
      :use_bridging,
      :fire_if => "KD.utils.Util.getParameter(\"helperId\")!=\"\"" do
      custom_code "KD.utils.Action.setQuestionValue('Helper Request ID',KD.utils.Util.getParameter('helperId'));\nKD.utils.Action._fireChange(KD.utils.Util.getQuestionInput('Helper Request ID'));"
    end
    section  "Information and Instruction Section" do
      style "border-top: 1px solid black; border-bottom: 1px solid black; background-color: white;"
    end
    text "Information and Instructions", "<div class=\"show-information\"><a style=\"cursor:pointer\">Click to show additional information and instructions</a></div>\n<div class=\"information\" style=\"display:none\">\n<h3>Notification Information and Instructions</h3>\nThis notification data is used within a task tree to send the correct content message to the correct individual in the correct language.<br>\n\n<h4>Notification Data</h4>\nNotification data is stored in two sections <b>recipient info</b> and <b>content info</b>.<br>\n<br>\n<b>Recipient info</b> is data that concerns who receives a message.  Messages can be sent to predefined users, or the recipient may be determined at run-time.  <u>Predefined users</u> need to have a recipient info entry.  <u>Recipients determined at run-time</u> do not need a recipient info entry.  Instead of a predefined entry at run-time, recipient email addresses or loginIDs are provided when calling the notification process.  Each message is typically designed to either always use predefined recipients, or not use pre-defined recipients at all.<br>\n<br>\nWhen entering recipient information:<br>\n<ol>\n  <li><b>Identify the scope</b> of the recipient entry.  If this message is <i>always</i> sent to the same set of users, choose 'Global'.  If the message will be sent to different people based on a setting such as company, business unit, or geographic region, choose 'Non Global'.\n    <ul>\n        <li>If choosing 'Non Global', then select the proper entity from the drop down menu.  The list of entities is defined elsewhere in the system (Data Management Console).</li>\n    </ul>\n  </li>\n  <li><b>Choose the message content language option</b>. Choose 'Default' if all messages to these recipients should use the default message content.  Use this option for all single language implementations, or in a multi-language implementation where no language specific message is required.\n    <ul><li>If using a specific language setting, choose the language from the presented drop down list. The list of entities is defined elsewhere in the system (Data Management Console). This value chosen should match a message content language entry that is either already entered or will be defined.  At run-time, if no match between recipient language and content language is found, the default message content will be used.</li>\n    </ul>\n  </li>\n  <li><b>Select the type of recipient entry.</b> Choose 'Email Address(es)' if you will be entering a list of emails.  Choose 'Login IDs' if you will be entered a list of users by their login IDs.  Choose 'Catalog Role' if you want to notify someone based on a role, such as 'Requester' or 'SLA Manager'.\n    <ul>\n      <li>If using 'Email Address(es)' or 'Login IDs' enter the values in the Recipient Value box.  Separate the entries with semicolons.</li>\n      <li>If using 'Catalog Role' choose the role from the drop down list. The list of Catalog Roles is defined elsewhere in the system (Data Management Console).</li>\n    </ul>\n  </li>\n</ol>\n<br>\n<b>Content info</b> is the actual content of the message being sent to the recipient.  Messages can be stored in any language, as well as storing different versions for different entity groups, such as different companies, business units, or geographies.<br>\n\n\nWhen entering content information:<br>\n<ol>\n  <li><b>Identify the scope</b> of the notification entry.  If this message content will be sent to all users, choose 'Global'.  If the content is specific to a business entity such as company, business unit, or geographic region, choose 'Non Global'.\n    <ul>\n        <li>If choosing 'Non Global', then select the proper entity from the drop down menu.  The list of entities is defined elsewhere in the system (Data Management Console).</li>\n    </ul>\n  </li>\n  <li><b>Choose the language option</b>. Choose 'All languages (default)' for all single language implementations, or in a multi-language implementation where no language specific message content is required.  Choose 'Specific language' if this content entry is in a specific language.  (Note:  Every notification message should have one Default language entry.)\n    <ul><li>If using a specific language setting, choose the language from the presented drop down list. The list of entities is defined elsewhere in the system (Data Management Console).  At run-time, the notification engine will attempt to find a match between the predefined recipient language (or, if using a Login ID, the user's preferred Language) and the notification content message language.  If no match between recipient language and content language is found, the default language message content entry will be used.</li>\n    </ul>\n  </li>\n  <li><b>Enter the Subject Line.</b> Free text entry.  A replacement strategy allows for dynamic content to be inserted at run-time -- see notes in the Message Body item for details..</li>\n  <li><b>Enter the Message Body using HTML</b> Free text entry.  A replacement strategy allows for dynamic content to be inserted at run-time.\n    <ul>\n      <li>To insert replacement based on an input passed to the notification engine, wrap the content with \"INPUT\" tags, like this:  &lt;INPUT&gt;inputfieldname&lt;/INPUT&gt;</li>\n      <li>To insert replacement based on an a previously execute noted, wrap the content with \"RESULTS\" tags, like this:  &lt;RESULTS&gt;nodename;outputfieldname&lt;/RESULTS&gt;</li>\n      <li>Other replacements here...</li>\n    </ul>\n  </li>\n</ol>\n\n<h4>Using Notifications</h4>\nThe \"notification engine\" is simply a task sub-process that can be used with an service item (or other sub-process).  The notification sub process requires inputs for notification message name, and allows optional inputs for entity and language as well as recipient override information.<br>\n<br>\n<a style=\"cursor:pointer\">Hide information</a>\n</div>" do
      event "Toggle information",
        :custom_action,
        :click,
        :use_bridging do
        custom_code "$('.show-information').toggle();\n$('.information').toggle();"
      end
    end
    section  "Notification Selection"
    question "_Notification Name", "Notification Name", :dynamic_list,
      :transient,
      :style_class => " left " do
      bridged_dynamic_list "Data Management Console - Helper Data",
        :qualification => "Index 1",
        :label_attribute => "Index Field 2",
        :value_attribute => "Index Field 2" do
        parameter "Index Field 1", "\"Notification Content\""
      end
      event "Load tables",
        :custom_action,
        :change,
        :use_bridging do
        custom_code "loadData();"
      end
    end
    text "Buttons", "<input type=\"button\" class=\"templateButton\" value=\"Add new notification message\"/>",
      :style_class => " right " do
      style "margin-top: 10px;"
      event "Add New",
        :insert_remove,
        :click do
        target "Content Section",
          :section,
          :insert
        target "Recipient Section",
          :section,
          :insert
        target "_LanguageSelection",
          :question,
          :remove
        target "_RecipientValueRole",
          :question,
          :remove
        target "Recipient Value",
          :question,
          :remove
        target "Recipient Type",
          :question,
          :remove
        target "_NotificationScopeSelection",
          :question,
          :remove
        target "_RecipientScope",
          :question,
          :remove
        target "_RecipientScopeSelection",
          :question,
          :remove
        target "_RecipientLanguageSelection",
          :question,
          :remove
        target "_RecipientLanguage",
          :question,
          :remove
        target "Save Button Section",
          :section,
          :insert
      end
      event "Add New",
        :read_readwrite,
        :click do
        target "Predefined Recipient",
          :question,
          :readwrite
        target "Content Status",
          :question,
          :readonly
        target "Recipient Status",
          :question,
          :readonly
      end
      event "Add New",
        :insert_remove,
        :click,
        :also_require,
        :description => "Set this section required" do
        target "Notification Name Section",
          :section,
          :insert
      end
      event "Reset Content and Recipient fields",
        :set_fields_internal,
        :click do
        field_map "Predefined Recipient", "Determined when used"
        field_map "Notification Scope", "Global"
        field_map "_LanguageScope", "Default"
        field_map "Recipient Request ID", "$\\NULL$"
        field_map "Recipient Status", "Active"
        field_map "Content Request ID", "$\\NULL$"
        field_map "Content Status", "Active"
        field_map "Modification Type", "New Notification"
        field_map "Scope", "Global"
        field_map "Language", "Default"
      end
    end
    text "Spacer", "",
      :style_class => " clear-both "
    section  "Recipient Table Section",
      :style_class => " border rounded "
    text "Recipient Table Section Header", "Predefined Recipients",
      :style_class => " sectionHeader "
    text "Recipient Table", "<div id=\"notification-recipient-table\"></div>"
    text "Add Recipient Button", "<input type=\"button\" class=\"templateButton\" value=\"Add new message recipient\"/>",
      :removed do
      event "Add recipient",
        :insert_remove,
        :click do
        target "Recipient Section",
          :section,
          :insert
        target "Notification Name Section",
          :section,
          :remove
        target "Content Section",
          :section,
          :remove
        target "Recipient Value",
          :question,
          :remove
        target "_RecipientValueRole",
          :question,
          :remove
        target "Recipient Type",
          :question,
          :insert
        target "_RecipientScopeSelection",
          :question,
          :remove
        target "_RecipientScope",
          :question,
          :insert
        target "_RecipientLanguage",
          :question,
          :insert
        target "_RecipientLanguageSelection",
          :question,
          :remove
        target "Save Button Section",
          :section,
          :insert
      end
      event "Lock predefined",
        :read_readwrite,
        :click do
        target "Predefined Recipient",
          :question,
          :readonly
        target "Recipient Status",
          :question,
          :readonly
      end
      event "Set predefined",
        :set_fields_internal,
        :click do
        field_map "Predefined Recipient", "Predefined recipient"
        field_map "Recipient Type", "$\\NULL$"
        field_map "Recipient Status", "Active"
        field_map "Recipient Request ID", "$\\NULL$"
        field_map "_RecipientScope", "Global"
        field_map "_RecipientLanguage", "Default"
        field_map "Modification Type", "New Recipient"
        field_map "Recipient Language", "Default"
        field_map "Recipient Scope", "Global"
      end
    end
    section  "Content Table Section",
      :style_class => " border rounded clear-both " do
      style "margin-top:30px !important;"
    end
    text "Content Table Section Header", "Content Table",
      :style_class => " sectionHeader "
    text "Content Table", "<div id=\"notification-content-table\"></div>"
    text "Add Content Button", "<input type=\"button\" class=\"templateButton\" value=\"Add new message content\"/>",
      :removed do
      event "Add new content",
        :insert_remove,
        :click do
        target "Content Section",
          :section,
          :insert
        target "Notification Name Section",
          :section,
          :remove
        target "_NotificationScopeSelection",
          :question,
          :remove
        target "Recipient Section",
          :section,
          :remove
        target "Save Button Section",
          :section,
          :insert
      end
      event "Unlock predefined recipient",
        :read_readwrite,
        :click,
        :description => "If add recipient was clicked first, this value is locked.  Unlock it here so if the user clicked this button second, it'll be changeable." do
        target "Predefined Recipient",
          :question,
          :readwrite
        target "Content Status",
          :question,
          :readonly
      end
      event "Reset Content Info",
        :set_fields_internal,
        :click do
        field_map "Content Request ID", "$\\NULL$"
        field_map "Content Status", "Active"
        field_map "Notification Scope", "Global"
        field_map "_LanguageScope", "Default"
        field_map "Modification Type", "New Content"
        field_map "Scope", "Global"
        field_map "Language", "Default"
      end
    end
    section  "Notification Name Section",
      :removed,
      :style_class => " border rounded "
    text "Notification Name Section Header", "New Notification Name",
      :style_class => " sectionHeader "
    question "Notification Name", "Notification Name", :free_text,
      :size => "40",
      :rows => "1",
      :field_map_number => "1"
    section  "Recipient Section",
      :removed,
      :style_class => " border rounded "
    text "Recipient Section Header", "Notification Message Recipient",
      :style_class => " sectionHeader "
    question "Predefined Recipient", "Does this notification go to a predefined person, or will recipient info be determined when the message is used?", :list,
      :radio_button,
      :horizontal,
      :blank,
      :required,
      :choice_list => "Predefined Recipient",
      :field_map_number => "6" do
      choice "Predefined recipient"
      choice "Determined when used"
      event "Predefined",
        :insert_remove,
        :change,
        :also_require,
        :fire_if => "obj.value== \"Predefined recipient\" " do
        target "Recipient Type",
          :question,
          :insert
        target "_RecipientScope",
          :question,
          :insert
        target "_RecipientLanguage",
          :question,
          :insert
      end
      event "Not Predefined",
        :insert_remove,
        :change,
        :also_make_optional,
        :fire_if => "obj.value!= \"Predefined recipient\" " do
        target "_RecipientValueRole",
          :question,
          :remove
        target "Recipient Value",
          :question,
          :remove
        target "Recipient Type",
          :question,
          :remove
        target "_RecipientScope",
          :question,
          :remove
        target "_RecipientScopeSelection",
          :question,
          :remove
        target "_RecipientLanguageSelection",
          :question,
          :remove
        target "_RecipientLanguage",
          :question,
          :remove
      end
      event "Predefined",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Predefined recipient\" " do
        field_map "_RecipientScope", "Global"
        field_map "_RecipientLanguage", "Default"
        field_map "Recipient Scope", "Global"
        field_map "Recipient Language", "Default"
      end
    end
    question "_RecipientScope", "Is this predefined recipient entry global, or does it only apply to a specific organization?", :list,
      :radio_button,
      :horizontal,
      :required,
      :removed,
      :choice_list => "Global / Non Global",
      :field_map_number => "18" do
      choice "Global"
      choice "Non Global"
      event "Global",
        :insert_remove,
        :change,
        :also_make_optional,
        :fire_if => "obj.value== \"Global\" " do
        target "_RecipientScopeSelection",
          :question,
          :remove
      end
      event "Non Global",
        :insert_remove,
        :change,
        :also_require,
        :fire_if => "obj.value!= \"Global\" " do
        target "_RecipientScopeSelection",
          :question,
          :insert
      end
      event "Global",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Global\" " do
        field_map "Recipient Scope", "Global"
      end
      event "Non Global",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value!= \"Global\" " do
        field_map "Recipient Scope", "$\\NULL$"
      end
    end
    question "_RecipientScopeSelection", "Recipient Scope", :dynamic_list,
      :removed,
      :field_map_number => "19" do
      bridged_dynamic_list "Data Management Console - Helper Data",
        :qualification => "Index 1",
        :label_attribute => "Character Field 1",
        :value_attribute => "Character Field 1" do
        parameter "Index Field 1", "\"Notification Scope Entity\""
      end
      event "Set Recipient Scope",
        :set_fields_internal,
        :change do
        field_map "Recipient Scope", "<FLD>_RecipientScopeSelection</FLD> "
      end
    end
    question "Recipient Scope", "Recipient Scope", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "20"
    question "_RecipientLanguage", "In what language should the message be sent?", :list,
      :radio_button,
      :horizontal,
      :removed,
      :choice_list => "Recipient Language Option",
      :field_map_number => "21" do
      choice "Default"
      choice "Specific language"
      event "Default",
        :insert_remove,
        :change,
        :also_make_optional,
        :fire_if => "obj.value== \"Default\" " do
        target "_RecipientLanguageSelection",
          :question,
          :remove
      end
      event "Not Default",
        :insert_remove,
        :change,
        :also_require,
        :fire_if => "obj.value!= \"Default\" " do
        target "_RecipientLanguageSelection",
          :question,
          :insert
      end
      event "Default",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Default\" " do
        field_map "Recipient Language", "Default"
      end
      event "Not Default",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value!= \"Default\" " do
        field_map "Recipient Language", "$\\NULL$"
      end
    end
    question "_RecipientLanguageSelection", "Language Selection", :dynamic_list,
      :removed,
      :field_map_number => "22" do
      bridged_dynamic_list "Data Management Console - Helper Data",
        :qualification => "Index 1 | Index 2 (exact match/null)",
        :label_attribute => "Character Field 1",
        :value_attribute => "Character Field 2" do
        parameter "Index Field 1", "\"Catalog Configuration Data\""
        parameter "Index Field 2", "\"Form Language Options\""
      end
      event "Set Recipient Language",
        :set_fields_internal,
        :change do
        field_map "Recipient Language", "<FLD>_RecipientLanguageSelection</FLD> "
      end
    end
    question "Recipient Language", "Recipient Language", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "23"
    question "Recipient Type", "Recipient Type", :list,
      :radio_button,
      :horizontal,
      :removed,
      :choice_list => "Recipient Type",
      :field_map_number => "8" do
      choice "SMTP", "Email Address(es)"
      choice "Login ID", "Login ID(s)"
      choice "Catalog Role"
      event "Catalog Role",
        :insert_remove,
        :change,
        :also_require,
        :also_make_optional,
        :fire_if => "obj.value== \"Catalog Role\" " do
        target "_RecipientValueRole",
          :question,
          :insert
        target "Recipient Value",
          :question,
          :remove
      end
      event "Clear Recipient Value",
        :set_fields_internal,
        :change do
        field_map "Recipient Value", "$\\NULL$"
      end
      event "Not Catalog Role",
        :insert_remove,
        :change,
        :also_require,
        :also_make_optional,
        :fire_if => "obj.value!= \"Catalog Role\" " do
        target "_RecipientValueRole",
          :question,
          :remove
        target "Recipient Value",
          :question,
          :insert
      end
    end
    question "_RecipientValueRole", "Recipient Value", :dynamic_list,
      :removed,
      :transient do
      bridged_dynamic_list "Data Management Console - Helper Data",
        :qualification => "Index 1 | Index 2 (exact match/null)",
        :label_attribute => "Character Field 1",
        :value_attribute => "Character Field 1" do
        parameter "Index Field 1", "\"Catalog Functions\""
        parameter "Index Field 2", "\"Role\""
      end
      event "Set Recipient Value",
        :set_fields_internal,
        :change do
        field_map "Recipient Value", "<FLD>_RecipientValueRole</FLD> "
      end
    end
    question "Recipient Value", "Recipient Value(s) (separate values by a semicolon)", :free_text,
      :removed,
      :size => "40",
      :rows => "1",
      :field_map_number => "9"
    question "Recipient Status", "Recipient Status", :list,
      :radio_button,
      :horizontal,
      :read_only,
      :choice_list => "Status Values",
      :field_map_number => "16" do
      choice "Active"
      choice "Inactive"
    end
    question "Recipient Request ID", "Recipient Request ID", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "17"
    section  "Content Section",
      :removed,
      :style_class => " border rounded "
    text "Content Section Header", "Notification Message Content",
      :style_class => " sectionHeader "
    question "Notification Scope", "Is this content global, or does it only apply to a specific organization?", :list,
      :radio_button,
      :horizontal,
      :blank,
      :required,
      :default_answer => "Global",
      :choice_list => "Global / Non Global",
      :field_map_number => "7" do
      event "Global",
        :insert_remove,
        :change,
        :also_make_optional,
        :fire_if => "obj.value== \"Global\" " do
        target "_NotificationScopeSelection",
          :question,
          :remove
      end
      event "Non Global",
        :insert_remove,
        :change,
        :also_require,
        :fire_if => "obj.value== \"Non Global\" " do
        target "_NotificationScopeSelection",
          :question,
          :insert
      end
      event "Global",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Global\" " do
        field_map "Scope", "Global"
      end
      event "Non Global",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Non Global\" " do
        field_map "Scope", "$\\NULL$"
      end
    end
    question "_NotificationScopeSelection", "Scope", :dynamic_list,
      :removed,
      :field_map_number => "2" do
      bridged_dynamic_list "Data Management Console - Helper Data",
        :qualification => "Index 1",
        :label_attribute => "Character Field 1",
        :value_attribute => "Character Field 1" do
        parameter "Index Field 1", "\"Notification Scope Entity\""
      end
      event "Populate scope",
        :set_fields_internal,
        :change do
        field_map "Scope", "<FLD>_NotificationScopeSelection</FLD> "
      end
    end
    question "Scope", "Scope", :free_text,
      :required,
      :removed,
      :size => "40",
      :rows => "1",
      :field_map_number => "3"
    question "_LanguageScope", "For all languages (or the default), or a specified language?", :list,
      :radio_button,
      :horizontal,
      :required,
      :default_answer => "Default",
      :choice_list => "Default or specific",
      :field_map_number => "13" do
      choice "Default", "All languages (default)"
      choice "Specific language"
      event "Default",
        :insert_remove,
        :change,
        :also_make_optional,
        :fire_if => "obj.value== \"Default\" " do
        target "_LanguageSelection",
          :question,
          :remove
      end
      event "Specific Language",
        :insert_remove,
        :change,
        :also_require,
        :fire_if => "obj.value== \"Specific language\" " do
        target "_LanguageSelection",
          :question,
          :insert
      end
      event "Default",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Default\" " do
        field_map "Language", "Default"
      end
      event "Specific Language",
        :set_fields_internal,
        :change,
        :fire_if => "obj.value== \"Specific language\" " do
        field_map "Language", "$\\NULL$"
      end
    end
    question "_LanguageSelection", "Language", :dynamic_list,
      :removed,
      :transient,
      :default_answer => "en" do
      bridged_dynamic_list "Data Management Console - Helper Data",
        :qualification => "Index 1 | Index 2 (exact match/null)",
        :label_attribute => "Character Field 1",
        :value_attribute => "Character Field 2" do
        parameter "Index Field 1", "\"Catalog Configuration Data\""
        parameter "Index Field 2", "\"Form Language Options\""
      end
      event "Set Language",
        :set_fields_internal,
        :change do
        field_map "Language", "<FLD>_LanguageSelection</FLD> "
      end
    end
    question "Language", "Language", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "4"
    question "Subject Line", "Subject Line", :free_text,
      :required,
      :size => "60",
      :rows => "1",
      :field_map_number => "10"
    question "Message Body", "Message Body", :free_text,
      :required,
      :size => "60",
      :rows => "15",
      :field_map_number => "5"
    question "Content Status", "Content Status", :list,
      :radio_button,
      :horizontal,
      :read_only,
      :choice_list => "Status Values",
      :field_map_number => "15"
    question "Content Request ID", "Content Request ID", :free_text,
      :removed,
      :size => "20",
      :rows => "1",
      :field_map_number => "14"
    section  "Save Button Section",
      :removed
    text "Save Button", "<input type=\"button\" class=\"templateButton\" value=\"Save\" />" do
      event "On Save click",
        :custom_action,
        :click,
        :use_bridging do
        custom_code "save();"
      end
    end
    section  "Processing (Removed)",
      :removed
    question "Modification Type", "Modification Type", :free_text,
      :size => "20",
      :rows => "1",
      :field_map_number => "24" do
      event "Repopulate Notification Name Menu",
        :populate_menu,
        :change,
        :use_bridging,
        :fire_if => "obj.value== \"New Notification\"" do
        bridged_resource "Data Management Console - Helper Data",
          :qualification => "Index 1",
          :label_attribute => "Index Field 2",
          :value_attribute => "Index Field 2" do
          parameter "Index Field 1", "\"Notification Content\""
        end
        target "_Notification Name"
      end
      event "Clear field",
        :set_fields_internal,
        :change do
        field_map "Modification Type", "$\\NULL$"
      end
    end
    question "Helper Request ID", "Helper Request ID", :free_text,
      :transient,
      :size => "20",
      :rows => "1" do
      event "Determine Source",
        :set_fields_external,
        :change,
        :null_on_no_match,
        :use_bridging do
        bridged_resource "Data Management Console - Helper Data",
          :qualification => "By Record Id" do
          parameter "Record Id", "<FLD>Helper Request ID;ANSWER</FLD>"
        end
        field_map "Source", "<%=attribute[\"Integer Field 1\"]%> ",
          :fire_change_event,
          :visible_in_table => "Yes"
      end
    end
    question "Source", "Source", :free_text,
      :size => "20",
      :rows => "1",
      :field_map_number => "12"
    question "Data Model", "Data Model", :free_text,
      :size => "20",
      :rows => "1",
      :field_map_number => "11"
    text "Bridges", "" do
      event "Notification Content | By Name",
        :custom_action,
        :click,
        :use_bridging do
        custom_code nil
        bridged_resource "Notification Content",
          :qualification => "By Name"
      end
      event "Notification Recipient | By Name",
        :custom_action,
        :click,
        :use_bridging do
        custom_code nil
        bridged_resource "Notification Recipient",
          :qualification => "By Name"
      end
    end
  end

  if(TASK_VERSION == "Kinetic Task 2/3")
  	puts "Task 2/3 Used"
	  task_tree "Notification Entry",
	    :type => "Complete",
	    :xml => "<taskTree schema_version=\"1.0\" version=\"\" builder_version=\"3.1.0\"><name>Notification Entry</name><author/><notes/><lastID>13</lastID><request><task name=\"Start\" id=\"start\" definition_id=\"system_start_v1\" x=\"10\" y=\"10\"><version>1</version><configured>true</configured><defers>false</defers><deferrable>false</deferrable><visible>false</visible><parameters/><messages/><dependents><task type=\"Complete\" label=\"\" value=\"\">kinetic_helper_record_find_v3_4</task><task type=\"Complete\" label=\"Predefined recipient\" value=\"&lt;%=@answers['Predefined Recipient']==&quot;Predefined recipient&quot;%&gt;\">kinetic_helper_record_find_v3_5</task></dependents></task>\n        <task name=\"Create content record\" id=\"kinetic_helper_record_create_v2_1\" definition_id=\"kinetic_helper_record_create_v2\" x=\"215.234375\" y=\"220\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n\t\t<parameter id=\"SurveyInstanceID\" label=\"SurveyInstanceID\" required=\"false\" tooltip=\"SurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"CustomerSurveyInstanceID\" label=\"CustomerSurveyInstanceID\" required=\"false\" tooltip=\"CustomerSurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"Index Field1\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field1\" menu=\"\">Notification Content</parameter>\n        <parameter id=\"Index Field2\" label=\"Index Field2\" required=\"false\" tooltip=\"Index Field2\" menu=\"\">&lt;%=@answers['Notification Name']%&gt;</parameter>\n        <parameter id=\"Index Field3\" label=\"Index Field3\" required=\"false\" tooltip=\"Index Field3\" menu=\"\">&lt;%=@answers['Organization']%&gt;</parameter>\n        <parameter id=\"Character Field1\" label=\"Character Field1\" required=\"false\" tooltip=\"Character Field1\" menu=\"\">&lt;%=@answers['Language']%&gt;</parameter>\n\t\t<parameter id=\"Character Field2\" label=\"Character Field2\" required=\"false\" tooltip=\"Character Field2\" menu=\"\"/>\n\t\t<parameter id=\"Character Field3\" label=\"Character Field3\" required=\"false\" tooltip=\"Character Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field4\" label=\"Character Field4\" required=\"false\" tooltip=\"Character Field4\" menu=\"\"/>\n\t\t<parameter id=\"Character Field5\" label=\"Character Field5\" required=\"false\" tooltip=\"Character Field5\" menu=\"\"/>\n\t\t<parameter id=\"Character Field6\" label=\"Character Field6\" required=\"false\" tooltip=\"Character Field6\" menu=\"\"/>\n\t\t<parameter id=\"Character Field7\" label=\"Character Field7\" required=\"false\" tooltip=\"Character Field7\" menu=\"\"/>\n\t\t<parameter id=\"Character Field8\" label=\"Character Field8\" required=\"false\" tooltip=\"Character Field8\" menu=\"\"/>\n\t\t<parameter id=\"Character Field9\" label=\"Character Field9\" required=\"false\" tooltip=\"Character Field9\" menu=\"\"/>\n\t\t<parameter id=\"Character Field10\" label=\"Character Field10\" required=\"false\" tooltip=\"Character Field10\" menu=\"\"/>\n\t\t<parameter id=\"Character Field11\" label=\"Character Field11\" required=\"false\" tooltip=\"Character Field11\" menu=\"\"/>\n\t\t<parameter id=\"Character Field12\" label=\"Character Field12\" required=\"false\" tooltip=\"Character Field12\" menu=\"\"/>\n\t\t<parameter id=\"Character Field13\" label=\"Character Field13\" required=\"false\" tooltip=\"Character Field13\" menu=\"\">&lt;%=@answers['Subject Line']%&gt;</parameter>\n\t\t<parameter id=\"Character Field14\" label=\"Character Field14\" required=\"false\" tooltip=\"Character Field14\" menu=\"\">&lt;%=@answers['Message Body']%&gt;</parameter>\n\t\t<parameter id=\"Integer Field1\" label=\"Integer Field1\" required=\"false\" tooltip=\"Integer Field1\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field2\" label=\"Integer Field2\" required=\"false\" tooltip=\"Integer Field2\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field3\" label=\"Integer Field3\" required=\"false\" tooltip=\"Integer Field3\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field4\" label=\"Integer Field4\" required=\"false\" tooltip=\"Integer Field4\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field5\" label=\"Integer Field5\" required=\"false\" tooltip=\"Integer Field5\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field6\" label=\"Integer Field6\" required=\"false\" tooltip=\"Integer Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field1\" label=\"Date Field1\" required=\"false\" tooltip=\"Date Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date Field2\" label=\"Date Field2\" required=\"false\" tooltip=\"Date Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date Field3\" label=\"Date Field3\" required=\"false\" tooltip=\"Date Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date Field4\" label=\"Date Field4\" required=\"false\" tooltip=\"Date Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date Field5\" label=\"Date Field5\" required=\"false\" tooltip=\"Date Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date Field6\" label=\"Date Field6\" required=\"false\" tooltip=\"Date Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field7\" label=\"Date Field7\" required=\"false\" tooltip=\"Date Field7\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field1\" label=\"Date/Time Field1\" required=\"false\" tooltip=\"Date/Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field2\" label=\"Date/Time Field2\" required=\"false\" tooltip=\"Date/Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field3\" label=\"Date/Time Field3\" required=\"false\" tooltip=\"Date/Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field4\" label=\"Date/Time Field4\" required=\"false\" tooltip=\"Date/Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field5\" label=\"Date/Time Field5\" required=\"false\" tooltip=\"Date/Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field6\" label=\"Date/Time Field6\" required=\"false\" tooltip=\"Date/Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field7\" label=\"Date/Time Field7\" required=\"false\" tooltip=\"Date/Time Field7\" menu=\"\"/>\n\t\t<parameter id=\"Time Field1\" label=\"Time Field1\" required=\"false\" tooltip=\"Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Time Field2\" label=\"Time Field2\" required=\"false\" tooltip=\"Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Time Field3\" label=\"Time Field3\" required=\"false\" tooltip=\"Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Time Field4\" label=\"Time Field4\" required=\"false\" tooltip=\"Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Time Field5\" label=\"Time Field5\" required=\"false\" tooltip=\"Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Time Field6\" label=\"Time Field6\" required=\"false\" tooltip=\"Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Time Field7\" label=\"Time Field7\" required=\"false\" tooltip=\"Time Field7\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_join_v1_10</task></dependents>\n    </task>\n      \n        <task name=\"Update existing content record\" id=\"kinetic_helper_record_update_v2_2\" definition_id=\"kinetic_helper_record_update_v2\" x=\"23.109375\" y=\"232.53125\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n\t\t<parameter id=\"Request ID\" label=\"Request ID\" required=\"true\" tooltip=\"Enter the Request ID, stored in Request ID of the KS_SRV_Helper form\" menu=\"\">&lt;%=@results['Look for existing notification content records']['Entry Id']%&gt;</parameter>\t\n\t\t<parameter id=\"Status\" label=\"Status\" required=\"true\" menu=\"Active,Inactive,Delete\" tooltip=\"Enter the Request ID, stored in Request ID of the KS_SRV_Helper form\">Active</parameter>\n\t\t<parameter id=\"SurveyInstanceID\" label=\"SurveyInstanceID\" required=\"false\" tooltip=\"SurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"CustomerSurveyInstanceID\" label=\"CustomerSurveyInstanceID\" required=\"false\" tooltip=\"CustomerSurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"Index Field1\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field1\" menu=\"\"/>\n\t\t<parameter id=\"Index Field2\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field2\" menu=\"\"/>\n\t\t<parameter id=\"Index Field3\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field1\" label=\"Character Field1\" required=\"false\" tooltip=\"Character Field1\" menu=\"\"/>\n\t\t<parameter id=\"Character Field2\" label=\"Character Field2\" required=\"false\" tooltip=\"Character Field2\" menu=\"\"/>\n\t\t<parameter id=\"Character Field3\" label=\"Character Field3\" required=\"false\" tooltip=\"Character Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field4\" label=\"Character Field4\" required=\"false\" tooltip=\"Character Field4\" menu=\"\"/>\n\t\t<parameter id=\"Character Field5\" label=\"Character Field5\" required=\"false\" tooltip=\"Character Field5\" menu=\"\"/>\n\t\t<parameter id=\"Character Field6\" label=\"Character Field6\" required=\"false\" tooltip=\"Character Field6\" menu=\"\"/>\n\t\t<parameter id=\"Character Field7\" label=\"Character Field7\" required=\"false\" tooltip=\"Character Field7\" menu=\"\"/>\n\t\t<parameter id=\"Character Field8\" label=\"Character Field8\" required=\"false\" tooltip=\"Character Field8\" menu=\"\"/>\n\t\t<parameter id=\"Character Field9\" label=\"Character Field9\" required=\"false\" tooltip=\"Character Field9\" menu=\"\"/>\n\t\t<parameter id=\"Character Field10\" label=\"Character Field10\" required=\"false\" tooltip=\"Character Field10\" menu=\"\"/>\n\t\t<parameter id=\"Character Field11\" label=\"Character Field11\" required=\"false\" tooltip=\"Character Field11\" menu=\"\"/>\n\t\t<parameter id=\"Character Field12\" label=\"Character Field12\" required=\"false\" tooltip=\"Character Field12\" menu=\"\"/>\n\t\t<parameter id=\"Character Field13\" label=\"Character Field13\" required=\"false\" tooltip=\"Character Field13\" menu=\"\">&lt;%=@answers['Subject Line']%&gt;</parameter>\n\t\t<parameter id=\"Character Field14\" label=\"Character Field14\" required=\"false\" tooltip=\"Character Field14\" menu=\"\">&lt;%=@answers['Message Body']%&gt;</parameter>\n\t\t<parameter id=\"Integer Field1\" label=\"Integer Field1\" required=\"false\" tooltip=\"Integer Field1\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field2\" label=\"Integer Field2\" required=\"false\" tooltip=\"Integer Field2\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field3\" label=\"Integer Field3\" required=\"false\" tooltip=\"Integer Field3\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field4\" label=\"Integer Field4\" required=\"false\" tooltip=\"Integer Field4\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field5\" label=\"Integer Field5\" required=\"false\" tooltip=\"Integer Field5\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field6\" label=\"Integer Field6\" required=\"false\" tooltip=\"Integer Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field1\" label=\"Date Field1\" required=\"false\" tooltip=\"Date Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date Field2\" label=\"Date Field2\" required=\"false\" tooltip=\"Date Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date Field3\" label=\"Date Field3\" required=\"false\" tooltip=\"Date Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date Field4\" label=\"Date Field4\" required=\"false\" tooltip=\"Date Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date Field5\" label=\"Date Field5\" required=\"false\" tooltip=\"Date Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date Field6\" label=\"Date Field6\" required=\"false\" tooltip=\"Date Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field7\" label=\"Date Field7\" required=\"false\" tooltip=\"Date Field7\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field1\" label=\"Date/Time Field1\" required=\"false\" tooltip=\"Date/Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field2\" label=\"Date/Time Field2\" required=\"false\" tooltip=\"Date/Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field3\" label=\"Date/Time Field3\" required=\"false\" tooltip=\"Date/Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field4\" label=\"Date/Time Field4\" required=\"false\" tooltip=\"Date/Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field5\" label=\"Date/Time Field5\" required=\"false\" tooltip=\"Date/Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field6\" label=\"Date/Time Field6\" required=\"false\" tooltip=\"Date/Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field7\" label=\"Date/Time Field7\" required=\"false\" tooltip=\"Date/Time Field7\" menu=\"\"/>\n\t\t<parameter id=\"Time Field1\" label=\"Time Field1\" required=\"false\" tooltip=\"Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Time Field2\" label=\"Time Field2\" required=\"false\" tooltip=\"Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Time Field3\" label=\"Time Field3\" required=\"false\" tooltip=\"Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Time Field4\" label=\"Time Field4\" required=\"false\" tooltip=\"Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Time Field5\" label=\"Time Field5\" required=\"false\" tooltip=\"Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Time Field6\" label=\"Time Field6\" required=\"false\" tooltip=\"Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Time Field7\" label=\"Time Field7\" required=\"false\" tooltip=\"Time Field7\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_join_v1_10</task></dependents>\n    </task>\n      \n        \n      \n        <task name=\"Look for existing notification content record\" id=\"kinetic_helper_record_find_v3_4\" definition_id=\"kinetic_helper_record_find_v3\" x=\"111.9375\" y=\"96.828125\">\n      <version>3</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n\t\t<parameter id=\"SurveyInstanceID\" label=\"SurveyInstanceID\" required=\"false\" tooltip=\"SurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"CustomerSurveyInstanceID\" label=\"CustomerSurveyInstanceID\" required=\"false\" tooltip=\"CustomerSurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"Index Field1\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field1\" menu=\"\">Notification Content</parameter>\n        <parameter id=\"Index Field2\" label=\"Index Field2\" required=\"false\" tooltip=\"Index Field2\" menu=\"\">&lt;%=@answers['Notification Name']%&gt;</parameter>\n        <parameter id=\"Index Field3\" label=\"Index Field3\" required=\"false\" tooltip=\"Index Field3\" menu=\"\">&lt;%=@answers['Organization']%&gt;</parameter>\n        <parameter id=\"Character Field1\" label=\"Character Field1\" required=\"false\" tooltip=\"Character Field1\" menu=\"\">&lt;%=@answers['Language']%&gt;</parameter>\n\t\t<parameter id=\"Character Field2\" label=\"Character Field2\" required=\"false\" tooltip=\"Character Field2\" menu=\"\"/>\n\t\t<parameter id=\"Character Field3\" label=\"Character Field3\" required=\"false\" tooltip=\"Character Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field4\" label=\"Character Field4\" required=\"false\" tooltip=\"Character Field4\" menu=\"\"/>\n\t\t<parameter id=\"Character Field5\" label=\"Character Field5\" required=\"false\" tooltip=\"Character Field5\" menu=\"\"/>\n\t\t<parameter id=\"Character Field6\" label=\"Character Field6\" required=\"false\" tooltip=\"Character Field6\" menu=\"\"/>\n\t\t<parameter id=\"Character Field7\" label=\"Character Field7\" required=\"false\" tooltip=\"Character Field7\" menu=\"\"/>\n\t\t<parameter id=\"Character Field8\" label=\"Character Field8\" required=\"false\" tooltip=\"Character Field8\" menu=\"\"/>\n\t\t<parameter id=\"Character Field9\" label=\"Character Field9\" required=\"false\" tooltip=\"Character Field9\" menu=\"\"/>\n\t\t<parameter id=\"Character Field10\" label=\"Character Field10\" required=\"false\" tooltip=\"Character Field10\" menu=\"\"/>\n\t\t<parameter id=\"Character Field11\" label=\"Character Field11\" required=\"false\" tooltip=\"Character Field11\" menu=\"\"/>\n\t\t<parameter id=\"Character Field12\" label=\"Character Field12\" required=\"false\" tooltip=\"Character Field12\" menu=\"\"/>\n\t\t<parameter id=\"Character Field13\" label=\"Character Field13\" required=\"false\" tooltip=\"Character Field13\" menu=\"\"/>\n\t\t<parameter id=\"Character Field14\" label=\"Character Field14\" required=\"false\" tooltip=\"Character Field14\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field1\" label=\"Integer Field1\" required=\"false\" tooltip=\"Integer Field1\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field2\" label=\"Integer Field2\" required=\"false\" tooltip=\"Integer Field2\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field3\" label=\"Integer Field3\" required=\"false\" tooltip=\"Integer Field3\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field4\" label=\"Integer Field4\" required=\"false\" tooltip=\"Integer Field4\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field5\" label=\"Integer Field5\" required=\"false\" tooltip=\"Integer Field5\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field6\" label=\"Integer Field6\" required=\"false\" tooltip=\"Integer Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field1\" label=\"Date Field1\" required=\"false\" tooltip=\"Date Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date Field2\" label=\"Date Field2\" required=\"false\" tooltip=\"Date Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date Field3\" label=\"Date Field3\" required=\"false\" tooltip=\"Date Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date Field4\" label=\"Date Field4\" required=\"false\" tooltip=\"Date Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date Field5\" label=\"Date Field5\" required=\"false\" tooltip=\"Date Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date Field6\" label=\"Date Field6\" required=\"false\" tooltip=\"Date Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field7\" label=\"Date Field7\" required=\"false\" tooltip=\"Date Field7\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field1\" label=\"Date/Time Field1\" required=\"false\" tooltip=\"Date/Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field2\" label=\"Date/Time Field2\" required=\"false\" tooltip=\"Date/Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field3\" label=\"Date/Time Field3\" required=\"false\" tooltip=\"Date/Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field4\" label=\"Date/Time Field4\" required=\"false\" tooltip=\"Date/Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field5\" label=\"Date/Time Field5\" required=\"false\" tooltip=\"Date/Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field6\" label=\"Date/Time Field6\" required=\"false\" tooltip=\"Date/Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field7\" label=\"Date/Time Field7\" required=\"false\" tooltip=\"Date/Time Field7\" menu=\"\"/>\n\t\t<parameter id=\"Time Field1\" label=\"Time Field1\" required=\"false\" tooltip=\"Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Time Field2\" label=\"Time Field2\" required=\"false\" tooltip=\"Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Time Field3\" label=\"Time Field3\" required=\"false\" tooltip=\"Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Time Field4\" label=\"Time Field4\" required=\"false\" tooltip=\"Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Time Field5\" label=\"Time Field5\" required=\"false\" tooltip=\"Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Time Field6\" label=\"Time Field6\" required=\"false\" tooltip=\"Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Time Field7\" label=\"Time Field7\" required=\"false\" tooltip=\"Time Field7\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"No record found\" value=\"&lt;%=@results['Look for existing notification content record']['Entry Id'].nil? || @results['Look for existing notification content record']['Entry Id']==&quot;&quot;%&gt;\">kinetic_helper_record_create_v2_1</task><task type=\"Complete\" label=\"Record found\" value=\"&lt;%=!@results['Look for existing notification content record']['Entry Id'].nil? &amp;&amp; @results['Look for existing notification content record']['Entry Id']&gt;&quot;&quot;%&gt;\">kinetic_helper_record_update_v2_2</task></dependents>\n    </task>\n      \n        <task name=\"Look for existing notification recipient record\" id=\"kinetic_helper_record_find_v3_5\" definition_id=\"kinetic_helper_record_find_v3\" x=\"528\" y=\"58\">\n      <version>3</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n\t\t<parameter id=\"SurveyInstanceID\" label=\"SurveyInstanceID\" required=\"false\" tooltip=\"SurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"CustomerSurveyInstanceID\" label=\"CustomerSurveyInstanceID\" required=\"false\" tooltip=\"CustomerSurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"Index Field1\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field1\" menu=\"\">Notification Recipient</parameter>\n        <parameter id=\"Index Field2\" label=\"Index Field2\" required=\"false\" tooltip=\"Index Field2\" menu=\"\">&lt;%=@answers['Notification Name']%&gt;</parameter>\n        <parameter id=\"Index Field3\" label=\"Index Field3\" required=\"false\" tooltip=\"Index Field3\" menu=\"\">&lt;%=@answers['Organization']%&gt;</parameter>\n        <parameter id=\"Character Field1\" label=\"Character Field1\" required=\"false\" tooltip=\"Character Field1\" menu=\"\"/>\n\t\t<parameter id=\"Character Field2\" label=\"Character Field2\" required=\"false\" tooltip=\"Character Field2\" menu=\"\">&lt;%=@answers['Language']%&gt;</parameter>\n\t\t<parameter id=\"Character Field3\" label=\"Character Field3\" required=\"false\" tooltip=\"Character Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field4\" label=\"Character Field4\" required=\"false\" tooltip=\"Character Field4\" menu=\"\"/>\n\t\t<parameter id=\"Character Field5\" label=\"Character Field5\" required=\"false\" tooltip=\"Character Field5\" menu=\"\"/>\n\t\t<parameter id=\"Character Field6\" label=\"Character Field6\" required=\"false\" tooltip=\"Character Field6\" menu=\"\"/>\n\t\t<parameter id=\"Character Field7\" label=\"Character Field7\" required=\"false\" tooltip=\"Character Field7\" menu=\"\"/>\n\t\t<parameter id=\"Character Field8\" label=\"Character Field8\" required=\"false\" tooltip=\"Character Field8\" menu=\"\"/>\n\t\t<parameter id=\"Character Field9\" label=\"Character Field9\" required=\"false\" tooltip=\"Character Field9\" menu=\"\"/>\n\t\t<parameter id=\"Character Field10\" label=\"Character Field10\" required=\"false\" tooltip=\"Character Field10\" menu=\"\"/>\n\t\t<parameter id=\"Character Field11\" label=\"Character Field11\" required=\"false\" tooltip=\"Character Field11\" menu=\"\"/>\n\t\t<parameter id=\"Character Field12\" label=\"Character Field12\" required=\"false\" tooltip=\"Character Field12\" menu=\"\"/>\n\t\t<parameter id=\"Character Field13\" label=\"Character Field13\" required=\"false\" tooltip=\"Character Field13\" menu=\"\"/>\n\t\t<parameter id=\"Character Field14\" label=\"Character Field14\" required=\"false\" tooltip=\"Character Field14\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field1\" label=\"Integer Field1\" required=\"false\" tooltip=\"Integer Field1\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field2\" label=\"Integer Field2\" required=\"false\" tooltip=\"Integer Field2\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field3\" label=\"Integer Field3\" required=\"false\" tooltip=\"Integer Field3\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field4\" label=\"Integer Field4\" required=\"false\" tooltip=\"Integer Field4\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field5\" label=\"Integer Field5\" required=\"false\" tooltip=\"Integer Field5\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field6\" label=\"Integer Field6\" required=\"false\" tooltip=\"Integer Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field1\" label=\"Date Field1\" required=\"false\" tooltip=\"Date Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date Field2\" label=\"Date Field2\" required=\"false\" tooltip=\"Date Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date Field3\" label=\"Date Field3\" required=\"false\" tooltip=\"Date Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date Field4\" label=\"Date Field4\" required=\"false\" tooltip=\"Date Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date Field5\" label=\"Date Field5\" required=\"false\" tooltip=\"Date Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date Field6\" label=\"Date Field6\" required=\"false\" tooltip=\"Date Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field7\" label=\"Date Field7\" required=\"false\" tooltip=\"Date Field7\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field1\" label=\"Date/Time Field1\" required=\"false\" tooltip=\"Date/Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field2\" label=\"Date/Time Field2\" required=\"false\" tooltip=\"Date/Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field3\" label=\"Date/Time Field3\" required=\"false\" tooltip=\"Date/Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field4\" label=\"Date/Time Field4\" required=\"false\" tooltip=\"Date/Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field5\" label=\"Date/Time Field5\" required=\"false\" tooltip=\"Date/Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field6\" label=\"Date/Time Field6\" required=\"false\" tooltip=\"Date/Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field7\" label=\"Date/Time Field7\" required=\"false\" tooltip=\"Date/Time Field7\" menu=\"\"/>\n\t\t<parameter id=\"Time Field1\" label=\"Time Field1\" required=\"false\" tooltip=\"Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Time Field2\" label=\"Time Field2\" required=\"false\" tooltip=\"Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Time Field3\" label=\"Time Field3\" required=\"false\" tooltip=\"Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Time Field4\" label=\"Time Field4\" required=\"false\" tooltip=\"Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Time Field5\" label=\"Time Field5\" required=\"false\" tooltip=\"Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Time Field6\" label=\"Time Field6\" required=\"false\" tooltip=\"Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Time Field7\" label=\"Time Field7\" required=\"false\" tooltip=\"Time Field7\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"No record found\" value=\"&lt;%=@results['Look for existing notification recipient record']['Entry Id'].nil? || @results['Look for existing notification recipient record']['Entry Id']==&quot;&quot;%&gt;\">kinetic_helper_record_create_v2_6</task><task type=\"Complete\" label=\"Record found\" value=\"&lt;%=!@results['Look for existing notification recipient record']['Entry Id'].nil? &amp;&amp; @results['Look for existing notification recipient record']['Entry Id']&gt;&quot;&quot;%&gt;\">kinetic_helper_record_update_v2_8</task></dependents>\n    </task>\n      \n        <task name=\"Create recipient record\" id=\"kinetic_helper_record_create_v2_6\" definition_id=\"kinetic_helper_record_create_v2\" x=\"659\" y=\"178\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n\t\t<parameter id=\"SurveyInstanceID\" label=\"SurveyInstanceID\" required=\"false\" tooltip=\"SurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"CustomerSurveyInstanceID\" label=\"CustomerSurveyInstanceID\" required=\"false\" tooltip=\"CustomerSurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"Index Field1\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field1\" menu=\"\">Notification Recipient</parameter>\n        <parameter id=\"Index Field2\" label=\"Index Field2\" required=\"false\" tooltip=\"Index Field2\" menu=\"\">&lt;%=@answers['Notification Name']%&gt;</parameter>\n        <parameter id=\"Index Field3\" label=\"Index Field3\" required=\"false\" tooltip=\"Index Field3\" menu=\"\">&lt;%=@answers['Organization']%&gt;</parameter>\n        <parameter id=\"Character Field1\" label=\"Character Field1\" required=\"false\" tooltip=\"Character Field1\" menu=\"\">&lt;%=@answers['Recipient Type']%&gt;</parameter>\n\t\t<parameter id=\"Character Field2\" label=\"Character Field2\" required=\"false\" tooltip=\"Character Field2\" menu=\"\">&lt;%=@answers['Language']%&gt;</parameter>\n\t\t<parameter id=\"Character Field3\" label=\"Character Field3\" required=\"false\" tooltip=\"Character Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field4\" label=\"Character Field4\" required=\"false\" tooltip=\"Character Field4\" menu=\"\"/>\n\t\t<parameter id=\"Character Field5\" label=\"Character Field5\" required=\"false\" tooltip=\"Character Field5\" menu=\"\"/>\n\t\t<parameter id=\"Character Field6\" label=\"Character Field6\" required=\"false\" tooltip=\"Character Field6\" menu=\"\"/>\n\t\t<parameter id=\"Character Field7\" label=\"Character Field7\" required=\"false\" tooltip=\"Character Field7\" menu=\"\"/>\n\t\t<parameter id=\"Character Field8\" label=\"Character Field8\" required=\"false\" tooltip=\"Character Field8\" menu=\"\"/>\n\t\t<parameter id=\"Character Field9\" label=\"Character Field9\" required=\"false\" tooltip=\"Character Field9\" menu=\"\"/>\n\t\t<parameter id=\"Character Field10\" label=\"Character Field10\" required=\"false\" tooltip=\"Character Field10\" menu=\"\"/>\n\t\t<parameter id=\"Character Field11\" label=\"Character Field11\" required=\"false\" tooltip=\"Character Field11\" menu=\"\"/>\n\t\t<parameter id=\"Character Field12\" label=\"Character Field12\" required=\"false\" tooltip=\"Character Field12\" menu=\"\"/>\n\t\t<parameter id=\"Character Field13\" label=\"Character Field13\" required=\"false\" tooltip=\"Character Field13\" menu=\"\">&lt;%=@answers['Recipient Value']%&gt;</parameter>\n\t\t<parameter id=\"Character Field14\" label=\"Character Field14\" required=\"false\" tooltip=\"Character Field14\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field1\" label=\"Integer Field1\" required=\"false\" tooltip=\"Integer Field1\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field2\" label=\"Integer Field2\" required=\"false\" tooltip=\"Integer Field2\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field3\" label=\"Integer Field3\" required=\"false\" tooltip=\"Integer Field3\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field4\" label=\"Integer Field4\" required=\"false\" tooltip=\"Integer Field4\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field5\" label=\"Integer Field5\" required=\"false\" tooltip=\"Integer Field5\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field6\" label=\"Integer Field6\" required=\"false\" tooltip=\"Integer Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field1\" label=\"Date Field1\" required=\"false\" tooltip=\"Date Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date Field2\" label=\"Date Field2\" required=\"false\" tooltip=\"Date Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date Field3\" label=\"Date Field3\" required=\"false\" tooltip=\"Date Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date Field4\" label=\"Date Field4\" required=\"false\" tooltip=\"Date Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date Field5\" label=\"Date Field5\" required=\"false\" tooltip=\"Date Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date Field6\" label=\"Date Field6\" required=\"false\" tooltip=\"Date Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field7\" label=\"Date Field7\" required=\"false\" tooltip=\"Date Field7\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field1\" label=\"Date/Time Field1\" required=\"false\" tooltip=\"Date/Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field2\" label=\"Date/Time Field2\" required=\"false\" tooltip=\"Date/Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field3\" label=\"Date/Time Field3\" required=\"false\" tooltip=\"Date/Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field4\" label=\"Date/Time Field4\" required=\"false\" tooltip=\"Date/Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field5\" label=\"Date/Time Field5\" required=\"false\" tooltip=\"Date/Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field6\" label=\"Date/Time Field6\" required=\"false\" tooltip=\"Date/Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field7\" label=\"Date/Time Field7\" required=\"false\" tooltip=\"Date/Time Field7\" menu=\"\"/>\n\t\t<parameter id=\"Time Field1\" label=\"Time Field1\" required=\"false\" tooltip=\"Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Time Field2\" label=\"Time Field2\" required=\"false\" tooltip=\"Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Time Field3\" label=\"Time Field3\" required=\"false\" tooltip=\"Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Time Field4\" label=\"Time Field4\" required=\"false\" tooltip=\"Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Time Field5\" label=\"Time Field5\" required=\"false\" tooltip=\"Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Time Field6\" label=\"Time Field6\" required=\"false\" tooltip=\"Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Time Field7\" label=\"Time Field7\" required=\"false\" tooltip=\"Time Field7\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_join_v1_9</task></dependents>\n    </task>\n      \n        \n      \n        <task name=\"Update existing recipient record\" id=\"kinetic_helper_record_update_v2_8\" definition_id=\"kinetic_helper_record_update_v2\" x=\"433\" y=\"173\">\n      <version>2</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n\t\t<parameter id=\"Request ID\" label=\"Request ID\" required=\"true\" tooltip=\"Enter the Request ID, stored in Request ID of the KS_SRV_Helper form\" menu=\"\">&lt;%=@results['Look for existing notification content records']['Entry Id']%&gt;</parameter>\t\n\t\t<parameter id=\"Status\" label=\"Status\" required=\"true\" menu=\"Active,Inactive,Delete\" tooltip=\"Enter the Request ID, stored in Request ID of the KS_SRV_Helper form\">Active</parameter>\n\t\t<parameter id=\"SurveyInstanceID\" label=\"SurveyInstanceID\" required=\"false\" tooltip=\"SurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"CustomerSurveyInstanceID\" label=\"CustomerSurveyInstanceID\" required=\"false\" tooltip=\"CustomerSurveyInstanceID\" menu=\"\"/>\n\t\t<parameter id=\"Index Field1\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field1\" menu=\"\"/>\n\t\t<parameter id=\"Index Field2\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field2\" menu=\"\"/>\n\t\t<parameter id=\"Index Field3\" label=\"Index Field1\" required=\"false\" tooltip=\"Index Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field1\" label=\"Character Field1\" required=\"false\" tooltip=\"Character Field1\" menu=\"\">&lt;%=@answers['Recipient Type']%&gt;</parameter>\n\t\t<parameter id=\"Character Field2\" label=\"Character Field2\" required=\"false\" tooltip=\"Character Field2\" menu=\"\"/>\n\t\t<parameter id=\"Character Field3\" label=\"Character Field3\" required=\"false\" tooltip=\"Character Field3\" menu=\"\"/>\n\t\t<parameter id=\"Character Field4\" label=\"Character Field4\" required=\"false\" tooltip=\"Character Field4\" menu=\"\"/>\n\t\t<parameter id=\"Character Field5\" label=\"Character Field5\" required=\"false\" tooltip=\"Character Field5\" menu=\"\"/>\n\t\t<parameter id=\"Character Field6\" label=\"Character Field6\" required=\"false\" tooltip=\"Character Field6\" menu=\"\"/>\n\t\t<parameter id=\"Character Field7\" label=\"Character Field7\" required=\"false\" tooltip=\"Character Field7\" menu=\"\"/>\n\t\t<parameter id=\"Character Field8\" label=\"Character Field8\" required=\"false\" tooltip=\"Character Field8\" menu=\"\"/>\n\t\t<parameter id=\"Character Field9\" label=\"Character Field9\" required=\"false\" tooltip=\"Character Field9\" menu=\"\"/>\n\t\t<parameter id=\"Character Field10\" label=\"Character Field10\" required=\"false\" tooltip=\"Character Field10\" menu=\"\"/>\n\t\t<parameter id=\"Character Field11\" label=\"Character Field11\" required=\"false\" tooltip=\"Character Field11\" menu=\"\"/>\n\t\t<parameter id=\"Character Field12\" label=\"Character Field12\" required=\"false\" tooltip=\"Character Field12\" menu=\"\"/>\n\t\t<parameter id=\"Character Field13\" label=\"Character Field13\" required=\"false\" tooltip=\"Character Field13\" menu=\"\">&lt;%=@answers['Recipient Value']%&gt;</parameter>\n\t\t<parameter id=\"Character Field14\" label=\"Character Field14\" required=\"false\" tooltip=\"Character Field14\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field1\" label=\"Integer Field1\" required=\"false\" tooltip=\"Integer Field1\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field2\" label=\"Integer Field2\" required=\"false\" tooltip=\"Integer Field2\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field3\" label=\"Integer Field3\" required=\"false\" tooltip=\"Integer Field3\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field4\" label=\"Integer Field4\" required=\"false\" tooltip=\"Integer Field4\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field5\" label=\"Integer Field5\" required=\"false\" tooltip=\"Integer Field5\" menu=\"\"/>\n\t\t<parameter id=\"Integer Field6\" label=\"Integer Field6\" required=\"false\" tooltip=\"Integer Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field1\" label=\"Date Field1\" required=\"false\" tooltip=\"Date Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date Field2\" label=\"Date Field2\" required=\"false\" tooltip=\"Date Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date Field3\" label=\"Date Field3\" required=\"false\" tooltip=\"Date Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date Field4\" label=\"Date Field4\" required=\"false\" tooltip=\"Date Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date Field5\" label=\"Date Field5\" required=\"false\" tooltip=\"Date Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date Field6\" label=\"Date Field6\" required=\"false\" tooltip=\"Date Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date Field7\" label=\"Date Field7\" required=\"false\" tooltip=\"Date Field7\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field1\" label=\"Date/Time Field1\" required=\"false\" tooltip=\"Date/Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field2\" label=\"Date/Time Field2\" required=\"false\" tooltip=\"Date/Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field3\" label=\"Date/Time Field3\" required=\"false\" tooltip=\"Date/Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field4\" label=\"Date/Time Field4\" required=\"false\" tooltip=\"Date/Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field5\" label=\"Date/Time Field5\" required=\"false\" tooltip=\"Date/Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field6\" label=\"Date/Time Field6\" required=\"false\" tooltip=\"Date/Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Date/Time Field7\" label=\"Date/Time Field7\" required=\"false\" tooltip=\"Date/Time Field7\" menu=\"\"/>\n\t\t<parameter id=\"Time Field1\" label=\"Time Field1\" required=\"false\" tooltip=\"Time Field1\" menu=\"\"/>\n\t\t<parameter id=\"Time Field2\" label=\"Time Field2\" required=\"false\" tooltip=\"Time Field2\" menu=\"\"/>\n\t\t<parameter id=\"Time Field3\" label=\"Time Field3\" required=\"false\" tooltip=\"Time Field3\" menu=\"\"/>\n\t\t<parameter id=\"Time Field4\" label=\"Time Field4\" required=\"false\" tooltip=\"Time Field4\" menu=\"\"/>\n\t\t<parameter id=\"Time Field5\" label=\"Time Field5\" required=\"false\" tooltip=\"Time Field5\" menu=\"\"/>\n\t\t<parameter id=\"Time Field6\" label=\"Time Field6\" required=\"false\" tooltip=\"Time Field6\" menu=\"\"/>\n\t\t<parameter id=\"Time Field7\" label=\"Time Field7\" required=\"false\" tooltip=\"Time Field7\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_join_v1_9</task></dependents>\n    </task>\n      \n        <task name=\"Join: Recipient\" id=\"system_join_v1_9\" definition_id=\"system_join_v1\" x=\"566.261348724365\" y=\"302.196014404297\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"type\" label=\"Type:\" required=\"true\" menu=\"All,Any,Some\" tooltip=\"How many dependents must be completed before continuing?\">Any</parameter>\n        <parameter id=\"number\" label=\"Number:\" required=\"false\" dependsOnId=\"type\" dependsOnValue=\"Some\" tooltip=\"If some, how many?\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_join_v1_11</task></dependents>\n    </task>\n      \n        <task name=\"Join: Content\" id=\"system_join_v1_10\" definition_id=\"system_join_v1\" x=\"118.338069915771\" y=\"325.678955078125\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"type\" label=\"Type:\" required=\"true\" menu=\"All,Any,Some\" tooltip=\"How many dependents must be completed before continuing?\">Any</parameter>\n        <parameter id=\"number\" label=\"Number:\" required=\"false\" dependsOnId=\"type\" dependsOnValue=\"Some\" tooltip=\"If some, how many?\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">system_join_v1_11</task></dependents>\n    </task>\n      \n        <task name=\"Join\" id=\"system_join_v1_11\" definition_id=\"system_join_v1\" x=\"360.426113128662\" y=\"450.988647460938\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"type\" label=\"Type:\" required=\"true\" menu=\"All,Any,Some\" tooltip=\"How many dependents must be completed before continuing?\">All</parameter>\n        <parameter id=\"number\" label=\"Number:\" required=\"false\" dependsOnId=\"type\" dependsOnValue=\"Some\" tooltip=\"If some, how many?\" menu=\"\"/>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents><task type=\"Complete\" label=\"\" value=\"\">kinetic_request_submission_close_v1_13</task></dependents>\n    </task>\n      \n        \n      \n        <task name=\"Close\" id=\"kinetic_request_submission_close_v1_13\" definition_id=\"kinetic_request_submission_close_v1\" x=\"367.624996185303\" y=\"546.267028808594\">\n      <version>1</version>\n      <configured>true</configured>\n      <defers>false</defers>\n      <deferrable>false</deferrable>\n      <visible>false</visible>\n      <parameters>\n        <parameter id=\"validation_status\" label=\"Validation Status:\" required=\"true\" tooltip=\"The value the Validation Status field on the specified Kinetic Request submission record will be set to.\" menu=\"\">Completed</parameter>\n        <parameter id=\"submission_id\" label=\"Submission Id:\" required=\"true\" tooltip=\"The instance id of the Kinetic Request submission to be updated.\" menu=\"\">&lt;%=@base['CustomerSurveyInstanceId']%&gt;</parameter>\n    </parameters><messages>\n        <message type=\"Create\"/>\n        <message type=\"Update\"/>\n        <message type=\"Complete\"/>\n      </messages>\n      <dependents/>\n    </task>\n      </request></taskTree>",
	    :description => "Kinetic Task Process Tree",
	    :notes => "A new task process"
  end
  if(TASK_VERSION == "Kinetic Task 4+")
  	puts "Task 4+ Used"
  end
end
