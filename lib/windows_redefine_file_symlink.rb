# File class override of symlink behaviors
# Created by Gabe

require 'open3'

class << File
  alias_method :old_symlink, :symlink
  alias_method :old_symlink?, :symlink?
  alias_method :old_readlink, :readlink

  def symlink(old_name, new_name)
    #if on windows, call mklink, else self.symlink
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #windows mklink syntax is reverse of unix ln -s
      #windows mklink is built into cmd.exe
      #windows cmd.exe will choke on forward slash before filename.
      old_name.gsub!(/\//, '\\') #replace forward slash with a backslash. Bug case: escaped forward slashes.
      #vulnerable to command injection, but okay because this is a hack to make a cli tool work.
      stdin, stdout, stderr, wait_thr = Open3.popen3("cmd.exe /c mklink \"#{new_name}\" \"#{old_name}\"")
      #puts stdout.gets
      puts stderr.gets
      wait_thr.value.exitstatus
    else
      self.old_symlink(old_name, new_name)
    end
  end

  def symlink?(file_name)
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #vulnerable to command injection because calling with cmd.exe with /c?
      stdin, stdout, stderr, wait_thr = Open3.popen3("cmd.exe /c dir \"#{file_name}\" | find \"SYMLINK\"")
      wait_thr.value.exitstatus
    else
      self.old_symlink?(file_name)
    end
  end

  def readlink(file_name)
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #vulnerable to command injection because calling with cmd.exe with /c?
      file_name = file_name.sub(/(.*)\//,'\1\\') #replace final forward slash with backslash to workaround cmd.exe
      stdin, stdout, stderr, wait_thr = Open3.popen3("cmd.exe /c dir \"#{file_name}\" | find \"SYMLINK\"")
      wait_thr.value.exitstatus
      line = stdout.gets
      if line
        target = line.match('.+\[(.+)\]')[1]
      else
        target = nil
      end
      target
    else
      self.old_readlink?(file_name)
    end
  end
end

