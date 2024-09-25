class UserMailer < ApplicationMailer
  def order_accepted(order)
    @order = order
    mail to: @order.user.email, subject: t('mailer.user_mailer.order_accepted.subject')
  end

  def order_shipped(order)
    @order = order
    mail to: @order.user.email, subject: t('mailer.user_mailer.order_shipped.subject')
  end
end
