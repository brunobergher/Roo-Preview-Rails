class TestimonialsController < ApplicationController

  def index
    @testimonials = Testimonial.recent_first
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)

    if @testimonial.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to testimonials_path, notice: "Testimonial added!" }
      end
    else
      @testimonials = Testimonial.recent_first
      render :index, status: :unprocessable_entity
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:name, :body)
  end
end
