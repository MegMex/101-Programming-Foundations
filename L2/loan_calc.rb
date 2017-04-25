require 'yaml'
MESSAGES = YAML.load_file('loan_calc_prompts.yml')

def prompt(sentence)
	puts "#{sentence}"
end

def valid_loan?(num)
  num.to_i.to_s == num && num.to_i > 0
end

def valid_rate?(num)
  num.to_f.to_s == num && num.to_f <= 100
end

def valid_duration?(num)
  num.to_i.to_s == num
end

def monthly_payment(loan,duration,aprate)
	monthly_interest = (aprate.to_f / 100) / 12
	months = duration.to_i * 12
	(loan.to_f * (monthly_interest / (1 -(1 + monthly_interest)**-months))).round(2)
end

welcome_prompt = <<-MSG
	This loan calculator will help you determine the monthly payments and interest on a loan.
	It can be used for mortgage, auto, or any other fixed loan types.
	Please enter your name and then we'll get started:
MSG

prompt(MESSAGES['title'])
prompt(welcome_prompt)

name = ''
loop do
	name = gets.chomp

	if name.empty?()
		prompt(MESSAGES['valid_name'])
	else
		break
	end
end

prompt("Hi #{name}!")

loop do
	loan = ''
	loop do
		prompt(MESSAGES['loan_amt'])
		loan = gets.chomp.gsub(/([$,])/, '')

		if valid_loan?(loan)                 
			break
		else
			prompt(MESSAGES['valid_number'])
		end
	end

	duration = ''
	loop do
		prompt(MESSAGES['loan_dur'])
		duration = gets.chomp

		if valid_duration?(duration)
			break
		else
			prompt(MESSAGES['valid_number'])
		end
	end

	aprate = ''
	loop do
		prompt(MESSAGES['apr_prompt'])
		aprate = gets.chomp.gsub(/([%])/, '')

		if valid_rate?(aprate)
			break
		else
			prompt(MESSAGES['valid_number'])
		end
	end

	prompt(MESSAGES['month_pay'])
	prompt("$#{format('%.2f',monthly_payment(loan, duration, aprate))}")
	prompt(MESSAGES['months_dur'])
	prompt(((months = duration.to_i * 12).to_s) + " months")
	prompt(MESSAGES['month_inter'])
	prompt(((((aprate.to_f / 100) / 12)).round(5).to_s)+ "%")
	puts
	puts

	answer = ''
	loop do
		prompt(MESSAGES['again'])
		answer = gets.chomp.downcase
		if %w(y n yes no).include?(answer)
			break
		else
			prompt(MESSAGES['valid_again'])
		end
	end
	
	if %w(n no).include?(answer)
		break
	else
		system('cls')
	end
end

prompt(MESSAGES['bye'])
prompt("Good bye, #{name}!")