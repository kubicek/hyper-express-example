# clock.rb:  Displays the current time
class Clock < Hyperloop::Component
  param format: '%a, %e %b %Y %H:%M:%S'
  before_mount do
    mutate.auto_refresh true
    get_last_bitcoin_price
    every(10) { get_last_bitcoin_price if state.auto_refresh }
  end

  def get_last_bitcoin_price
    HTTP.get("https://blockchain.info/ticker").then{ |response|
      mutate.time Time.now.strftime(params.format)
      mutate.last response.json["USD"]["last"]
    }
  end

  render do
    DIV.container do
      H1 {"Bitcoin"}
      div.jumbotron do
        h1 { "BTC/USD #{state.last}" }
        p { "Fetched at #{state.time}" }
        if state.auto_refresh
          button.btn_danger.btn_xs {'STOP'}
        else
          button.btn_success.btn_xs {'START'}
        end.on(:click) { mutate.auto_refresh !state.auto_refresh }
        button.btn_default.btn_xs {'REFRESH'}.on(:click){ get_last_bitcoin_price }
      end
    end
  end
end
