# Daily Git Committer

A Rails application that automatically makes 10-20 random commits to your git repository daily. Perfect for maintaining contribution activity or testing git workflows.

## Features

- Generates random commits (10-20 per run)
- Creates various types of code changes:
  - Ruby code files
  - Helper modules
  - Activity logs
  - Documentation notes
- Natural commit timing with random delays
- Varied commit messages
- Fully automated with cron job

## Requirements

- Ruby (version in `.ruby-version`)
- Rails 7.1+
- Git

## Installation

1. Clone or navigate to this repository
2. Install dependencies:
   ```bash
   bundle install
   ```

3. Ensure git is initialized (already done by default)

## Usage

### Manual Execution

To manually run the auto-commit task:

```bash
rake git:auto_commit
```

This will:
- Generate a random number between 10-20
- Make that many commits with random code changes
- Use varied commit messages
- Add small delays between commits for natural timing

### Automated Daily Execution with Cron

To set up daily automated commits using cron:

#### 1. Find Your Full Paths

First, get the full path to this directory and your Ruby/Rake executables:

```bash
# Get current directory path
pwd

# Get Ruby path
which ruby

# Get bundle path
which bundle
```

#### 2. Edit Your Crontab

Open your crontab for editing:

```bash
crontab -e
```

#### 3. Add the Cron Job

Add one of these lines (choose based on when you want commits to run):

**Run daily at 9 AM:**
```bash
0 9 * * * cd /Users/middwin/code/middwinantony/daily-git-committer && /usr/bin/bundle exec rake git:auto_commit >> /tmp/git-auto-commit.log 2>&1
```

**Run daily at midnight:**
```bash
0 0 * * * cd /Users/middwin/code/middwinantony/daily-git-committer && /usr/bin/bundle exec rake git:auto_commit >> /tmp/git-auto-commit.log 2>&1
```

**Run daily at 6 PM:**
```bash
0 18 * * * cd /Users/middwin/code/middwinantony/daily-git-committer && /usr/bin/bundle exec rake git:auto_commit >> /tmp/git-auto-commit.log 2>&1
```

**Important:** Replace `/Users/middwin/code/middwinantony/daily-git-committer` with your actual project path, and `/usr/bin/bundle` with your actual bundle path.

#### 4. Verify Cron Job

List your cron jobs to verify:

```bash
crontab -l
```

#### 5. Check Logs

Monitor the execution logs:

```bash
tail -f /tmp/git-auto-commit.log
```

### Cron Schedule Format

The cron format is: `minute hour day month weekday command`

Examples:
- `0 9 * * *` - Every day at 9:00 AM
- `30 14 * * *` - Every day at 2:30 PM
- `0 */6 * * *` - Every 6 hours
- `0 9 * * 1-5` - Every weekday at 9:00 AM

## What Gets Committed

The rake task creates files in `lib/daily_commits/` directory:

- **Ruby code files**: Random Ruby classes with methods
- **Helper modules**: Utility helper modules
- **Activity logs**: Timestamped activity entries
- **Notes**: Markdown documentation notes

Each commit includes one of these file types with realistic commit messages like:
- "Update code structure"
- "Add helper methods"
- "Refactor utilities"
- "Improve logging system"
- And more...

## Pushing to Remote

By default, commits are only made locally. To push to a remote repository:

### Option 1: Manual Push

```bash
git push origin master
```

### Option 2: Automated Push in Cron

Modify the cron job to include a push:

```bash
0 9 * * * cd /path/to/daily-git-committer && /path/to/bundle exec rake git:auto_commit && git push origin master >> /tmp/git-auto-commit.log 2>&1
```

**Warning:** Ensure your git credentials are properly configured for automated pushing (SSH keys or credential helper).

## Customization

To customize the behavior, edit `lib/tasks/auto_commit.rake`:

- Change commit range: Modify `rand(10..20)` on line 5
- Add more commit messages: Update the `generate_commit_message` method
- Change file types: Modify the `create_random_change` method
- Adjust delays: Change `sleep(rand(1..3))` on line 22

## Troubleshooting

### Cron Job Not Running

1. Check cron service is running:
   ```bash
   # macOS
   sudo launchctl list | grep cron

   # Linux
   sudo service cron status
   ```

2. Verify full paths in crontab
3. Check logs at `/tmp/git-auto-commit.log`
4. Ensure the script has proper permissions

### Git Errors

1. Ensure git user is configured:
   ```bash
   git config user.name "Your Name"
   git config user.email "your.email@example.com"
   ```

2. Check repository status:
   ```bash
   git status
   ```

## Notes

- All commits are made to the current branch (usually `master` or `main`)
- Files are created in `lib/daily_commits/` which is tracked by git
- Each run is independent and can be run multiple times per day
- The random number ensures variability in daily commit counts

## License

This project is provided as-is for personal use.
