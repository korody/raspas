class ApplicationMailer < ActionMailer::Base
  default from: 'raspas@raspas.com.br'

  layout 'mailer'

  def mandrill_dispatcher(template_name, template_content, message)
    mandrill_client ||= Mandrill::API.new(Rails.application.secrets.MANDRILL_APIKEY)
    mandrill_client.messages.send_template template_name, template_content, message
  end
end

