class FeedbacksController < ApplicationController
  before_action :set_rehearsal, only: [:index]
  before_action :set_feedback, only: [:destroy, :edit, :update, :show]
  
  def index
    @feedbacks = @rehearsal.feedbacks
  end

  def all
    @all_rehearsals = current_user.rehearsals

    @rehearsals_with_feedback = []
    @rehearsals_without_feedback = []
    @rehearsals_with_new_feedback = []

    @all_rehearsals.each do |rehearsal|
      rehearsal.feedbacks.count > 0 ? @rehearsals_with_feedback << rehearsal : @rehearsals_without_feedback << rehearsal
    end

    @rehearsals_with_feedback.each do |rehear_feed|
      rehear_feed.feedbacks.each do |rhf|
        @rehearsals_with_new_feedback << rehear_feed if !rhf.viewed_by_user
      end
    end

  end

  def destroy
    
  end

  def show
    @feedback.viewed_by_user = true
    @feedback.save

    @rehearsal = Rehearsal.find(@feedback.rehearsal_id)
    # @rehearsal_feedbacks = []

    # @rehearsal.feedbacks.each do |rf|
    #   @rehearsal_feedbacks << rf.id
    # end
    # @rehearsal_position = (@rehearsal_feedbacks.index(@rehearsal.id) + 1).to_s+( (@rehearsal_feedbacks.index(@rehearsal.id) + 1) > 1 ? 'th' : 'st')
  end

  def edit
    @feedback.save

    @rehearsal = Rehearsal.find(@feedback.rehearsal_id)
    @rehearsal_feedbacks = []

    @rehearsal.feedbacks.each do |rf|
      @rehearsal_feedbacks << rf.id
    end

  end

  def update
    @feedback.viewed_by_user = false
    user =  User.find(@feedback.rehearsals.first.trainee_id)
    respond_to do |format|
      if @feedback.update(feedback_params)
        AdminMailer.feedback_notice(user).deliver_now
        format.html { redirect_to rehearsals_all_path, notice: 'Lesson was updated created.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    # binding.pry
    rehearsal = Rehearsal.find(params[:rehearsal_id])
    feedback = rehearsal.feedbacks.build(feedback_params)
    respond_to do |format|
      if rehearsal.save
        format.html { redirect_to edit_feedback_path(feedback), notice: 'start your feedback' }
        format.json { render json: feedback }
      else
        format.html { render :new }
        format.json { render json: @feeedback.errors, status: :unprocessable_entity }
      end
     end
  end

  private

  def set_rehearsal
    @rehearsal = Rehearsal.find(params[:rehearsal_id])
  end

  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:user_id, :notes, :token, :video_token, :review_status, :concept_review, :video_type, :approved, :rehearsal_id)
  end
end
