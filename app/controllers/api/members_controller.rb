class Api::MembersController < ApiController
  def update
    p 'test'
    binding.pry
    render json: { message: 'test' }
  end
end
