#!/bin/env ruby

##
# Burn in a new hard disk for a NAS or just in general.
#
# This must be run as root and WILL DELETE EVERYTHING ON THE DRIVE!
#
# Adapted from https://www.truenas.com/community/resources/hard-drive-burn-in-testing.92/
#

require 'json'

class SmartDisk
  CACHE_TTL = 60

  attr_reader :bytes, :model, :path, :serial_number

  def initialize(path)
    @path = path

    if health.dig('smartctl', 'exit_status') > 0
      puts health.dig('smartctl', 'messages').map { |m| m['string'] }
      exit(1)
    end

    @bytes = health.dig('user_capacity', 'bytes')
    @model = health.dig('model_name')
    @serial_number = health.dig('serial_number')
  end

  def currently_testing?
    !!self_test_remaining_percent
  end

  def self_test_remaining_percent
    health.dig("ata_smart_data", "self_test", "status", "remaining_percent")
  end

  def gigabytes
    bytes / 1_000_000_000.0
  end

  def health
    manage_cache
    @health ||= JSON.parse(`smartctl --all -j #{path}`)
  end

  def print_test_results
    puts "Error count total: #{test_results["error_count_total"]}"
    puts "Tests:"
    test_results["table"].each do |test_result|
      puts " Type: #{test_result['type']['string']} Passed: #{test_result['status']['passed']}"
    end
  end

  def run_test!(type = 'short')
    reset_cache
    system("smartctl -t #{type} #{path}", exception: true)
  end

  def test_results
    manage_cache
    @test_results ||= (@health || JSON.parse(`smartctl -l selftest -j #{path}`))
      .dig("ata_smart_self_test_log", "standard")
  end

  private

  ##
  # Cache data in memory to avoid too many SMART queries.
  #
  def manage_cache
    return if defined?(@cache_set_at) && (@cache_set_at + CACHE_TTL > Time.now)

    reset_cache
  end

  def reset_cache
    @health = nil
    @test_results = nil
    @cache_set_at = Time.now
  end
end

disk_path=ARGV[0]
disk = SmartDisk.new(disk_path)

health = disk.health

puts "\n--Disk Info --"
puts "Model: #{disk.model}"
puts "Serial: #{disk.serial_number}"
puts "Capacity: #{disk.gigabytes} GB"
puts "++ Health ++"
puts health["device"].map { |k,v| "  #{k}: #{v}" }
puts health["smart_status"].map { |k,v| "#{k}: #{v}" }

disk.print_test_results

puts "\n ==> Ready to burn in this device?"
puts "⚠️ THIS WILL DESTROY ANY DATA ON IT! ⚠️"
puts " ...and probably take like a day."
print "(y/N) "
confirm = STDIN.gets.chomp
if confirm.downcase != 'y'
  exit
end

start_time = Time.now

puts "\n#{Time.now} Running short test..."
disk.run_test!('short')
while disk.currently_testing?
  puts "Remaining: #{disk.self_test_remaining_percent}%"
  sleep SmartDisk::CACHE_TTL
end
puts "#{Time.now} done."
disk.print_test_results

puts "\n#{Time.now}Running long test..."
disk.run_test!('long')
while disk.currently_testing?
  puts "Remaining: #{disk.self_test_remaining_percent}%"
  sleep SmartDisk::CACHE_TTL
end
disk.print_test_results

puts "\n#{Time.now}Running badblocks. This could take many hours..."
system("badblocks -b 4096 -ws #{disk_path}"

puts "\n#{Time.now}Running long test again..."
disk.run_test!('long')
while disk.currently_testing?
  puts "Remaining: #{disk.self_test_remaining_percent}%"
  sleep(SmartDisk::CACHE_TTL * 4)
end
disk.print_test_results

end_time = Time.now
duration = (end_time - start_time).to_i
duration_h = duration / 60 / 60
duration_m = duration / 60 % 60
duration_s = duration % 60 % 60
puts "\nCompleted in #{duration_h}h#{duration_m}m#{duration_s}s"
