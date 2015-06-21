class UserMailer < ApplicationMailer
  def welcome_email(user)
    message = {
      to: [
        { email: user.email, name: user.name },
      ],
      subject: "Bem-vindo ao raspas, #{user.first_name}",
      global_merge_vars: [
        { name: 'RECIPIENT_NAME', content: user.name },
        { name: 'ROOT_URL', content: root_url }
      ]
    }

    mandrill_dispatcher('welcome', [], message)
  end

  def password_reset_request(user, token)
    message = {
      to: [
        { email: user.email, name: user.name },
      ],
      subject: "Você esqueceu sua senha #{user.first_name}?",
      global_merge_vars: [
        { name: 'RECIPIENT_NAME', content: user.name },
        { name: 'PASSWORD_RESET_URL', content: edit_password_reset_url(token, email: user.email) }
      ]
    }

    mandrill_dispatcher('password-reset-request', [], message)
  end
end
