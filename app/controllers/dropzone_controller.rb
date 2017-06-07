class DropzoneController < ApplicationController
  
  def upload
    dropzone_class = params[:dropzone_class].constantize
    dropzone_object = dropzone_class.new
    dropzone_object.send "#{ dropzone_class.dropzone_field(:container_type) }=", params[:dropzonable_class] if dropzone_class.dropzone_field?(:container_type)
    if dropzone_class.dropzone_field?(:container_id)
      dropzone_object.send "#{ dropzone_class.dropzone_field(:container_id) }=", params[:dropzonable_id]
    else
      dropzone_container_object = params[:dropzonable_class].constantize.create
      dropzone_object.send "#{ dropzone_class.dropzone_field(:container_id) }=", dropzone_container_object.id
    end
    dropzone_object.send "#{ dropzone_class.dropzone_field(:data) }=", params[:file]
    dropzone_object.send "#{ dropzone_class.dropzone_field(:custom) }=", params[:custom] if dropzone_class.dropzone_field?(:custom)

    if dropzone_object.save
      render json: dropzone_object.to_json
    else
      render json: {errors: dropzone_object.errors.full_messages.first}, status: 500
    end
  end

end
