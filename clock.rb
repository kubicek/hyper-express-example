# clock.rb:  Displays the current time
class Clock < Hyperloop::Component
  param format: '%a, %e %b %Y %H:%M'
  before_mount do
    mutate.time Time.now.strftime(params.format)
    mutate.running true
    get_last_bitcoin_price
    every(1) { mutate.time Time.now.strftime(params.format) if state.running}
    every(10) { get_last_bitcoin_price if state.running }
  end

  def get_last_bitcoin_price
    HTTP.get("https://blockchain.info/ticker").then{ |response|
      mutate.last response.json["USD"]["last"]
    }
  end

  def toggle_time
    mutate.running !state.running
  end

  render do
    div(class: "container") do
      H1 {"clock"}
      H2 {state.time}
      if state.running
        button.btn_danger.btn_xs {'STOP'}
      else
        button.btn_success.btn_xs {'START'}
      end.on(:click) { toggle_time }
      div.jumbotron do
        h1 { "BTC/USD #{state.last}" }
        button.btn_default.btn_xs {'REFRESH'}.on(:click){ get_last_bitcoin_price }
      end
    end
  end
end
