module EditableContent
  module ActionControllerExtensions
    module ApplicationHelpers
      def insert_editable_content()
        if $editable_content_authorization
          content_for(:stylesheet_list) { stylesheet_link_tag "markitup/skins/simple/style.css" }
          content_for(:stylesheet_list) { stylesheet_link_tag "markitup/sets/textile/style.css" }
          content_for(:javascript_list) { javascript_include_tag "markitup/jquery.markitup.js" }
          content_for(:javascript_list) { javascript_include_tag "markitup/sets/textile/set.js" }
          content_for(:javascript_data) { <<-SCRIPTDATA

            var content_id = 0;
            var content_name = "";

            function openEditor(name, controller, action) {
              content_name = name;
              $.get("/contents/edit",
                {p_name:name, p_controller:controller, p_action:action},
                jQuery.proxy(this, function(data) {
                  content_id = data.id;
                  $("#ec_edit_textarea").val(data.content);
                  $("#ec_edit_dialog_form").dialog('open');
              }));
            }

            $(function() {
              // a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
              $("#ec_edit_dialog_form").dialog("destroy");

              $("#ec_edit_textarea").markItUp(mySettings);

              $("#ec_edit_dialog_form").dialog({
                autoOpen: false,
                height: 375,
                width: 1000,
                modal: true,
                buttons: {
                  'Save': function() {
                    $.post("/contents/update",
                      {p_id:content_id, p_content:$("#ec_edit_textarea").val()},
                      jQuery.proxy(this, function(data) {
                        $("#ec_edit_frame_" + content_name).html(data);
                      })
                    );
                    $(this).dialog('close');
                  },
                  Cancel: function() {
                    $(this).dialog('close');
                  }
                },
                close: function() {
                  $("#ec_edit_textarea").html("");
                }
              });
            });
SCRIPTDATA
          }

          editor_text = <<EDITOR_FORM
            <div id="ec_edit_dialog_form" title="Edit Content" style="padding: 0; display: none;">
              <form style="padding: 5px 0 0 0;" >
                <textarea name="ec_edit_textarea" id="ec_edit_textarea" cols="80" style="width: 99.5%; height: 200px; min_height: 200px;" class="ui_widget_content ui_corner_all" ></textarea>
              </form>
            </div>
EDITOR_FORM
          editor_text.html_safe
        end
      end

      def create_content_editor(name)
        if $editable_content_authorization
          content_for(:javascript_data) { <<-SCRIPTDATA
            $(function() {
              $("#ec_edit_button_#{name}").click( function(event) {
                openEditor("#{name}", "#{controller_name()}", "#{action_name()}");
                event.preventDefault();
              });
            });
SCRIPTDATA
          }
        end
      end

    end
  end
end

ActionView::Base.send :include, EditableContent::ActionControllerExtensions::ApplicationHelpers
