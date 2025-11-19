FROM ruby:alpine

# Install Jekyll and Bundler
RUN apk add --no-cache build-base ruby-dev \
    && gem install jekyll bundler

WORKDIR /site

# Expose the Jekyll server port
EXPOSE 4000

# Default command to run Jekyll server
CMD ["bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000"]
