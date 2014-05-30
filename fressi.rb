#!/usr/bin/env ruby
require 'rubygems'
require 'mechanize'
require 'date'

login_url = 'https://fressi.bypolar.fi/web/1/webPage.html'
data_url = 'http://fressi.bypolar.fi/mobile/1/history.html'

username = 'CHANGEME'
password = 'CHANGEME'

browser = Mechanize.new
browser.get(login_url) do |page|
  login_form = page.form_with(:action => 'https://fressi.bypolar.fi/web/1/webPage.html') do |form|
    form.field_with(:name => 'login').value = username
    form.field_with(:name => 'password').value = password
    form.submit
  end
end

begin
  browser.get(data_url) do |page|
    html = page.parser
    html.css('li.demoh1 > a.hour-wrapper').each do |item|
      raw_date = item.css('h5').text.strip.split(' ')[0]
      date = Date.strptime(raw_date, '%d.%m.%Y').strftime('%Y-%m-%d')
      desc = item.css('h3').text.strip
      puts "#{date} - #{desc}"
    end

  end
rescue Mechanize::ResponseCodeError
  puts "Unable to get data, are you logged in?"
end