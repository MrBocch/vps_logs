
def tally_logs(file)
  ips = Hash.new(0)
  ports = Hash.new(0)
  users = Hash.new(0)

  File.open(file) do |f|
    sshd = []
    f.each_line do |line|
      s = line.split(' ')
      month = s[0]
      day = s[1]
      time = s[2]
      machine = s[3]
      proc = s[4]
      sshd << s[5..s.size].join(' ') if proc.start_with?('sshd')
    end
    sshd.each do |s|
      log = s.split(" ")
      cmd = log[0]
      if cmd == 'Invalid'
        users[log[2]] += 1
        ips[log[4]] += 1
        ports[log[6]] += 1
      end
    end
  end
  return [users, ips, ports]
end

def writeCSV(file, header, tally)
  File.open("csv/#{file}.csv", 'w+') do |f|
    f.write(header)
    tally.sort_by{|k,v| -v}.each do |l|
      f.write "\n#{l[0]},#{l[1]}"
    end
  end
end

users, ips, ports = tally_logs('logs.txt')

writeCSV('users', 'user,attempts', users)
writeCSV('ips', 'ip,attempts', ips)
writeCSV('ports', 'port,attempts', ports)
