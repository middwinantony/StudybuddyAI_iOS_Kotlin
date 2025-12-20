namespace :git do
  desc "Make random commits (10-20) to maintain daily activity"
  task auto_commit: :environment do
    # Generate random number of commits between 10 and 20
    num_commits = rand(10..20)
    puts "Making #{num_commits} commits today..."

    num_commits.times do |i|
      # Create or modify a random file
      create_random_change

      # Stage the changes
      system("git add .")

      # Create commit with timestamp and random message
      commit_message = generate_commit_message
      system("git commit -m '#{commit_message}'")

      puts "✓ Commit #{i + 1}/#{num_commits}: #{commit_message}"

      # Small delay to make commits appear more natural
      sleep(rand(1..3))
    end

    puts "\n✅ Successfully made #{num_commits} commits!"
  end

  def create_random_change
    change_type = rand(1..4)

    case change_type
    when 1
      create_random_ruby_file
    when 2
      modify_existing_log
    when 3
      create_random_helper
    when 4
      update_notes_file
    end
  end

  def create_random_ruby_file
    dir = Rails.root.join("lib", "daily_commits")
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    filename = "code_#{Time.now.to_i}_#{rand(1000..9999)}.rb"
    filepath = dir.join(filename)

    content = generate_random_ruby_code
    File.write(filepath, content)
  end

  def modify_existing_log
    dir = Rails.root.join("lib", "daily_commits")
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    filepath = dir.join("activity_log.txt")
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    log_entry = "#{timestamp} - Activity logged: #{random_activity}\n"

    File.open(filepath, "a") { |f| f.write(log_entry) }
  end

  def create_random_helper
    dir = Rails.root.join("lib", "daily_commits", "helpers")
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    filename = "helper_#{rand(1000..9999)}.rb"
    filepath = dir.join(filename)

    helper_code = <<~RUBY
      # Generated helper at #{Time.now}
      module DailyCommits
        module Helper#{rand(1000..9999)}
          def self.#{random_method_name}
            # TODO: Implement functionality
            "#{random_string}"
          end
        end
      end
    RUBY

    File.write(filepath, helper_code)
  end

  def update_notes_file
    dir = Rails.root.join("lib", "daily_commits")
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

    filepath = dir.join("notes.md")
    note = "\n## #{Time.now.strftime('%Y-%m-%d %H:%M')}\n#{random_note}\n"

    File.open(filepath, "a") { |f| f.write(note) }
  end

  def generate_random_ruby_code
    method_name = random_method_name
    <<~RUBY
      # Generated at #{Time.now}
      # Purpose: #{random_purpose}

      class RandomCode#{rand(1000..9999)}
        def self.#{method_name}
          puts "#{random_string}"
        end

        def self.calculate
          result = #{rand(1..100)} + #{rand(1..100)}
          result * #{rand(1..10)}
        end
      end
    RUBY
  end

  def generate_commit_message
    messages = [
      "Update code structure",
      "Add helper methods",
      "Refactor utilities",
      "Update documentation",
      "Add logging functionality",
      "Improve code organization",
      "Update activity logs",
      "Add new helper class",
      "Enhance functionality",
      "Update notes and comments",
      "Add utility methods",
      "Refactor helper modules",
      "Update timestamp tracking",
      "Add code examples",
      "Improve logging system"
    ]

    messages.sample
  end

  def random_method_name
    prefixes = ["process", "handle", "calculate", "generate", "fetch", "parse", "validate"]
    suffixes = ["data", "input", "result", "value", "info", "request", "response"]
    "#{prefixes.sample}_#{suffixes.sample}"
  end

  def random_string
    phrases = [
      "Processing complete",
      "Operation successful",
      "Task executed",
      "Data validated",
      "Function called",
      "Method invoked",
      "Result generated"
    ]
    phrases.sample
  end

  def random_purpose
    purposes = [
      "Helper utility for data processing",
      "Auxiliary function for calculations",
      "Support method for operations",
      "Utility class for common tasks",
      "Helper for data validation"
    ]
    purposes.sample
  end

  def random_activity
    activities = [
      "Code review completed",
      "Feature analysis",
      "Performance check",
      "Documentation update",
      "Code refactoring",
      "Testing utilities",
      "Bug investigation"
    ]
    activities.sample
  end

  def random_note
    notes = [
      "- Reviewed code structure and organization",
      "- Analyzed performance metrics",
      "- Updated helper methods for better efficiency",
      "- Added utility functions for common operations",
      "- Refactored code for improved readability",
      "- Enhanced logging and monitoring capabilities"
    ]
    notes.sample
  end
end
