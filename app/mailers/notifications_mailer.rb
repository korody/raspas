# encoding: utf-8
class NotificationsMailer < ActionMailer::Base

	def new_message(message)
		@message = message
		mail(to: "raspas@raspas.com.br", from: "noreply@youdomain.dev", :subject => "#{message.assunto}")
	end

	def registration_confirmation(user)
		@user = user
		#attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
		mail(to: "#{user.name} <#{user.email}>", from: "raspas@raspas.com.br", subject: "Olá #{user.name}! Obrigado por experimentar o Raspas!")
	end

	def favourite_notice(favourite_micropost)
		@favourite_micropost = favourite_micropost
		mail(to: "#{favourite_micropost.poster.name} <#{favourite_micropost.poster.email}>", from: "raspas@raspas.com.br", subject: "Sua raspa foi favoritada por #{favourite_micropost.user.name} :)")
	end

	def follower_notice(relationship)
		@relationship = relationship
		mail(to: "#{relationship.followed.name} <#{relationship.followed.email}>", from: "raspas@raspas.com.br", subject: "#{relationship.follower.name} está lhe seguindo no Raspas :)")
	end
end