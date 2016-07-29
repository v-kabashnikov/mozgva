class SmsSender
  def initialize
    @sender = 'MOZGVA'
  end
  def send phone, message
    sms = Sms.new(phone, message)
    res = perform sms
    set_status(sms, res)
    sms
  end
end
