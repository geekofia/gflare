require 'net/http'
require 'open-uri'
require 'json'
require 'socket'

class Gflare

  def self.red()
    red = "\033[01;31m"
  end
  def self.green()
    green = "\033[01;32m"
  end
  def self.yellow()
    yellow = "\033[01;33m"
  end
  def self.white()
    white = "\033[01;37m"
  end

  def self.banner()
    puts "\n"
    puts "       ▄████  █████▒██▓    ▄▄▄       ██▀███  ▓█████ "
    puts "      ██▒ ▀█▒▓██   ▒▓██▒   ▒████▄    ▓██ ▒ ██▒▓█   ▀ "
    puts "     ▒██░▄▄▄░▒████ ░▒██░   ▒██  ▀█▄  ▓██ ░▄█ ▒▒███   "
    puts "     ░▓█  ██▓░▓█▒  ░▒██░   ░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄ "
    puts "     ░▒▓███▀▒░▒█░   ░██████▒▓█   ▓██▒░██▓ ▒██▒░▒████▒"
    puts "      ░▒   ▒  ▒░   ░ ▒░▓  ░▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░"
    puts "       ░   ░  ░     ░ ░ ▒  ░ ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░"
    puts "     ░ ░   ░  ░ ░     ░ ░    ░   ▒     ░░   ░    ░   "
    puts "           ░            ░  ░     ░  ░   ░        ░  ░"
    puts "#{yellow}\nTool for identifying real IP of CloudFlare protected websites."
    puts "#{yellow}\n--------------------- chankruze ---------------------"
    puts "\n"
  end

  def self.bypass(target_url)
    @target_url = target_url
    system "clear"
    banner()
  if target_url == nil
    puts "\n#{green}Usage : gflare www.example.com"
  else
    puts "#{green}**CHECKING TARGET ADDRESS - STAND BY**"
    option = target_url
    payload = URI ("http://www.crimeflare.org:82/cgi-bin/cfsearch.cgi")
    request = Net::HTTP.post_form(payload, 'cfS' => target_url)
          response =  request.body
    nscheck = /No working nameservers are registered/.match(response)
    if( !nscheck.nil? )
      puts "[✘] No valid address - are you sure this is a CloudFlare protected domain?\n"
      exit
    end

    red = "\033[01;31m"
    regex = /(\d*\.\d*\.\d*\.\d*)/.match(response)
    if( regex.nil? || regex == "" )
      puts "#{red}[✘] No valid address - are you sure this is a CloudFlare protected domain?\n"
      puts "[✘] Alternately,Try it by hand.\n"
      exit
    end

    ip_real = IPSocket.getaddress (target_url)
    puts "\n"
    puts "#{yellow}[✔] Target : #{option}"
    puts "[✔] CloudFlare IP : #{ip_real}"
    puts "[✔] Real IP : #{regex}"
    target = "http://ipinfo.io/#{regex}/json"
    url = URI(target).read
    json = JSON.parse(url)
    puts "[✔] Hostname : " + json['hostname']
    puts "[✔] City : "  + json['city']
    puts "[✔] Region : " + json['country']
    puts "[✔] Location : " + json['loc']
    puts "[✔] Organization : " + json['org']
    puts "\n"
    puts "#{red}----------- https://github.com/chankruze -----------"
  end
end
end
