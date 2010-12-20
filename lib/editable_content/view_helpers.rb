module EditableContent
  module ViewHelpers

    #
    # This function inserts the code needed for editing editable content
    # into the head section of the page.
    #
    # Each editable field needs will need one editor and they are created with
    # the +create_content_editor+ function
    #
    # === Note
    # This function creates an unobtursive javascript event handler that
    # launches the editor. It uses +content_for+ to save the code in
    # the following variables: +stylesheet_list+, +javascript_list+,
    # and +javascript_data+. It assumes that you will have the following
    # in your head section.
    #
    #   <%= yield :stylesheet_list %>
    #   <%= yield :javascript_list %>
    #   <script type="text/javascript">
    #     <%= yield :javascript_data %>
    #   </script>
    #
    # === Usage
    #   <%= insert_editable_content -%>
    #   <%= create_content_editor("maintext") -%>
    #   <%= create_content_editor("contacttext") -%>
    #
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

    #
    # This function inserts the code needed to create the editor for a field
    # into the head section of the page.
    # Each editable field needs one editor and this is the function that
    # creates it.
    #
    # === Parameters
    # *name* This is the name of the field. This is the same name that will be
    # passed into the +getContent+ function
    #
    # === Note
    # This function creates an unobtursive javascript event handler that
    # launches the editor. It uses +content_for+ to save the code in
    # the +javascript_data+ variable. It assumes that you will have the following
    # in your head section.
    #
    #   <script type="text/javascript">
    #     <%= yield :javascript_data %>
    #   </script>
    #
    # === Usage
    #   <%= insert_editable_content -%>
    #   <%= create_content_editor("maintext") -%>
    #   <%= create_content_editor("contacttext") -%>
    #
    #
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

ActionView::Base.send :include, EditableContent::ViewHelpers
