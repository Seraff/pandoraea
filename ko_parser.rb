#!/usr/bin/ruby
require 'csv'

class Organism
  attr_accessor :name, :kos

  def initialize(name)
    @name = name
    @kos = []
    load_data
  end

  def load_data
    f = File.open(filename, 'r')
    result = []

    f.read.each_line do |line|
      ko = parse_ko(line)
      result << ko if ko
    end

    @kos = result.compact.uniq
  end

  protected

  def parse_ko(line)
    splitted = line.split(/\s+/)
    splitted[1].downcase == 'no' ? nil : splitted[1]
  end

  def filename
    "data/#{name}"
  end
end

class Novymonadis < Organism
  protected

  def parse_ko(line)
    line.split(/\s+/)[1]
  end

  def filename
    "data/pandoraea_novymonadis.ko"
  end
end

KEGG_ORGANISMS = ['T02936',
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

organisms = []
KEGG_ORGANISMS.each do |org|
  organisms << Organism.new(org)
end

organisms << Novymonadis.new('P_NOV')

all_kos = organisms.map(&:kos).flatten.uniq

CSV.open("output.csv", "wb") do |csv|
  csv << [nil] + organisms.map(&:name)

  all_kos.each do |ko|
    row = [ko]

    organisms.each do |org|
      row << (org.kos.include?(ko) ? '1' : '0')
    end

    csv << row
  end
end
