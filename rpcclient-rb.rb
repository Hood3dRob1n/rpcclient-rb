# rpcclient wrapper to make life easier
# By: Hood3dRob1n

class RubyRPCClient
  require 'pty'
  require 'expect'
  require 'tempfile'

  def initialize(host='127.0.01', port=139, share='IPC$', user='Administrator', pass=nil, domain=nil, hashpass=false)
    @host     = host
    @port     = port.to_i
    @share    = share
    @user     = user
    @pass     = pass
    @domain   = domain
    @hashpass = hashpass
    rpcclient = commandz('which rpcclient')[0]
    if rpcclient.nil? or rpcclient == ''
      puts
      @rpcclient = nil
      raise("Fatal Error: Can not find RPCCLIENT!\n\n")
      exit(666);
    else
      @rpcclient = rpcclient.chomp
    end
  end

  def commandz(foo)
    bar = IO.popen("#{foo}")
    foobar = bar.readlines
    return foobar
  end

  # Return an array of the connection info
  def client_creds
    return @rpcclient, @host, @port, @share, @user, @pass, @domain
  end

  # Check if we can connect with credentials
  # Returns true on success, false otherwise
  # Sets $os var based on response for recall later
  def can_we_connect?
    file = Tempfile.new('ruby_rpcclient')
    if @hashpass
      connected = system("#{@rpcclient} #{@host} -p #{@port} --pw-nt-hash -U #{@user}%#{@pass} -c 'lsaenumsid' > #{file.path} 2>&1")
    else
      connected = system("#{@rpcclient} #{@host} -p #{@port} -U #{@user}%#{@pass} -c 'lsaenumsid' > #{file.path} 2>&1")
    end
    res = File.open(file.path).readlines
    file.unlink
    if connected
      return true
    else
      return false
    end
  end

  # Run an rpcclient command (-c) of your choosing
  # Returns results from output as response array (line by line)
  def rpc_cmd(cmd)
    file = Tempfile.new('ruby_rpcclient')
    if @hashpass
      success = system("#{@rpcclient} #{@host} -p #{@port} --pw-nt-hash -U #{@user}%#{@pass} -c #{cmd} > #{file.path} 2>&1")
    else
      success = system("#{@rpcclient} #{@host} -p #{@port} -U #{@user}%#{@pass} -c #{cmd} > #{file.path} 2>&1")
    end
puts "#{@rpcclient} #{@host} -p #{@port} -U #{@user}%#{@pass} -c #{cmd} > #{file.path} 2>&1"
puts success.class
    if success
      output = File.open(file.path).readlines
puts output
    else
      output=nil
    end
    file.unlink
    return output
  end

  # Let the user have an interactive RPC Shell
  # This is the default rpcclient smb shell....
  def rpc_shell
    if @hashpass
      success = system("#{@rpcclient} #{@host} -p #{@port} --pw-nt-hash -U #{@user}%#{@pass}")
    else
      success = system("#{@rpcclient} #{@host} -p #{@port} -U #{@user}%#{@pass}")
    end
  end
end

