require 'faraday'
require 'oj'

require_relative './api_exceptions'
require_relative './http_status_codes'

module Connection

  include HttpStatusCodes
  include ApiExceptions

  attr_accessor :response

  API_REQUESTS_QUOTA_REACHED_MESSAGE = 'You have reached limit to access the API'

  def client(host)
    @client ||= Faraday.new(host) do |client|
      client.request :url_encoded
      client.headers['Content-Type'] = 'application/json'
      client.adapter Faraday.default_adapter
    end
  end

  def request(http_method:, host:, endpoint:, params: {})
    @response = client(host).public_send(http_method, endpoint, params)
    parsed_response = Oj.load(response.body)

    return parsed_response if response_successful?

    raise error_class, "Code: #{response.status}, response: #{response.body}"
  end

  private

  def error_class
    case response.status
    when HTTP_BAD_REQUEST_CODE
      BadRequestError
    when HTTP_UNAUTHORIZED_CODE
      UnauthorizedError
    when HTTP_FORBIDDEN_CODE
      return ApiRequestsQuotaReachedError if api_requests_quota_reached?
      ForbiddenError
    when HTTP_NOT_FOUND_CODE
      NotFoundError
    when HTTP_UNPROCESSABLE_ENTITY_CODE
      UnprocessableEntityError
    else
      ApiError
    end
  end

  def response_successful?
    HTTP_OK_CODES.include?(response.status)
  end

  def api_requests_quota_reached?
    response.body.match?(API_REQUESTS_QUOTA_REACHED_MESSAGE)
  end

end
