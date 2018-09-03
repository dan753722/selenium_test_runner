FROM node:carbon

RUN apt-get update -q -y
RUN apt-get --yes install libnss3
RUN apt-get --yes install libgconf-2-4

    # Install chrome
    # Based off of
    # - https://gitlab.com/gitlab-org/gitlab-build-images/blob/9dadb28021f15913a49897126a0cd6ab0149e44f/scripts/install-chrome
    # - https://askubuntu.com/a/510186/196148
    #
    # # Install chrome version from apt-get
    # # -----------------------------------------------
    # # Add key
    # - curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
    # # Add repo
    # - echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
    # - apt-get update -q -y
    # # TODO: Lock down the version
    # - apt-get install -y google-chrome-stable
    #
    # Manually install chrome version from GitLab CDN
    # -----------------------------------------------
ENV CHROME_DEB="google-chrome-stable_65.0.3325.181-1_amd64.deb"
ENV CHROME_URL="https://s3.amazonaws.com/gitlab-google-chrome-stable/${CHROME_DEB}"
RUN curl --silent --show-error --fail -O $CHROME_URL
RUN dpkg -i ./$CHROME_DEB || true
RUN apt-get install -f -y
RUN rm -f $CHROME_DEB

ENV NPM_CONFIG_PREFIX="/home/node/.npm-global"

USER node

RUN npm install chromedriver@2.36.0 -g
RUN npm install https://gitlab.com/gitlab-org/gitlab-selenium-server.git -g

RUN nohup chromedriver &
RUN nohup selenium-gitlab-server &

#ENTRYPOINT [ "chromedriver" ]
