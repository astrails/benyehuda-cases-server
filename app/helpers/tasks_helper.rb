module TasksHelper
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

  def textify_event(event)
    # TODO: gettext here
    s_(TASK_EVENTS[event])
  end

  def textify_full_nikud(task)
    task.full_nikkud ? _("Full Nikkud") : ""
  end

  def upload_javascripts
    javascript_tag <<-EOJS
    jQuery(document).ready(function() {
      if (!swfobject.hasFlashPlayerVersion("9.0.24")) {
        jQuery("#no_flash_player, #upload_documents").toggle();
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
        'onError': function(event, ID, fileObj, errorObj) {
          alert('#{_('Opps, something went wrong. Please try again later.')}');
          alert(errorObj.type + ' Error: ' + errorObj.info);
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

  def link_to_task_participant_email(task, role, text)
    return if task.send(role).blank? || task.send(role).disabled?
    return if :assignee == role && !task.editor?(current_user)

    mail_to task.send(role).email, text, :body => task_url(task), :subject => (_("Re: BenYehuda task: #%{task}") % { :task => task.id.to_s })
  end

  def toggle_chained_js
    "jQuery('#new_task_link, #new_task_container').toggle();"
  end

  def task_kinds_for_select
    TaskKind.all.map{|k| [Task.textify_kind(k.name), Task.textify_kind(k.name)]}
  end

  def task_states_for_select
    Task.aasm_states.collect(&:name).collect(&:to_s).map{|s| [Task.textify_state(s), s]}
  end

  def task_difficulties_for_select
    Task::DIFFICULTIES.keys.map{|k| [Task.textify_difficulty(k), k]}
  end

  def task_length_for_select
    [[s_("task length|Short"), "short"], [s_("task length|Medium"), "medium"], [s_("task length|Long"), "long"]]
  end

  def commentable_event_form(event)
    return unless @task.send("can_be_#{event}ed?")
    haml_tag(:div, :id => "#{event}_task") do
      haml_concat render(:partial => "tasks/#{event}")
    end
  end
end
