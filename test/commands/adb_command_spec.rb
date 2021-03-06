require 'helper'

class AdbCommandSpec < CommandSpecBase

  describe "a basic adb command" do
    before do
      @command = silent AdbCommand.new(@repl, "devices")
      @result  = @command.execute
    end

    it "sends the command to adb" do
      @command.shell_capture.must_equal "adb devices 2>&1"
    end

    it "captures the process ID and exit code" do     
      @result.code.must_equal $?.exitstatus
      @result.pid.must_equal $?.pid
    end

    it "prints its output to the REPL" do
      @command = AdbCommand.new(@repl, "devices")
      lambda { @command.execute }.must_output /mock output/
    end
  end

  describe "with a default package set" do
    before do
      @repl.stubs(:default_package).returns("com.myapp")
    end

    it "does not set the default package if command is not package dependent" do
      command = silent AdbCommand.new(@repl, "devices")
      command.execute
      command.shell_capture.must_equal "adb devices 2>&1"
    end

    it "adds the default package if command is package dependent" do
      command = silent AdbCommand.new(@repl, "uninstall")
      command.execute
      command.shell_capture.must_equal "adb uninstall com.myapp 2>&1"
    end
  end

end
