# Quick Cron Setup Guide

## Step-by-Step Instructions

### 1. Get Your Paths

Run these commands to get the information you need:

```bash
# In the daily-git-committer directory
pwd
# Copy this path - you'll need it for the cron job

which bundle
# Copy this path too
```

### 2. Open Crontab

```bash
crontab -e
```

This will open your crontab file in your default editor (usually vim or nano).

### 3. Add This Line

Replace the paths with your actual paths from step 1:

```bash
0 9 * * * cd /Users/middwin/code/middwinantony/daily-git-committer && /usr/bin/bundle exec rake git:auto_commit >> /tmp/git-auto-commit.log 2>&1
```

**Breakdown of this command:**
- `0 9 * * *` - Runs at 9:00 AM every day
- `cd /path/to/project` - Navigate to project directory
- `&& /path/to/bundle exec rake git:auto_commit` - Run the rake task
- `>> /tmp/git-auto-commit.log 2>&1` - Log output to file

### 4. Save and Exit

- **In vim**: Press `ESC`, then type `:wq` and press Enter
- **In nano**: Press `CTRL+X`, then `Y`, then Enter

### 5. Verify It's Set Up

```bash
crontab -l
```

You should see your new cron job listed.

### 6. Check Logs After It Runs

```bash
cat /tmp/git-auto-commit.log
```

Or watch it in real-time:

```bash
tail -f /tmp/git-auto-commit.log
```

## Alternative Times

Want to run at a different time? Change the first part:

- **Midnight**: `0 0 * * *`
- **Noon**: `0 12 * * *`
- **6 PM**: `0 18 * * *`
- **Every 12 hours**: `0 */12 * * *`
- **Weekdays only at 9 AM**: `0 9 * * 1-5`

## Test It Immediately

Don't want to wait? Test the command manually first:

```bash
cd /Users/middwin/code/middwinantony/daily-git-committer
bundle exec rake git:auto_commit
```

If this works, your cron job will work too.

## Troubleshooting

### Cron Not Running on macOS

On macOS, you may need to give Terminal full disk access:

1. Open **System Preferences** > **Security & Privacy** > **Privacy**
2. Select **Full Disk Access**
3. Add your terminal app (Terminal.app or iTerm.app)

### Want to Remove the Cron Job?

```bash
crontab -e
```

Delete the line you added, then save and exit.

Or remove all cron jobs:

```bash
crontab -r
```

## Adding Automatic Push to GitHub

If you want commits to be pushed automatically:

```bash
0 9 * * * cd /path/to/daily-git-committer && /path/to/bundle exec rake git:auto_commit && git push origin master >> /tmp/git-auto-commit.log 2>&1
```

**Note:** Make sure you have SSH keys set up with GitHub or use a credential helper so you don't need to enter a password.
