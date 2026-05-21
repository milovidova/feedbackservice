module JwtAuth
  extend ActiveSupport::Concern

  included do
    helper_method :load_user_by_jti, :encrypt_payload, :decrypt_payload
  end

  def load_user_by_jti
    payload = decrypt_payload
    Rails.logger.info "DECRYPTED PAYLOAD: #{payload.inspect}"

    return if performed? || payload.nil?

    body = payload[0] || {}
    jti = body['jti']
    Rails.logger.info "PAYLOAD JTI: #{jti.inspect}"

    @user = User.find_by_jti(jti)
    Rails.logger.info "FOUND USER ID: #{@user&.id.inspect}"

    unless @user
      render json: {
        messages: "Unauthorized",
        is_success: false,
      }, status: :unauthorized
    end
  end

  def encrypt_payload(payload)
    jwt_signing_key = Rails.application.credentials.jwt_signing_key!
    JWT.encode(payload, jwt_signing_key, 'HS256')
  end

  def decrypt_payload
    bearer = request.headers["Authorization"]
    Rails.logger.info "AUTH HEADER: #{bearer.inspect}"

    if bearer.blank?
      render json: {
        messages: "Unauthorized - missing token",
        is_success: false
      }, status: :unauthorized and return
    end

    jwt = bearer.split(' ').last
    Rails.logger.info "JWT TOKEN: #{jwt.inspect}"

    jwt_signing_key = Rails.application.credentials.jwt_signing_key!
    JWT.decode(jwt, jwt_signing_key, true, { algorithm: 'HS256' })
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT DECODE ERROR: #{e.class} - #{e.message}"
    render json: {
      messages: "Unauthorized - invalid token",
      is_success: false
    }, status: :unauthorized
  end
end