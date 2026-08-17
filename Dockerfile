# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.2.4
FROM ruby:$RUBY_VERSION-slim as base

LABEL fly_launch_runtime="rails"

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1"

# Install base packages
# nodejs is required for assets:precompile — this branch enables the
# uglifier JS compressor, and there is no JS runtime in ruby-slim images.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq-dev \
      curl \
      build-essential \
      libvips \
      nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


# Copy application code
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy the rest of the application
COPY . .

# Precompile assets
# SECRET_KEY_BASE is required for Rails to boot in production, but assets:precompile
# doesn't use it for anything sensitive. A dummy value is fine here; the real value
# is injected at runtime by Fly secrets.
ARG SECRET_KEY_BASE=dummy_secret_key_base_for_assets_precompile
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
RUN bundle exec rake assets:precompile

# Create directory for puma socket
RUN mkdir -p tmp/pids

# Start the server
EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "tcp://0.0.0.0:3000"]
