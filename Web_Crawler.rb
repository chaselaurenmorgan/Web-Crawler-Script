require 'selenium-webdriver'
require 'gmail'
require 'yaml'




un_pw = YAML.load_file("un_pw.yaml")
username =  un_pw["username"]
password =  un_pw["password"]


@urls = []
email_body = " "

inFile = File.open("urls.txt")


while line = inFile.gets
  @urls << line.to_s.chomp
end


for test_urls in @urls
    driver = Selenium:: WebDriver.for :chrome
    driver.navigate.to "https://www.webpagetest.org/"
    driver.find_element(:id, "url").send_keys("#{test_urls}")
    driver.find_element(:class, "start_test").click
  

wait = Selenium::WebDriver::Wait.new(:timeout => 80)
wait.until { driver.find_element(:id => "LoadTime") }
wait.until { driver.find_element(:id => "TTFB") }

driver.find_element(:id, 'LoadTime').text
driver.find_element(:id, 'TTFB').text

puts driver.find_element(:id, "LoadTime").text
puts ' '
puts driver.find_element(:id, "TTFB").text

load_time = driver.find_element(:id, "LoadTime").text
time_to_first_byte = driver.find_element(:id, "TTFB").text

email_body = email_body + "\n" + "From #{test_urls} values are #{time_to_first_byte }(TTFB) and #{load_time}(LoadTime)
"
end 



gmail = Gmail.connect("#{username}", "#{password}")
email = gmail.compose do
  to "chasemorgan15@yahoo.com"
  subject "First Testing Script"
  body "Here is your data: " + email_body
end
email.deliver!
sleep 50
