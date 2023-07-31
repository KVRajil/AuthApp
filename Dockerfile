FROM ruby:3.0.2
ARG COMMIT
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /auth_app
WORKDIR /auth_app
COPY Gemfile /auth_app/Gemfile
COPY Gemfile.lock /auth_app/Gemfile.lock
RUN bundle lock --add-platform x86_64-linux
RUN bundle check || bundle install
COPY . /auth_app
RUN echo $COMMIT > /auth_app/config/revision.txt

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
