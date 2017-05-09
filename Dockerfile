# Docker file to create a local Docker container for Google Chrome
FROM ubuntu:16.04.1
MAINTAINER Kanti Jadia

# debconf to be non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Repository info up to date 
RUN apt-get update

# Install wget 
RUN apt-get install -y wget sudo

# Get Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &&\
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' &&\
sudo apt-get update &&\
sudo apt-get install -y google-chrome-unstable

# Add the Chrome user that will run the browser
RUN adduser --disabled-password --gecos "Chrome User" --uid 500 chrome 
RUN echo "chrome ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/chrome  
RUN chmod 0440 /etc/sudoers.d/chrome  
RUN export uid=500 gid=500  

EXPOSE 9222

USER chrome
ENV HOME /home/chrome
CMD /usr/bin/google-chrome --headless \
--disable-gpu \
--remote-debugging-port=9222 'about:blank' &
