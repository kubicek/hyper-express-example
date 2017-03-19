# clock.rb:  Displays the current time
class Clock < Hyperloop::Component
  param format: '%a, %e %b %Y %H:%M'
  before_mount do
    mutate.time Time.now.strftime(params.format)
    every(1) { mutate.time Time.now.strftime(params.format) unless state.status=="stopped"}
  end

  def stop_time
    mutate.status "stopped"
    puts state.status
  end

  render do
    div(class: "container") do
      H1 {"clock"}
      H2 {state.time}
      button.btn_danger.btn_xs {'STOP'}.on(:click) { stop_time }
    end
  end
end
