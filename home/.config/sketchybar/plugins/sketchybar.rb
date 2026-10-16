require "open3"
require "timeout"

module SketchyBar
  ENVIRONMENT = { "PATH" => "/opt/homebrew/bin:#{ENV.fetch("PATH", "")}" }.freeze

  def self.capture(*command, timeout: 5, stdin_data: nil)
    Open3.popen2(ENVIRONMENT, *command, err: File::NULL, pgroup: true) do |input, output, process|
      Timeout.timeout(timeout) do
        input.write(stdin_data) if stdin_data
        input.close
        output.set_encoding(Encoding::UTF_8)
        result = output.read
        process.value.success? ? result : nil
      end
    rescue Timeout::Error
      Process.kill("KILL", -process.pid) if process.alive?
      nil
    end
  end

  def self.update(items)
    return true if items.empty?

    arguments = items.flat_map do |name, properties|
      ["--set", name, *properties.map { |key, value| "#{key}=#{value}" }]
    end
    system(ENVIRONMENT, "sketchybar", *arguments, exception: true)
  end
end
