class UploadsController < ApplicationController
  def create
    file = params[:file]
    if file.present?
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type
      )

      render json: { url: url_for(blob) }, status: :ok
    else
      render json: { error: "Nenhum arquivo enviado ou mídia não suportada" }, status: :unprocessable_entity
    end
  end
end
