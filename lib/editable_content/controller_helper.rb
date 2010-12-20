module EditableContent
  module ControllerFunctions

    #
    # This function retrieves the editable content from the database.
    # If +setEditableAuthorization+ is set to true then a button
    # to launch the editor is prepended to the content.
    #
    # Each editable field needs will need one editor and they are created with
    # the +create_content_editor+ function in the view file.
    #
    # === Parameters:
    # *name* This is the name of the field. This is the same name that will be
    # passed into the +create_content_editor+ function.
    #
    # === Usage:
    #   def index
    #     @content = getContent("maintext")
    #   end
    #
    def getContent(name="")
      text = "<div id=\"ec_edit_frame_#{name}\">" + getInnerContent(name, controller_name(), action_name()) + "</div>"
      if $editable_content_authorization
        text = "<img id=\"ec_edit_button_#{name}\" class=\"edit_icon\" width=\"16\" height=\"16\" src=\"/images/pencil.png\" title=\"Edit this Content\" alt=\"Edit this Content Button\" />" + text
      end
      text.html_safe
    end

    #
    # This function formats the supplied content using the same processor that
    # editable content uses.
    #
    # === Parameters:
    # *content* The text to be converted. This expects a textile formated string
    # and returns html formated text suitable for display.
    #
    # === Usage:
    #   def index
    #     @content = processContent("This is *textile* _text_.")
    #   end
    #
    def processContent(content=nil)
      if content
        text = parseContent(content.gsub(/&#39;/, "'"))
      else
        text = "<div class=\"error\">No Content.</div>".html_safe
      end
    end

    # This is used to set up the permissions for the editable content system.
    # This allows you to control who can edit a editable content field.
    #
    # === Parameters:
    # *permission* A boolean value. If +true+ the editor is created and enabled,
    # if +false+ the editor is not created.
    #
    # === Usage:
    # The easiest way to use the permissions system is to use a +before_filter+
    # in the application_controller, like this:
    #
    #   before_filter proc{ setEditableAuthorization(current_user.is?( :editor )) }
    #
    # In this example, if the current user is an editor then they can edit fields.
    #
    def setEditableAuthorization(permission = false)
      $editable_content_authorization = permission
    end

  private

    def getInnerContent(name, controller, action)
      content = EcContent.first( :conditions => { :name => name, :controller => controller, :action => action} )
      if !content
        text = "<div class=\"error\">No Content for #{controller}:#{action}.#{name}.</div>"
        content = EcContent.new({ :name => name, :controller => controller, :action => action, :body => text })
        content.save
      else
        if content.body.blank?
          text = "<div class=\"error\">Content.body for #{controller}:#{action}.#{name} is blank.</div>"
        else
          text = parseContent(content.body.gsub(/&#39;/, "'"))
        end
      end
      text.html_safe
    end

    def parseContent(content)
      parser = Radius::Parser.new($editable_content_radius_context, :tag_prefix => 'r')
      text = RedCloth.new(parser.parse(content)).to_html.html_safe
    end

    # Define tags on a context that will be available to a template:
    $editable_content_radius_context = Radius::Context.new do |c|

      c.define_tag 'repeat' do |tag|
        number = (tag.attr['times'] || '1').to_i
        result = ''
        number.times { result << tag.expand }
        result
      end

      c.define_tag 'hello' do |tag|
        "Hello #{tag.attr['name'] || 'World'}!"
      end

      c.define_tag 'lorem' do |tag|
        word_count = (tag.attr['wordcount'] || '20').to_i
        # ===== words
        words =<<EOS
lorem ipsum dolor sit amet  consectetuer adipiscing elit  integer in mi a mauris ornare sagittis
suspendisse potenti  suspendisse dapibus dignissim dolor  nam sapien tellus  tempus et  tempus ac
tincidunt in  arcu  duis dictum  proin magna nulla  pellentesque non  commodo et  iaculis sit amet
mi  mauris condimentum massa ut metus  donec viverra  sapien mattis rutrum tristique  lacus eros
semper tellus  et molestie nisi sapien eu massa  vestibulum ante ipsum primis in faucibus orci
luctus et ultrices posuere cubilia curae; fusce erat tortor  mollis ut  accumsan ut  lacinia
gravida  libero  curabitur massa felis  accumsan feugiat  convallis sit amet  porta vel  neque  duis
et ligula non elit ultricies rutrum  suspendisse tempor  quisque posuere malesuada velit  sed
pellentesque mi a purus  integer imperdiet  orci a eleifend mollis  velit nulla iaculis arcu  eu
rutrum magna quam sed elit  nullam egestas  integer interdum purus nec mauris  vestibulum ac mi in
nunc suscipit dapibus  duis consectetuer  ipsum et pharetra sollicitudin  metus turpis facilisis
magna  vitae dictum ligula nulla nec mi  nunc ante urna  gravida sit amet  congue et  accumsan
vitae  magna  praesent luctus  nullam in velit  praesent est  curabitur turpis  class aptent taciti
sociosqu ad litora torquent per conubia nostra  per inceptos hymenaeos  cras consectetuer  nibh in
lacinia ornare  turpis sem tempor massa  sagittis feugiat mauris nibh non tellus  phasellus mi
fusce enim  mauris ultrices  turpis eu adipiscing viverra  justo libero ullamcorper massa  id
ultrices velit est quis tortor  quisque condimentum  lacus volutpat nonummy accumsan  est nunc
imperdiet magna  vulputate aliquet nisi risus at est  aliquam imperdiet gravida tortor  praesent
interdum accumsan ante  vivamus est ligula  consequat sed  pulvinar eu  consequat vitae  eros  nulla
elit nunc  congue eget  scelerisque a  tempor ac  nisi  morbi facilisis  pellentesque habitant morbi
tristique senectus et netus et malesuada fames ac turpis egestas  in hac habitasse platea dictumst
suspendisse vel lorem ut ligula tempor consequat  quisque consectetuer nisl eget elit  proin quis
mauris ac orci accumsan suscipit  sed ipsum  sed vel libero nec elit feugiat blandit  vestibulum
purus nulla  accumsan et  volutpat at  pellentesque vel  urna  suspendisse nonummy  aliquam pulvinar
libero  donec vulputate  orci ornare bibendum condimentum  lorem elit dignissim sapien  ut aliquam
nibh augue in turpis  phasellus ac eros  praesent luctus  lorem a mollis lacinia  leo turpis commodo
sem  in lacinia mi quam et quam  curabitur a libero vel tellus mattis imperdiet  in congue  neque ut
scelerisque bibendum  libero lacus ullamcorper sapien  quis aliquet massa velit vel orci  fusce in
nulla quis est cursus gravida  in nibh  lorem ipsum dolor sit amet  consectetuer adipiscing elit
integer fermentum pretium massa  morbi feugiat iaculis nunc  aenean aliquam pretium orci  cum sociis
natoque penatibus et magnis dis parturient montes  nascetur ridiculus mus  vivamus quis tellus vel
quam varius bibendum  fusce est metus  feugiat at  porttitor et  cursus quis  pede  nam ut augue
nulla posuere  phasellus at dolor a enim cursus vestibulum  duis id nisi  duis semper tellus ac
nulla  vestibulum scelerisque lobortis dolor  aenean a felis  aliquam erat volutpat  donec a magna
vitae pede sagittis lacinia  cras vestibulum diam ut arcu  mauris a nunc  duis sollicitudin erat sit
amet turpis  proin at libero eu diam lobortis fermentum  nunc lorem turpis  imperdiet id  gravida
eget  aliquet sed  purus  ut vehicula laoreet ante  mauris eu nunc  sed sit amet elit nec ipsum
aliquam egestas  donec non nibh  cras sodales pretium massa  praesent hendrerit est et risus
vivamus eget pede  curabitur tristique scelerisque dui  nullam ullamcorper  vivamus venenatis velit
eget enim  nunc eu nunc eget felis malesuada fermentum  quisque magna  mauris ligula felis  luctus
a  aliquet nec  vulputate eget  magna  quisque placerat diam sed arcu  praesent sollicitudin
aliquam non sapien  quisque id augue  class aptent taciti sociosqu ad litora torquent per conubia
nostra  per inceptos hymenaeos  etiam lacus lectus  mollis quis  mattis nec  commodo facilisis
nibh  sed sodales sapien ac ante  duis eget lectus in nibh lacinia auctor  fusce interdum lectus non
dui  integer accumsan  quisque quam  curabitur scelerisque imperdiet nisl  suspendisse potenti  nam
massa leo  iaculis sed  accumsan id  ultrices nec  velit  suspendisse potenti  mauris bibendum
turpis ac viverra sollicitudin  metus massa interdum orci  non imperdiet orci ante at ipsum  etiam
eget magna  mauris at tortor eu lectus tempor tincidunt  phasellus justo purus  pharetra ut
ultricies nec  consequat vel  nisi  fusce vitae velit at libero sollicitudin sodales  aenean mi
libero  ultrices id  suscipit vitae  dapibus eu  metus  aenean vestibulum nibh ac massa  vivamus
vestibulum libero vitae purus  in hac habitasse platea dictumst  curabitur blandit nunc non arcu  ut
nec nibh  morbi quis leo vel magna commodo rhoncus  donec congue leo eu lacus  pellentesque at erat
id mi consequat congue  praesent a nisl ut diam interdum molestie  fusce suscipit rhoncus sem  donec
pretium  aliquam molestie  vivamus et justo at augue aliquet dapibus  pellentesque felis  morbi
semper  in venenatis imperdiet neque  donec auctor molestie augue  nulla id arcu sit amet dui
lacinia convallis  proin tincidunt  proin a ante  nunc imperdiet augue  nullam sit amet arcu
quisque laoreet viverra felis  lorem ipsum dolor sit amet  consectetuer adipiscing elit  in hac
habitasse platea dictumst  pellentesque habitant morbi tristique senectus et netus et malesuada
fames ac turpis egestas  class aptent taciti sociosqu ad litora torquent per conubia nostra  per
inceptos hymenaeos  nullam nibh sapien  volutpat ut  placerat quis  ornare at  lorem  class aptent
taciti sociosqu ad litora torquent per conubia nostra  per inceptos hymenaeos  morbi dictum massa id
libero  ut neque  phasellus tincidunt  nibh ut tincidunt lacinia  lacus nulla aliquam mi  a interdum
dui augue non pede  duis nunc magna  vulputate a  porta at  tincidunt a  nulla  praesent facilisis
suspendisse sodales feugiat purus  cras et justo a mauris mollis imperdiet  morbi erat mi  ultrices
eget  aliquam elementum  iaculis id  velit  in scelerisque enim sit amet turpis  sed aliquam  odio
nonummy ullamcorper mollis  lacus nibh tempor dolor  sit amet varius sem neque ac dui  nunc et est
eu massa eleifend mollis  mauris aliquet orci quis tellus  ut mattis  praesent mollis consectetuer
quam  nulla nulla  nunc accumsan  nunc sit amet scelerisque porttitor  nibh pede lacinia justo
tristique mattis purus eros non velit  aenean sagittis commodo erat  aliquam id lacus  morbi
vulputate vestibulum elit
EOS
        words.gsub!(/\n/,' ')
        words.gsub!(/  */,' ')
        words.strip!
        words = words.split(/ /)

        lorem = ""

        # ===== total
        twn = 0
        twc = word_count
        while twn < twc

          # ===== paragraph
          pwn = 0
          pwc = rand(100)+50
          while pwn < pwc and twn < twc do

            # ===== sentence
            swn = 0
            swc = rand(10)+3
            while swn < swc and pwn < pwc and twn < twc do
              word = words[rand(words.length)]
              if swn == 0
                lorem << "#{word.capitalize} "
              else
                lorem << "#{word} "
              end
              twn +=1
              pwn +=1
              swn +=1
            end
            lorem << ". "
          end
          lorem << "\n\n"
        end
        lorem = lorem.gsub!(/ \./,'.')
      end # end of lorem

    end # end of $context

  end
end

ActionController::Base.send :include, EditableContent::ControllerFunctions
