# clock.rb:  Displays the current time
class Clock < Hyperloop::Component
  param format: '%a, %e %b %Y %H:%M'
  before_mount do
    mutate.time Time.now.strftime(params.format)
    every(1) { mutate.time Time.now.strftime(params.format) unless state.status=="stopped"}
  end

  def toggle_time
    mutate.status state.status=="stopped" ? "running" : "stopped"
    puts state.status
  end

  render do
    div(class: "container") do
      H1 {"clock"}
      H2 {state.time}
      if state.status=="stopped"
        button.btn_success.btn_xs {'START'}.on(:click) { toggle_time }
      else
        button.btn_danger.btn_xs {'STOP'}.on(:click) { toggle_time }
      end
    end
  end
end
