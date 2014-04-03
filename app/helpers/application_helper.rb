module ApplicationHelper
  def btc_human amount, options = {}
    return nil unless amount
    nobr = options.has_key?(:nobr) ? options[:nobr] : true
    currency = options[:currency] || false
    btc = "%.8f NMC" % to_btc(amount)
    btc = "<span class='convert-from-btc' data-to='#{currency.upcase}'>#{btc}</span>" if currency
    btc = "<nobr>#{btc}</nobr>" if nobr
    btc.html_safe
  end

  def to_btc satoshies
    satoshies.to_d / NamecoinBalanceUpdater::COIN if satoshies
  end

  def transaction_url(txid)
    "http://http://explorer.namecoin.info/tx/#{txid}"
  end
end
