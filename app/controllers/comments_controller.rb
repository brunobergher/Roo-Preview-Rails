class CommentsController < ApplicationController
  def create
    @testimonial = Testimonial.find(params[:testimonial_id])
    @comment = @testimonial.comments.build(comment_params)

    if @comment.save
      redirect_to testimonials_path, notice: "Comment added!"
    else
      redirect_to testimonials_path, alert: "Comment could not be saved. Make sure name and comment are filled in."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:author_name, :body)
  end
end
