class NamecoinDaemon
  def self.instance
    @namecoin_daemon ||= NamecoinDaemon.new(CONFIG['namecoin'])
  end

  class NMCError < StandardError
    attr_accessor :code
    def initialize(code, message)
      @code = code
      super(message)
    end
  end

  attr_reader :config

  def initialize(config)
    @config = config || {}
  end

  def rpc(command, *params)
    %w( username password port host ).each do |field|
      raise "No #{field} provided in namecoin config" if config[field].blank?
    end

    uri = URI::HTTP.build(host: config['host'], port: config['port'].to_i)

    auth = config.slice('username', 'password').symbolize_keys

    data = {
      method: command,
      params: params,
      id: 1,
    }

    response = HTTParty.post(uri.to_s, body: data.to_json, basic_auth: auth)

    result = JSON.parse(response.body)
    if error = result["error"]
      raise NMCError.new(error["code"], error["message"])
    end
    result["result"]
  end

  def get_new_address(account = "")
    rpc('getnewaddress', account)
  end

  def list_transactions(account = "", count = 10, from = 0)
    rpc('listtransactions', account, count, from)
  end

  def send_many(account, recipients, minconf = 1)
    recipients = recipients.dup
    recipients.each do |address, amount|
      recipients[address] = amount.to_f
    end
    rpc('sendmany', account, recipients, minconf)
  end
end
