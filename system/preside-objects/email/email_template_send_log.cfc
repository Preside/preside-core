/**
 * A log of every email sent through the templating system
 *
 * @versioned                   false
 * @labelfield                  recipient
 * @datamanagerDefaultSortOrder datecreated desc
 * @dataExportFields            email_template,recipient,activity_type,activity_date,activity_code,activity_reason,activity_link
 * @datamanagerEnabled          true
 */
component extends="preside.system.base.SystemPresideObject" {
	property name="email_template" relationship="many-to-one" relatedto="email_template" required=false;

	property name="website_user_recipient"  relationship="many-to-one" relatedto="website_user"  required=false;
	property name="security_user_recipient" relationship="many-to-one" relatedto="security_user" required=false;

	property name="content" relationship="many-to-one" relatedto="email_template_send_log_content" required=false feature="emailCenterResend";

	property name="recipient" type="string" dbtype="varchar" maxlength=255 required=true;
	property name="sender"    type="string" dbtype="varchar" maxlength=255 required=true;
	property name="subject"   type="string" dbtype="varchar" maxlength=255;
	property name="resend_of" type="string" dbtype="varchar" maxlength=35;
	property name="send_args" type="string" dbtype="text" autofilter=false;

	property name="sent"           type="boolean" dbtype="boolean" default=false;
	property name="failed"         type="boolean" dbtype="boolean" default=false;
	property name="delivered"      type="boolean" dbtype="boolean" default=false;
	property name="hard_bounced"   type="boolean" dbtype="boolean" default=false;
	property name="opened"         type="boolean" dbtype="boolean" default=false;
	property name="marked_as_spam" type="boolean" dbtype="boolean" default=false;
	property name="unsubscribed"   type="boolean" dbtype="boolean" default=false;

	property name="sent_date"           type="date" dbtype="datetime";
	property name="failed_date"         type="date" dbtype="datetime";
	property name="delivered_date"      type="date" dbtype="datetime";
	property name="hard_bounced_date"   type="date" dbtype="datetime";
	property name="opened_date"         type="date" dbtype="datetime";
	property name="marked_as_spam_date" type="date" dbtype="datetime";
	property name="unsubscribed_date"   type="date" dbtype="datetime";

	property name="click_count" type="numeric" dbtype="int" default=0;

	property name="failed_reason" type="string"  dbtype="text";
	property name="failed_code"   type="numeric" dbtype="int";

	property name="activities" relationship="one-to-many" relatedto="email_template_send_log_activity" relationshipkey="message";

	property name="activity_type"       formula="activities.activity_type";
	property name="activity_ip"         formula="activities.user_ip";
	property name="activity_user_agent" formula="activities.user_agent";
	property name="activity_link"       formula="activities.link";
	property name="activity_code"       formula="activities.code";
	property name="activity_reason"     formula="activities.reason";
	property name="activity_date"       formula="activities.datecreated" type="date" dbtype="datetime";
}