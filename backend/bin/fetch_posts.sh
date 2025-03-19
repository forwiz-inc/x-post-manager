#!/bin/bash
cd "$(dirname "$0")/.."
RAILS_ENV=production bundle exec rails runner "Api::V1::ScheduledTasksController.new.fetch_posts"
