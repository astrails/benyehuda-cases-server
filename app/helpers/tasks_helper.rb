module TasksHelper
  TASK_STATES = {
    "unassigned" => N_("task state|Unassigned"),
    "assigned" => N_("task state|Assigned/Work in Progress"),
    "stuck" => N_("task state|Editors Help Required"),
    "partial" => N_("task state|Partialy Ready"),
    "waits_for_editor" => N_("task state|Waits for Editor's approvement"),
    "rejected" => N_("task state|Rejected by Editor"), 
    "approved" => N_("task state|Approved by Editor"),
    "ready_to_publish" => N_("task state|Ready to Publish"),
    "other_task_created" => N_("task state|Another Task Created")
  }

  TASK_EVENTS = {
    # editor
    "approve" => N_("task event|Approve"),
    "reject" => N_("task event|Reject"),
    "complete" => N_("task event|Mark as Completed"),
    "create_other_task" => N_("task event|Create Other Task"),
    # assignee
    "finish" => N_("task event|Finish"),
    "abandon" => N_("task event|Abandon"),
    "help_required" => N_("task event|Need Editor's Help"),
    "finish_partially" => N_("task event|Mark as Finished Partly")
  }

  def textify_state(state)
    # TODO: gettext here
    s_(TASK_STATES[state])
  end

  def textify_event(event)
    # TODO: gettext here
    s_(TASK_EVENTS[event])
  end

  def upload_javascripts
    javascript_tag <<-EOJS
    jQuery(document).ready(function() {
      if (!swfobject.hasFlashPlayerVersion("9.0.24")) {
        jQuery("#no_flash_player").toggle();
        return;
      }
      jQuery("#upload_documents").uploadify({
        'method'    : 'POST',
        'cancelImg' : '/images/cancel.png',
        'uploader'  : '/uploadify.swf',
        'fileDataName'  : 'document[file]',
        'script'    : '#{task_documents_path(@task)}',
        'auto'      : true,
        'multi'     : true,
        'fileDesc'  : '#{_('Choose files to attach to the project:')}',
        'hideButton': false,
        'scriptAccess': 'always',
        'folder': '/stub',
        'queueID'   : 'fileQueue',
        'wmode'     : 'transparent',
        'sizeLimit' : 9*1024*1024,
        'scriptData': {
          '_benyehuda_session': encodeURIComponent('#{u cookies['_benyehuda_session']}'),
          'authenticity_token': encodeURIComponent('#{u form_authenticity_token}'),
          'format': 'js'
          },
        'onComplete': function(e, queueID, fileObj, response) {
          eval(response);
        },
        'onError': function() {
          alert('#{_('Opps, something went wrong. Please try again later.')}');
          window.location.href = window.location.href;
        }
      });
    });
    EOJS
  end

  def has_rejection_errors?
    @task.rejection_comment && !@task.rejection_comment.errors.blank?
  end

  def has_abandoning_errors?
    @task.abandoning_comment && !@task.abandoning_comment.errors.blank?
  end
end
