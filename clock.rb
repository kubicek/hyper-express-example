# clock.rb:  Displays the current time
class Clock < Hyperloop::Component
  param format: '%a, %e %b %Y %H:%M'
  before_mount do
    mutate.time Time.now.strftime(params.format)
    mutate.running true
    every(1) { mutate.time Time.now.strftime(params.format) if state.running}
  end

  def toggle_time
    mutate.running !state.running
  end

  render do
    div(class: "container") do
      H1 {"clock"}
      H2 {state.time}
      unless state.running
        button.btn_success.btn_xs {'START'}.on(:click) { toggle_time }
      else
        button.btn_danger.btn_xs {'STOP'}.on(:click) { toggle_time }
      end
    end
  end
end
