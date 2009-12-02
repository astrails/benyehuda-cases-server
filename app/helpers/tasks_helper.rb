module TasksHelper
  TASK_STATES = {
    "unassigned" => "Unassigned",
    "assigned" => "Assigned/Work in Progress",
    "stuck" => "Editors Help Required",
    "partial" => "Partialy Ready",
    "waits_for_editor_approve" => "Waits for Editor's approvement",
    "rejected" => "Rejected by Editor", 
    "approved" => "Approved by Editor",
    "ready_to_publish" => "Ready to Publish",
    "other_task_created" => "Another Task Created"
  }

  def textify_state(state)
    TASK_STATES[state]
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
        'fileDesc'  : 'Choose files to attach to the project:',
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
          alert('Opps, something went wrong. Please try again later.');
          window.location.href = window.location.href;
        }
      });
    });
    EOJS
  end
end
