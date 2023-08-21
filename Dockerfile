FROM ruby:3.2
ENV RUBY_YJIT_ENABLE=1
WORKDIR /app

#COPY Gemfile .
#COPY Gemfile.lock .
#RUN bundle install
#
#COPY . .
#
#EXPOSE 3000
#CMD ["rackup"]
