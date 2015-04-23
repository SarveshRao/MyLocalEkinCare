require 'rubyXL'

namespace :eKincare do
  task seed_providers: :environment do

    puts "Do you want to delete old providers data(yes/no)"
    option = STDIN.gets.chomp

    if(option == "yes")
      puts "deleting old data..."
      c = Provider.count
      Provider.delete_all
      puts "#{c} providers deleted!"
    end

    puts 'seeding providers from excel...'

    workbook = RubyXL::Parser.parse(File.expand_path('db/partners_list_2.xlsx'))
    worksheet = workbook[0]
    worksheet.each_with_index do |row, index|
      if index > 0
        begin
          id = row[0].value
          zip = row[7].value == 'null' ? row[7].value : ''
          poc = row[8].value
          type = row[1].value
          city = row[5].value
          state = row[6].value
          email = row[11].value
          number = row[9].value
          branch = row[3].value
          street = row[4].value
          partner_name = row[2].value
          offline_number = row[10].value

          provider = Provider.find_or_create_by(provider_id: id)
          provider.name = partner_name
          provider.telephone = number
          provider.provider_type = type
          provider.branch = branch
          provider.poc = poc
          provider.offline_number = offline_number
          provider.email = email
          provider.save!

          addr = provider.addresses.first

          if provider.addresses.empty?
            provider.addresses.create(line1: street, city: city, state: state, country: '', zip_code: zip)
          else
            addr.update(line1: street, city: city, state: state, country: '', zip_code: zip)
            addr.save!
          end

          #p = Provider.find_or_create_by(name: partner_name, telephone: number, provider_type: type, branch: branch, poc: poc, offline_number: offline_number, email: email, provider_id: id)
          #p.addresses.create(line1: street, city: city, state: state, zip_code: zip, country: '')

        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
        end
      end
    end
    puts "#{Provider.count} provider were created!"

    #providers_json = Provider.all.to_json(except: [:id, :created_at, :updated_at], include: {addresses: {except: [:id, :created_at, :updated_at, :addressee_type, :addressee_id]}})
    #File.open(File.expand_path('db/providers.json'), 'w') { |f| f.write providers_json }
  end
end
