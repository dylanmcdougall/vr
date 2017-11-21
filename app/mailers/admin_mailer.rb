class AdminMailer < ApplicationMailer
  add_template_helper(EmailHelper)
  default from: '\'Video Rehearser\' <notification@videorehearser.com>'

  # sending admin mail when a new user registers
  def new_user_waiting_for_approval
    @url  = 'https://videorehearser.herokuapp.com/users/sign_in'
    mail(to: 'carlos@videorehearser.com', subject: "New User Signup")
  end

  # sending user welcoming email
  def user_register_notice(user)
    @user = user
    @url = 'https://videorehearser.herokuapp.com/users/sign_in'
    mail( to: @user.email, subject: "Thanks for signing up!")
  end

  # sending approval update to user
  def user_approved_notice(user)
    @url = 'https://videorehearser.herokuapp.com/users/sign_in'
    @user = user
    mail(from: '\'Carlos Vazquez\' <notification@videorehearser.com>', to: @user.email, subject: "Welcome to vR!")
  end

  # sending notification to trainee that they have a new feedback available
  def feedback_notice(user)
    @url = 'https://videorehearser.herokuapp.com/users/sign_in'
    @user = user
    mail( to: @user.email, subject: "You got feedback.")
  end

  # sending trainee and email notifying them of a lesson completed
  def lesson_complete_notice(user, status, message, lesson)
    @url = 'https://videorehearser.herokuapp.com/courses/'+lesson.topic.course.id.to_s+'/topics/'+lesson.topic.id.to_s+'/lessons/'+lesson.id.to_s
    @user = user
    @lesson = lesson
    @status = status
    @message = message
    mail( to:@user.email, subject: message )
  end

  # sending mail to team with information on a new lead up
  def lead_notice(user)
    @url = 'https://videorehearser.herokuapp.com/users/sign_in'
    @user = user
    mail( to:'carlos@videorehearser.com', subject: "#{user.first_name} #{user.last_name} #red @jcvazquez6")
  end

end

