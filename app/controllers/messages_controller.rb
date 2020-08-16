class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :parse

  def parse
    path_id = params[:path].to_i - 1
    question_id = params[:question].to_i - 1
    user_input = params[:user_input]
    text = ''
    end_of_path = false

    path = Path.all[path_id.to_i]
    if path
      text = path.questions[question_id].content
    else
      text = path.questions.first.content
    end

    end_of_path = true if question_id + 1 > path.questions.length

    question_partial = render_to_string partial: "messages/message_json_right",
                                        formats: [:html], layout: false, locals: { message: user_input }
    answer_partial = render_to_string partial: "messages/message_json_left",
                                      formats: [:html], layout: false, locals: { message: text }
    # puts "I am in #parse"
    # puts answer_partial
    render json: { question: question_partial, answer: answer_partial, end_of_path: end_of_path }
  end

  def paths
    text = [
      "Welcome to MyMSDChat!",
      "Please select from the following options",
      "1. COVID 19 support for individuals",
      "2. Seeking employment",
      "3. Find the nearest Work and Income Service Centre",
      "4. I have urgent or unexpected costs to cover"
    ]

    question_partial = render_to_string partial: "messages/path",
                                        formats: [:html], layout: false, locals: { message: text }

    render json: { paths: question_partial }
  end
end
