rpcclient-rb
============

 A Ruby class which wraps the rpcclient tool to make easily available from your Ruby scripts/apps

Basic Connection with Clear Text Credentials:
```ruby
client = RubyRPCClient.new('192.168.1.69', 139, 'IPC$', 'Administrator', 'P@ssw0rd1', nil, false)
if not client.nil?
  puts "Connected with valid user & clear-text password!"
  puts "Scraping some basic info now....."
  output = client.rpc_cmd('lsaenumsid')
  puts output.to_s
else
  puts "Failed to Connect!"
end
```
