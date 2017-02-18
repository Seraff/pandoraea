#!/usr/bin/ruby
require 'faraday'

API_URL = 'http://rest.kegg.jp'

def list_url(organism)
  "#{API_URL}/list/#{organism}"
end

ORGANISMS = ['T02936',
             'T03067',
             'T03411',
             'T02950',
             'T03553',
             'T03554',
             'T03588',
             'T03688',
             'T03840',
             'T03947',
             'T03972',
             'T04226']

 ORGANISMS.each do |org|
   puts "Dumping organism #{org}"

   response = Faraday.get list_url(org)
   f = File.open("data/#{org}", 'w')
   f.write response.body
   f.close
 end
