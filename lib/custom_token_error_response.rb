module CustomTokenErrorResponse
  def body

    {
      status_code: 401,
      status: false,
      message: I18n.t('devise.failure.invalid', authentication_keys: User.authentication_keys.join('/'))
    }
    # or merge with existing values by
    # super.merge({key: value})
  end

  def status
    :unauthorized
  end
end