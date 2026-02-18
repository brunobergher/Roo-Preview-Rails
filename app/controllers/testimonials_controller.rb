class TestimonialsController < ApplicationController
  def index
    @testimonials = Testimonial.order(created_at: :desc)
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)

    if @testimonial.save
      redirect_to testimonials_path, notice: "Thanks for your testimonial!"
    else
      @testimonials = Testimonial.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def testimonial_params
    params.require(:testimonial).permit(:name, :body)
  end
end
