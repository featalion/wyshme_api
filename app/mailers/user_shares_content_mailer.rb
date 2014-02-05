class UserSharesContentMailer < ActionMailer::Base
  default from: "no-reply@wyshme.com"

  def share_email(content_share)
    @user = content_share.user
    @url = "http://wyshme.herokuapp.com/shares/#{content_share.hash_id}"
    @type_of_content = content_share.content_type
    @user_message = content_share.message
    @recipients = content_share.recipients

    mail to: content_share.recipients,
         subject: "#{@user.email} has shared #{@type_of_content} with you on WyshMe!"
  end

end
