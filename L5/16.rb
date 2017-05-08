# write a method that returns one UUID when called with no parameters
# 5 sections split by -
# total of 32 characters
# made up with random numbers (0 - 9) and letters (a - z)

require 'securerandom'

string = ''

def uuid()
	string = SecureRandom.hex(32)
	sec_1 = string.slice(0...8)
	sec_2 = string.slice(8...12)
	sec_3 = string.slice(12...16)
	sec_4 = string.slice(16...20)
	sec_5 = string.slice(20...32)
	[sec_1, sec_2, sec_3, sec_4, sec_5].join("-")
end

def generate_UUID
  characters = []
  (0..9).each { |digit| characters << digit.to_s }
  ('a'..'f').each { |digit| characters << digit }

  uuid = ""
  sections = [8, 4, 4, 4, 12]
  sections.each_with_index do |section, index|
    section.times { uuid += characters.sample }
    uuid += '-' unless index >= sections.size - 1
  end

  uuid
end

p uuid
p generate_UUID