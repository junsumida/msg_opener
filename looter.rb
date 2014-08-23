require 'mechanize'
require 'pry-debugger'
require 'launchy'

domain = ''
email = ''
password = ''
 
def get_url(mech)
  msg = mech.get("http://#{domain}/list_message.pl?box=inbox")
  msg_list = Nokogiri.HTML(msg.body.encode('utf-8', 'EUC-JP'))
  detailed_list = msg_list.css('.messageListBody').first.css('.tableBody').children
  
  if detailed_list.search('td').search('img').first['alt'] == '未開封'
   url = detailed_list.search('a')[1]['href']
   Launchy.open("http://#{domain}/#{suffix}")
  end
end

def polling
mech = Mechanize.new
mech.agent.http.debug_output = $stderr

page = mech.get("http://#{domain}/")
page.form.fields[3].value = email 
page.form.fields[4].value = password 
new_page = page.form.submit

  loop do
    get_url(mech)
    sleep(5)
  end
end

polling

# binding.pry
