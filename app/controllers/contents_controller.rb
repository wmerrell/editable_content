class ContentsController < ApplicationController

  # GET /contents/edit
  def edit
    if $editable_content_authorization
      if request.xhr?
        logger.debug("[Content.Edit] name = #{params[:p_name]}, controller = #{params[:p_controller]}, action = #{params[:p_action]}")
        @content = EcContent.first( :conditions => { :name => params[:p_name], :controller => params[:p_controller], :action => params[:p_action]} )
        val = {:id => @content.id, :content => @content.body}.to_json
        logger.debug("[Content.Edit] return json = #{val.inspect}")
        render :json => val
      else
        flash[:error] = 'This action expects an AJAX call.'
        redirect_to root_url + "?nonajax"
      end

    else
      flash[:error] = 'You are not authorized to perform that action.'
      redirect_to root_url + "?unauthorized"
    end
  end

  # POST /contents/update
  def update
    if $editable_content_authorization

      if request.xhr?
        @content = EcContent.find(params[:p_id])
        new_content = params[:p_content]
        logger.debug("[Content.Update] @content.id = #{@content.id}, new_content = #{new_content.inspect}")
        if @content.update_attributes(:body=>new_content)
          render :text => getInnerContent(@content.name, @content.controller, @content.action)
        else
          render :text => "fail", :status => 500
        end
      else
        flash[:error] = 'This action expects an AJAX call.'
        redirect_to root_url
      end
    else
      flash[:error] = 'You are not authorized to perform that action.'
      redirect_to root_url
    end
  end

  def help
    unless $editable_content_authorization
      flash[:error] = 'You are not authorized to perform that action.'
      redirect_to root_url
    end
  end
end
