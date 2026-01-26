namespace :git do
  desc "Make random commits (10-20) to maintain daily activity"
  task auto_commit: :environment do
    state_file = Rails.root.join("tmp", "last_commit_date.txt")
    today = Date.today

    # Get the last commit date
    last_commit_date = if File.exist?(state_file)
      Date.parse(File.read(state_file).strip)
    else
      today - 1.day # If no state file, assume yesterday was last
    end

    # Check for missed days
    missed_dates = []
    current_date = last_commit_date + 1.day
    while current_date < today
      missed_dates << current_date
      current_date += 1.day
    end

    # Process missed days first
    if missed_dates.any?
      puts "⚠️  Detected #{missed_dates.size} missed day(s): #{missed_dates.map(&:to_s).join(', ')}"
      puts "Creating backdated commits...\n"

      missed_dates.each do |date|
        make_commits_for_date(date)
      end
    end

    # Make commits for today
    make_commits_for_date(today)

    # Update state file
    FileUtils.mkdir_p(File.dirname(state_file))
    File.write(state_file, today.to_s)
  end

  def make_commits_for_date(date)
    num_commits = rand(10..20)
    puts "Making #{num_commits} commits for #{date}..."

    # Distribute commits throughout the day
    base_time = date.to_time.in_time_zone + 9.hours # Start at 9 AM
    time_slots = (0...num_commits).map { |i| base_time + (i * (10.hours / num_commits)) + rand(0..1800).seconds }

    time_slots.each_with_index do |commit_time, i|
      # Create or modify a random file
      create_random_change

      # Stage the changes
      system("git add .")

      # Create commit with timestamp and random message
      commit_message = generate_commit_message

      # Set GIT_AUTHOR_DATE and GIT_COMMITTER_DATE for backdating
      formatted_time = commit_time.strftime("%Y-%m-%d %H:%M:%S")
      env_vars = {
        "GIT_AUTHOR_DATE" => formatted_time,
        "GIT_COMMITTER_DATE" => formatted_time
      }

      system(env_vars, "git commit -m '#{commit_message}'")

      puts "✓ Commit #{i + 1}/#{num_commits}: #{commit_message} (#{commit_time.strftime('%H:%M')})"
    end

    puts "✅ Successfully made #{num_commits} commits for #{date}!\n"
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
