class ApplicationController < ActionController::API
  before_action :set_resource, except: [:index, :create]
  before_action :authenticate, :authorize, only: [:destroy, :update]
  after_action :no_cache, only: [:create, :destroy, :update]
  rescue_from StandardError, with: :unknown_server_error
  rescue_from AuthenticationError, with: :authentication_error
  rescue_from ActionController::ParameterMissing, with: :bad_request_response
  rescue_from ForbiddenError, with: :forbidden_error
  rescue_from JWT::DecodeError, with: :verification_error
  rescue_from JWT::ExpiredSignature, with: :expired_signature
  rescue_from JWT::VerificationError, with: :verification_error
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # POST /api/{plural}
  def create
    set_resource(resource_class.new(resource_params))
    if get_resource.save
      render json: get_resource, status: :created
    else
      render json: get_resource.errors, status: :unprocessable_entity
    end
  end

  # GET /api/{plural_resource_variable}
  def index
    resources = apply_query(base_index_query, query_params)
                                .order(order_args)
                                .page(page_params[:page])
                                .per(page_params[:page_size])
    instance_variable_set(plural_resource_variable, resources)
    render_multiple
  end

  # GET /api/{resource_name}/:id
  def show
    render json: get_resource
  end

  # DELETE /api/{resource_name}/:id
  def destroy
    get_resource.destroy
    head :no_content
  end

  # PATCH/PUT /api/{resource_name}/:id
  def update
    if get_resource.update(resource_params)
      render json: get_resource
    else
      render json: get_resource.errors, status: :unprocessable_entity
    end
  end


  private

  def render_multiple
    resources = instance_variable_get(plural_resource_variable)
    render json: {
      page: resources.current_page,
      total_pages: resources.total_pages,
      page_size: resources.size,
      "#{resource_name.pluralize}": resources.as_json
    }
  end

  def wrap_in_transaction
    resource_class.transaction do
      yield
    end
  end

  # By default it is resource_class
  # Override for special filtering
  # Usage is base_index_query.where(...)...
  def base_index_query
    resource_class
  end

  def no_cache
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate' # HTTP 1.1.
    response.headers['Pragma'] = 'no-cache' # HTTP 1.0.
    response.headers['Expires'] = '0' # Proxies.
  end

  # The resource class based on resource_name
  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  # Sets resource based on id param
  def set_resource(resource = nil)
    resource ||= resource_class.find(params[:id])
    instance_variable_set("@#{resource_name}", resource)
  end

  # The singular resource name based on controller name
  # Override in controllers with non conventional names
  def resource_name
    @resource_name ||= controller_name.singularize
  end

  # Returns the resource from the created instance variable
  def get_resource
    instance_variable_get("@#{resource_name}")
  end

  # Returns the allowed parameters for searching
  # Override this method in each controller
  # to permit additional parameters to query on
  def query_params
    {}
  end

  # Returns the allowed parameters for pagination
  def page_params
    params.permit(:page, :page_size)
  end

  # Returns an array of all model attributes except created_at and updated_at
  def model_attributes
    resource_class.attribute_names.map(&:to_sym) - [:created_at, :updated_at]
  end

  # To be overriden by subclasses
  # in order to perform role checks
  def user_authorized
    true
  end

  # Plural name based on resource name
  def plural_resource_variable
    "@#{resource_name.pluralize}"
  end

  # Only allow a trusted parameter "white list" through.
  # the inheriting controller for the resource must implement
  # the method "#{resource_name}_params" to limit permitted
  # parameters for the individual model.
  # Inorder to handle create/update methods.
  def resource_params
    @resource_params ||= send("#{resource_name}_params")
  end

  # Set Header and response
  def prepare_unauthorized_response
    response.headers['WWW-Authenticate'] = 'Token realm="Evaluator"'
    response.status = :unauthorized
  end

  # Rescue from AuthenticationError
  def authentication_error
    prepare_unauthorized_response
    render json: {message: error_messages[:authentication_error]}
  end

  # Rescue from JWT::ExpiredSignature
  def expired_signature
    prepare_unauthorized_response
    render json: {message: error_messages[:expired_token]}
  end

  # Rescue from JWT::VerificationError
  def verification_error
    prepare_unauthorized_response
    render json: {message: error_messages[:token_verification]}
  end

  def error_messages
    Rails.application.config.configurations[:error_messages]
  end

  def messages
    Rails.application.config.configurations[:messages]
  end

  def forbidden_error(error)
    render json: {message: error.message}, status: :forbidden
  end

  def authorize
    raise ForbiddenError, error_messages[:forbidden] unless user_authorized
  end

  # Optional teacher only authorization
  def authorize_teacher
    raise ForbiddenError, error_messages[:forbidden_teacher_only] unless
      @current_user.teacher?
  end

  # Optional super user only authorization
  def authorize_super_user
    raise ForbiddenError, error_messages[:forbidden_super_user_only] unless
      @current_user.super_user?
  end

  # Optional student only
  def authorize_student
    raise ForbiddenError, error_messages[:forbidden_student_only] unless
      @current_user.student?
  end

  def apply_query(base, query_params)
    base.where(query_params)
  end


  # Attempts to set current user
  def authenticate
    begin
      pattern = /^Bearer /
      header  = request.headers["Authorization"]
      if header && header.match(pattern)
        token = header.gsub(pattern, '')
        @current_user = User.find_by_token token
        raise ForbiddenError, error_messages[:unverified_login] unless @current_user.verified?
      else
        raise AuthenticationError
      end
    rescue ActiveRecord::RecordNotFound
      raise AuthenticationError
    end
  end

  def authenticate_optional
    authenticate rescue false
  end

  def not_found
    render json: {message: error_messages[:record_not_found]}, status: :not_found
  end

  def bad_request_response
    render json: {message: error_messages[:bad_request]}, status: :bad_request
  end

  def unknown_server_error(e)
    message = "#{e.class} \n #{e.message}\n"
    message << e.annotated_source_code.to_s if e.respond_to?(:annotated_source_code)
    message << "\n" << ActionDispatch::ExceptionWrapper.new(env, e)
                        .application_trace.join('\n')
    logger.error "#{message}\n\n"
    render json: {message: error_messages[:internal_server_error]},
      status: :internal_server_error
  end

  def order_args
    :created_at
  end

end
