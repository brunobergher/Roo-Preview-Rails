class TestimonialsController < ApplicationController
  def index
    @testimonials = Testimonial.recent
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)

    if @testimonial.save
      redirect_to testimonials_path, notice: "Thanks for sharing your testimonial!"
    else
      @testimonials = Testimonial.recent
      render :index, status: :unprocessable_entity
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:name, :email, :city, :message)
  end
end
